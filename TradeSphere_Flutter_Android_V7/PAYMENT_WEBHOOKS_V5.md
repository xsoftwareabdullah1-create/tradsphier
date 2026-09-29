
# TradeSphere V5

Added verified payment-provider webhook architecture:

1. Create a server-side payment intent.
2. Intent starts `PENDING`.
3. Client never directly credits the portfolio.
4. Provider webhook is verified with its signing secret.
5. Event ID is unique, so retries/replays are idempotent.
6. The stored intent amount/user are authoritative.
7. Only a verified `SUCCEEDED` event applies the ledger transaction.
8. Portfolio, ledger entry, and audit event are updated atomically.
9. `FAILED`/`CANCELLED` leaves funds uncredited.
10. Flutter shows a pending status and polls the server.

This repository uses a DEMO HMAC provider adapter for local testing. It is not a live payment integration.

To connect a real provider, implement its official webhook signature verification and event mapping. Do not put payment secrets in Flutter. Use HTTPS in production and keep webhook endpoints server-only.
