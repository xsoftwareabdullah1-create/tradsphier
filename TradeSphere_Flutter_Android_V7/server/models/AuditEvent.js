const mongoose = require('mongoose');
const AuditEventSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  action: { type: String, required: true },
  resourceType: String,
  resourceId: String,
  ip: String,
  userAgent: String,
  metadata: { type: mongoose.Schema.Types.Mixed, default: {} }
}, { timestamps: true });
module.exports = mongoose.model('AuditEvent', AuditEventSchema);
