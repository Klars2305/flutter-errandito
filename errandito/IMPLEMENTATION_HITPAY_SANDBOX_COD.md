# HitPay Sandbox + COD implementation

This project was patched to support:

- Cash on Delivery (COD)
- HitPay Sandbox online payment
- Manual "Check Payment Status" button, so webhook is not required yet
- Runner can start only after online payment is paid, or COD is selected

## Important security note

Do not put your HitPay API key or salt in Flutter. The key you pasted in chat should be treated as exposed. Regenerate it in HitPay before using it.

## Firebase Functions setup

From the project root:

```bash
cd functions
npm install
cd ..
firebase functions:config:set hitpay.api_key="YOUR_HITPAY_SANDBOX_API_KEY"
firebase functions:config:set hitpay.api_url="https://api.sandbox.hit-pay.com"
firebase deploy --only functions
```

For production later:

```bash
firebase functions:config:set hitpay.api_url="https://api.hit-pay.com"
firebase deploy --only functions
```

## Flutter setup

```bash
flutter pub get
```

## User flow

1. Requester posts errand.
2. Requester selects runner.
3. Requester opens the payment page.
4. Requester chooses:
   - Cash on Delivery, or
   - Pay Online with HitPay Sandbox.
5. If HitPay:
   - app calls `createHitPayPayment`
   - app opens HitPay checkout
   - user completes sandbox payment
   - user returns and taps `Check Payment Status`
   - app calls `checkHitPayPaymentStatus`
   - Firestore updates `paymentStatus = paid`
6. Runner accepts the task from the runner side.
7. Runner can start when:
   - `paymentStatus == paid`, or
   - `paymentMethod == cod && paymentStatus == cod_pending`.

## Files changed

- `pubspec.yaml`
- `firebase.json`
- `functions/index.js`
- `functions/package.json`
- `lib/services/payment_service.dart`
- `lib/services/errand_service.dart`
- `lib/review_pay_page.dart`
- `lib/gig_finder_page.dart`
- `lib/execution_status_page.dart`
- `lib/live_tracking_page.dart`
- `lib/select_helper_page.dart`
- `lib/booking_details.dart`
- `FIREBASE_RULES_FOR_FUNCTIONAL_FLOW.txt`

## HitPay Sandbox test cards

Use HitPay sandbox dashboard / checkout test cards:

- Successful Visa: `4242 4242 4242 4242`
- Declined Visa: `4000 0000 0000 0002`
- Successful Mastercard: `5555 5555 5555 4444`

Use any future expiry date and any valid CVC.
