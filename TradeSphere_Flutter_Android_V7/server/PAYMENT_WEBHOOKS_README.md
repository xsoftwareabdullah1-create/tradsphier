
# TradeSphere V5 — verified payment webhooks

This version adds a provider-neutral payment-intent layer with:

- `PENDING` payment intents for deposits and withdrawals
- HMAC-SHA256 webhook signature verification
- unique webhook event IDs (replay/idempotency protection)
- unique payment intent IDs and idempotency keys
- ledger changes only after a verified `SUCCEEDED` webhook
- failed/cancelled provider states
- automatic portfolio + ledger + audit updates
- server-side amount/user binding (webhook payload cannot change the amount)

## Endpoints

Authenticated:
- `POST /api/v1/payments/intents`
  - body: `{ "type": "DEPOSIT", "amount": 5000, "currency": "INR" }`
  - or `type: "WITHDRAWAL"`
- `GET /api/v1/payments/intents/:id`

Webhook:
- `POST /api/v1/payments/webhooks/demo`

The demo webhook expects:
- `x-tradesphere-event-id`
- `x-tradesphere-signature: sha256=<hex hmac>`
- JSON body containing:
  `{ "type":"payment.updated", "data":{"payment_id":"demo_...", "status":"SUCCEEDED"} }`

## Critical production rule

Do NOT treat the demo webhook as a real payment provider.

For a real provider (Razorpay/Stripe/PayU/Cashfree/etc.), create a dedicated adapter that implements that provider's official signature verification and event schema. Verify the raw request body before JSON parsing, use the provider's webhook secret/signing secret, and credit the ledger only from trusted server-side webhook events.

For withdrawals, do not debit/credit based on a client "success" screen. Create a pending withdrawal, have the provider/bank process it, then finalize only after the provider's verified success/failure callback. Add KYC/AML, limits, reconciliation, dispute handling, and a double-entry accounting design before production.

MongoDB transactions require a replica set or a managed MongoDB deployment that supports transactions.
