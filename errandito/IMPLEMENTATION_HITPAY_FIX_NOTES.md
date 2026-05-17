# HitPay / COD Fix Notes

Fixed in this project:

1. `functions/index.js` now validates sandbox/live key mismatch and returns clearer Firebase Function errors.
2. HitPay payment request now includes `payment_methods: ["card"]`, uses numeric amount, and logs HitPay API errors clearly.
3. `payment_service.dart` now surfaces Firebase Function error messages instead of only showing `[firebase_functions/internal] internal`.
4. COD and successful HitPay payments now set assigned tasks to `status: accepted` and `visibleToRunners: false` so the task does not appear to other runners.
5. Runner can start when `paymentStatus == paid` or when `paymentMethod == cod && paymentStatus == cod_pending`.

After extracting, run:

```bash
flutter pub get
cd functions
npm install
cd ..
firebase functions:config:set hitpay.api_key="YOUR_SANDBOX_KEY"
firebase functions:config:set hitpay.api_url="https://api.sandbox.hit-pay.com"
firebase deploy --only functions
```

Then test with a new errand.
