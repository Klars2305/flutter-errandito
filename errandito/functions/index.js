const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

const db = admin.firestore();

function runtimeConfig() {
  try {
    return functions.config && functions.config() ? functions.config() : {};
  } catch (e) {
    return {};
  }
}

function hitpayApiKey() {
  const cfg = runtimeConfig();

  const key =
    (cfg.hitpay && cfg.hitpay.api_key) ||
    process.env.HITPAY_API_KEY ||
    "";

  if (!key) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      'Missing HitPay API key. Run: firebase functions:config:set hitpay.api_key="YOUR_SANDBOX_API_KEY" then deploy again.'
    );
  }

  return key.trim();
}

function hitpayApiUrl() {
  const cfg = runtimeConfig();

  return (
    (cfg.hitpay && cfg.hitpay.api_url) ||
    process.env.HITPAY_API_URL ||
    "https://api.sandbox.hit-pay.com"
  )
    .toString()
    .trim()
    .replace(/\/$/, "");
}

function validateHitPayConfig() {
  const key = hitpayApiKey();
  const apiUrl = hitpayApiUrl();

  if (key.startsWith("live_") && apiUrl.includes("sandbox")) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Wrong HitPay setup: your API key is LIVE but your API URL is SANDBOX. Use a sandbox key with https://api.sandbox.hit-pay.com, or use https://api.hit-pay.com for a live key."
    );
  }

  if (!key.startsWith("live_") && apiUrl === "https://api.hit-pay.com") {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Wrong HitPay setup: your API URL is LIVE but your key does not look like a live key. Use https://api.sandbox.hit-pay.com for sandbox."
    );
  }

  return { key, apiUrl };
}

function normalizePaymentResponse(payment) {
  const data = payment && payment.data ? payment.data : null;

  return {
    paymentRequestId:
      payment.id ||
      payment.payment_request_id ||
      (data && data.id) ||
      (data && data.payment_request_id) ||
      null,

    checkoutUrl:
      payment.url ||
      payment.redirect_url ||
      payment.payment_url ||
      (data && data.url) ||
      (data && data.redirect_url) ||
      (data && data.payment_url) ||
      "",

    rawStatus:
      payment.status ||
      payment.payment_status ||
      (data && data.status) ||
      (data && data.payment_status) ||
      "",
  };
}

function publicHitPayError(error) {
  const status = error.response && error.response.status;
  const data = error.response && error.response.data;

  if (status === 401 || status === 403) {
    return "HitPay rejected your API key. Check if you are using sandbox key with sandbox URL, or live key with live URL.";
  }

  if (status === 400 || status === 422) {
    return `HitPay rejected the payment details: ${JSON.stringify(data)}`;
  }

  if (error.message) {
    return `HitPay request failed: ${error.message}`;
  }

  return "HitPay request failed. Check Firebase Functions logs.";
}

