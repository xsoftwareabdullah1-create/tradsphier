const mongoose = require('mongoose');
const Portfolio = require('../models/Portfolio');
const LedgerEntry = require('../models/LedgerEntry');
const AuditEvent = require('../models/AuditEvent');

async function getOrCreatePortfolio(userId, session) {
  let p = await Portfolio.findOne({ userId }).session(session || null);
  if (!p) {
    const docs = await Portfolio.create([{ userId, currency: 'INR', cashAvailable: 0, cashReserved: 0, holdings: [] }], session ? { session } : {});
    p = docs[0];
  }
  return p;
}
async function audit(userId, action, resourceType, resourceId, metadata, session) {
  await AuditEvent.create([{ userId, action, resourceType, resourceId: String(resourceId || ''), metadata: metadata || {} }], session ? { session } : {});
}
async function runAtomic(externalSession, fn) {
  if (externalSession) return fn(externalSession);
  const session = await mongoose.startSession();
  try { let result; await session.withTransaction(async () => { result = await fn(session); }); return result; }
  finally { await session.endSession(); }
}
async function deposit(userId, amount, currency='INR', opts={}, externalSession=null) {
  return runAtomic(externalSession, async (session) => {
    const existing = opts.idempotencyKey ? await LedgerEntry.findOne({ idempotencyKey: opts.idempotencyKey }).session(session) : null;
    if (existing) return existing;
    const p = await getOrCreatePortfolio(userId, session);
    p.cashAvailable += Number(amount);
    await p.save({ session });
    const [entry] = await LedgerEntry.create([{ userId, type:'DEPOSIT', amount:Number(amount), currency, balanceAfter:p.cashAvailable, referenceId:opts.referenceId, idempotencyKey:opts.idempotencyKey, metadata:opts.metadata||{} }], { session });
    await audit(userId, 'DEPOSIT_CONFIRMED', 'PORTFOLIO', p._id, opts.metadata, session);
    return entry;
  });
}
async function withdraw(userId, amount, currency='INR', opts={}, externalSession=null) {
  return runAtomic(externalSession, async (session) => {
    const existing = opts.idempotencyKey ? await LedgerEntry.findOne({ idempotencyKey: opts.idempotencyKey }).session(session) : null;
    if (existing) return existing;
    const p = await getOrCreatePortfolio(userId, session);
    if (p.cashAvailable < Number(amount)) throw new Error('Insufficient available cash');
    p.cashAvailable -= Number(amount);
    await p.save({ session });
    const [entry] = await LedgerEntry.create([{ userId, type:'WITHDRAWAL', amount:-Number(amount), currency, balanceAfter:p.cashAvailable, referenceId:opts.referenceId, idempotencyKey:opts.idempotencyKey, metadata:opts.metadata||{} }], { session });
    await audit(userId, 'WITHDRAWAL_CONFIRMED', 'PORTFOLIO', p._id, opts.metadata, session);
    return entry;
  });
}
module.exports = { getOrCreatePortfolio, audit, deposit, withdraw };
