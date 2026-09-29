# TradeSphere V3 backend

This version adds a real HTTP API boundary with MongoDB persistence and JWT authentication.

## Run

1. Install Node.js and MongoDB.
2. Copy `.env.example` to `.env` and set a strong `JWT_SECRET`.
3. `npm install`
4. `npm start`

The Android emulator uses `http://10.0.2.2:5000/api/v1` by default. For a physical Android phone, build with your computer's LAN API address, for example:

`flutter run --dart-define=API_BASE_URL=http://192.168.1.10:5000/api/v1`

## API

POST `/api/v1/auth/signup`
POST `/api/v1/auth/login`
GET `/api/v1/orders` (Bearer token)
POST `/api/v1/orders` (Bearer token)
POST `/api/v1/orders/:id/cancel` (Bearer token)
GET `/health`

## Security boundary

The Flutter app is not trusted. The server validates authentication, order fields, and the demo BTC balance limit. For real trading, replace the demo ledger check with an authoritative broker/exchange ledger and add risk, KYC/AML, idempotency, rate limiting, audit logs, monitoring, secrets management, and compliance controls.