exports.createHitPayPayment = functions.https.onCall(async (data, context) => {
  console.log("createHitPayPayment called", {
    uid: context.auth ? context.auth.uid : null,
    data,
    apiUrl: hitpayApiUrl(),
  });

  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "You must be logged in."
    );
  }

  const errandId = data && data.errandId;

  if (!errandId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing errandId."
    );
  }

  const { key, apiUrl } = validateHitPayConfig();

  const errandRef = db.collection("errands").doc(errandId);
  const errandSnap = await errandRef.get();

  if (!errandSnap.exists) {
    throw new functions.https.HttpsError("not-found", "Errand not found.");
  }

  const errand = errandSnap.data() || {};

  console.log("Loaded errand for HitPay", {
    errandId,
    requesterId: errand.requesterId,
    runnerId: errand.runnerId,
    amount: errand.amount,
    currency: errand.currency,
    paymentMethod: errand.paymentMethod,
    paymentStatus: errand.paymentStatus,
  });

  if (errand.requesterId !== context.auth.uid) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only the requester can pay for this errand."
    );
  }

  if (!errand.runnerId) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Choose a runner before paying."
    );
  }

  if (errand.paymentStatus === "paid") {
    return {
      alreadyPaid: true,
      checkoutUrl: errand.paymentCheckoutUrl || null,
    };
  }

  if (
    errand.paymentMethod === "hitpay" &&
    errand.paymentStatus === "pending" &&
    errand.paymentCheckoutUrl
  ) {
    return {
      paymentRequestId: errand.paymentRequestId || null,
      checkoutUrl: errand.paymentCheckoutUrl,
      referenceNumber: errand.paymentReferenceNumber || `ERRANDITO-${errandId}`,
      alreadyCreated: true,
    };
  }

  const amountInCentavos = Number(errand.amount || 12000);

  if (!Number.isFinite(amountInCentavos) || amountInCentavos <= 0) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Invalid errand amount."
    );
  }

  // Convert centavos to standard currency units (e.g. 12000 -> 120.00)
  const amount = Number((amountInCentavos / 100).toFixed(2));
  const currency = (errand.currency || "PHP").toString().toUpperCase();
  const referenceNumber = `ERRANDITO-${errandId}`;

  const payload = {
    amount,
    currency,
    reference_number: referenceNumber,
    email: errand.requesterEmail || "test@example.com",
    name: errand.requesterName || "Errandito Customer",
    purpose: errand.serviceType || errand.title || "Errandito Service",
    redirect_url: "https://example.com/payment-success",
    allow_repeated_payments: false,
    send_email: false,
    send_sms: false,
    metadata: {
      errandId,
      requesterId: errand.requesterId || "",
      runnerId: errand.runnerId || "",
    },
  };

  console.log("HitPay payload", {
    ...payload,
    email: "[redacted]",
  });

  let response;

  try {
    response = await axios.post(
      `${apiUrl}/v1/payment-requests`,
      payload,
      {
        headers: {
          "X-BUSINESS-API-KEY": key,
          "Content-Type": "application/json",
          Accept: "application/json",
        },
        timeout: 15000,
      }
    );

    console.log("HitPay response", response.data);
  } catch (error) {
    console.error("HitPay create payment failed:", {
      status: error.response && error.response.status,
      data: error.response && error.response.data,
      message: error.message,
      apiUrl,
      payload: {
        ...payload,
        email: "[redacted]",
      },
    });

    throw new functions.https.HttpsError(
      "aborted",
      publicHitPayError(error)
    );
  }

  const payment = response.data || {};
  const normalized = normalizePaymentResponse(payment);

  if (!normalized.checkoutUrl) {
    console.error("Unexpected HitPay response. No checkout URL:", payment);

    throw new functions.https.HttpsError(
      "aborted",
      "HitPay did not return a checkout URL. Check Firebase Functions logs."
    );
  }

  await errandRef.update({
    paymentMethod: "hitpay",
    paymentStatus: "pending",
    paymentProvider: "hitpay",
    paymentRequestId: normalized.paymentRequestId,
    paymentCheckoutUrl: normalized.checkoutUrl,
    paymentReferenceNumber: referenceNumber,
    paymentUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
    status: "pending_payment",
    visibleToRunners: false,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return {
    paymentRequestId: normalized.paymentRequestId,
    checkoutUrl: normalized.checkoutUrl,
    referenceNumber,
  };
});

exports.checkHitPayPaymentStatus = functions.https.onCall(async (data, context) => {
  console.log("checkHitPayPaymentStatus called", {
    uid: context.auth ? context.auth.uid : null,
    data,
    apiUrl: hitpayApiUrl(),
  });

  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "You must be logged in."
    );
  }

  const errandId = data && data.errandId;

  if (!errandId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing errandId."
    );
  }

  const { key, apiUrl } = validateHitPayConfig();

  const errandRef = db.collection("errands").doc(errandId);
  const errandSnap = await errandRef.get();

  if (!errandSnap.exists) {
    throw new functions.https.HttpsError("not-found", "Errand not found.");
  }

  const errand = errandSnap.data() || {};

  if (
    errand.requesterId !== context.auth.uid &&
    errand.runnerId !== context.auth.uid
  ) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You are not part of this errand."
    );
  }

  const paymentRequestId = errand.paymentRequestId;

  if (!paymentRequestId) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "No HitPay payment request found. Tap Pay Online with HitPay first."
    );
  }

  let response;

  try {
    response = await axios.get(
      `${apiUrl}/v1/payment-requests/${paymentRequestId}`,
      {
        headers: {
          "X-BUSINESS-API-KEY": key,
          Accept: "application/json",
        },
        timeout: 15000,
      }
    );

    console.log("HitPay check response", response.data);
  } catch (error) {
    console.error("HitPay check payment failed:", {
      status: error.response && error.response.status,
      data: error.response && error.response.data,
      message: error.message,
      apiUrl,
      paymentRequestId,
    });

    throw new functions.https.HttpsError(
      "aborted",
      publicHitPayError(error)
    );
  }

  const payment = response.data || {};
  const normalized = normalizePaymentResponse(payment);
  const status = normalized.rawStatus.toString().toLowerCase();

  console.log("Normalized HitPay status", {
    paymentRequestId,
    status,
  });

  if (status === "completed" || status === "succeeded" || status === "paid") {
    await errandRef.update({
      paymentStatus: "paid",
      paymentCollected: true,
      paidAt: admin.firestore.FieldValue.serverTimestamp(),
      paymentUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
      status: "accepted",
      visibleToRunners: false,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      paymentStatus: "paid",
      rawStatus: status,
    };
  }

  if (
    status === "failed" ||
    status === "cancelled" ||
    status === "canceled" ||
    status === "expired"
  ) {
    await errandRef.update({
      paymentStatus: "failed",
      paymentUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      paymentStatus: "failed",
      rawStatus: status,
    };
  }

  return {
    paymentStatus: "pending",
    rawStatus: status || "pending",
  };
});