# TradeSphere V7 — Razorpay + UPI/Google Pay + Ledger

## What is included
- Server-side MongoDB portfolio and immutable-style transaction ledger records.
- Razorpay order creation for INR deposits.
- Flutter Razorpay Checkout with UPI enabled; Google Pay can appear as an installed UPI app.
- Checkout signature verification on the server.
- Razorpay webhook signature verification and duplicate-event protection.
- Wallet balance is credited only after a verified provider event, not merely after the client says payment succeeded.
- Payment-status polling screen.
- Optional RazorpayX withdrawal endpoint.

## Important
This is a real payment integration, but it is **not automatically live**. You must configure your own Razorpay account credentials. `rzp_test_...` keys use Razorpay test mode. Live keys plus an approved/activated Razorpay account are required for real INR payments.

Do not put `RAZORPAY_KEY_SECRET` or webhook secrets in the Flutter app. Keep them on the Node.js server / deployment secrets.

## Server
1. Copy `.env.example` to `.env` and fill the values.
2. Install dependencies with `npm install` inside `server`.
3. Start MongoDB (a MongoDB deployment supporting transactions is recommended for production).
4. Run `npm start`.
5. Configure the Razorpay webhook URL to:
   `https://YOUR_API_HOST/api/v1/payments/webhooks/razorpay`
6. Use the same webhook secret in Razorpay and `RAZORPAY_WEBHOOK_SECRET`.

## Flutter
The app uses `API_BASE_URL` at build time. For a physical phone, point it at an HTTPS API host or your reachable LAN server, for example:
`flutter run --dart-define=API_BASE_URL=https://api.example.com/api/v1`

The Android app must have internet permission. A production build should use HTTPS.

## Google Pay / UPI
The app does not fake a Google Pay success screen. It opens Razorpay Checkout with UPI enabled. If Google Pay is installed and eligible, Razorpay may offer it as a UPI app. Availability is controlled by the device, UPI app, Razorpay Checkout, bank and account configuration.

## Production financial controls
Before taking real customer money, add KYC/AML, reconciliation, withdrawal authorization, fraud/risk controls, broker/exchange execution, dispute handling, rate limits, monitoring, and applicable Indian regulatory/financial compliance.
