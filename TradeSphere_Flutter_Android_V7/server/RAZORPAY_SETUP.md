# TradeSphere V6 — Razorpay

Deposits use Razorpay Orders + Checkout. The server creates the order and the Flutter app receives only the public Key ID. The server verifies the checkout signature, but the ledger is credited only after a verified Razorpay webhook.

Webhook:
`POST https://YOUR_DOMAIN/api/v1/payments/webhooks/razorpay`

Set the webhook secret in `RAZORPAY_WEBHOOK_SECRET`.

Withdrawals use RazorpayX Payouts and remain `PENDING` until a verified payout webhook confirms success.

Never put `RAZORPAY_KEY_SECRET`, `RAZORPAY_WEBHOOK_SECRET`, or RazorpayX secrets in Flutter/GitHub. Use environment variables or a secret manager.

You must have an activated merchant/RazorpayX account and the relevant products enabled before live transactions can occur.
