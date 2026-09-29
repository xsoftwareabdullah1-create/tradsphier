
const crypto = require("crypto");
const mongoose = require("mongoose");
const PaymentIntent = require("../models/PaymentIntent");
const WebhookEvent = require("../models/WebhookEvent");
const { getOrCreatePortfolio, deposit, withdraw } = require("./ledgerService");

function makeIdempotencyKey() {
  return crypto.randomBytes(24).toString("hex");
}

async function createPaymentIntent({ userId, type, amount, currency = "INR", provider = "DEMO", metadata = {} }) {
  if (!["DEPOSIT", "WITHDRAWAL"].includes(type)) throw new Error("Invalid payment type");
  const value = Number(amount);
  if (!Number.isFinite(value) || value <= 0) throw new Error("Amount must be positive");

  const idempotencyKey = makeIdempotencyKey();
  const providerPaymentId = `${provider.toLowerCase()}_${crypto.randomUUID()}`;

  if (type === "WITHDRAWAL") {
    // Reserve the requested cash by moving it out of available balance only
    // after a provider accepts the withdrawal request in production.
    // For this demo, the intent stays PENDING and ledger movement happens only
    // after the verified provider webhook.
    const portfolio = await getOrCreatePortfolio(userId);
    if (portfolio.cashAvailable < value) {
      const err = new Error("Insufficient available cash");
      err.statusCode = 422;
      throw err;
    }
  }

  const intent = await PaymentIntent.create({
    userId, provider, providerPaymentId, type,
    status: "PENDING", amount: value, currency,
    idempotencyKey, metadata
  });

  return intent;
}

function verifyHmac(rawBody, signature, secret) {
  if (!signature || !secret) return false;
  const expected = crypto.createHmac("sha256", secret).update(rawBody).digest("hex");
  const supplied = String(signature).replace(/^sha256=/i, "").trim();
  try {
    return crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(supplied));
  } catch {
    return false;
  }
}

async function processVerifiedWebhook({ provider, eventId, eventType, rawBody, signature, secret, payload }) {
  if (!verifyHmac(rawBody, signature, secret)) {
    const err = new Error("Invalid webhook signature");
    err.statusCode = 401;
    throw err;
  }

  const payloadHash = crypto.createHash("sha256").update(rawBody).digest("hex");
  const session = await mongoose.startSession();

  try {
    let result;
    await session.withTransaction(async () => {
      const existing = await WebhookEvent.findOne({ provider, eventId }).session(session);
      if (existing) {
        result = { duplicate: true, status: existing.status };
        return;
      }

      await WebhookEvent.create([{
        provider, eventId, eventType, signatureValid: true,
        status: "RECEIVED", payloadHash, payload
      }], { session });

      const providerPaymentId = payload?.data?.payment_id || payload?.payment_id;
      const intent = providerPaymentId
        ? await PaymentIntent.findOne({ providerPaymentId }).session(session)
        : null;

      if (!intent) {
        await WebhookEvent.updateOne(
          { provider, eventId },
          { $set: { status: "IGNORED", processedAt: new Date(), error: "Unknown payment intent" } },
          { session }
        );
        result = { duplicate: false, status: "IGNORED" };
        return;
      }

      if (intent.providerEventIds.includes(eventId)) {
        result = { duplicate: true, status: intent.status };
        return;
      }

      const providerStatus = String(payload?.data?.status || payload?.status || "").toUpperCase();
      intent.providerEventIds.push(eventId);

      if (providerStatus === "SUCCEEDED" && intent.status === "PENDING") {
        // Use the server-side stored amount/user, not client-provided webhook values.
        if (intent.type === "DEPOSIT") {
          await deposit(intent.userId, intent.amount, intent.currency, {
            referenceId: intent.providerPaymentId,
            idempotencyKey: `payment:${intent._id}:deposit`,
            metadata: { provider, eventId }
          }, session);
        } else {
          await withdraw(intent.userId, intent.amount, intent.currency, {
            referenceId: intent.providerPaymentId,
            idempotencyKey: `payment:${intent._id}:withdrawal`,
            metadata: { provider, eventId }
          }, session);
        }

        intent.status = "SUCCEEDED";
        intent.completedAt = new Date();
      } else if (["FAILED", "CANCELLED"].includes(providerStatus) && intent.status === "PENDING") {
        intent.status = providerStatus;
        intent.failureReason = payload?.data?.failure_reason || payload?.failure_reason || null;
        intent.completedAt = new Date();
      }

      await intent.save({ session });
      await WebhookEvent.updateOne(
        { provider, eventId },
        { $set: { status: "PROCESSED", processedAt: new Date() } },
        { session }
      );

      result = { duplicate: false, status: intent.status, paymentIntentId: intent._id.toString() };
    });

    return result;
  } finally {
    await session.endSession();
  }
}

module.exports = {
  createPaymentIntent,
  processVerifiedWebhook,
  verifyHmac
};
