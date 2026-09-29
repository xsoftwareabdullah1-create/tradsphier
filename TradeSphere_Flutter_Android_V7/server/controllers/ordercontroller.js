const Order=require('../models/Order');
exports.list=async(req,res)=>{const orders=await Order.find({userId:req.userId}).sort({createdAt:-1}).lean();res.json({orders});};
exports.create=async(req,res)=>{try{const {symbol,side,quantity,price,orderType}=req.body;if(!symbol||!['BUY','SELL'].includes(side)||!Number.isFinite(quantity)||quantity<=0||!Number.isFinite(price)||price<=0)return res.status(400).json({message:'Invalid order'});
// Demo ledger: BTC balance is 4. Production must use the authoritative broker/exchange ledger.
if(side==='SELL'&&symbol.toUpperCase()==='BTC'&&quantity>4)return res.status(422).json({message:'Order rejected: insufficient BTC balance (available: 4)'});
const order=await Order.create({userId:req.userId,symbol,side,quantity,price,orderType,status:'open'});res.status(201).json({order});}catch(e){res.status(500).json({message:'Order creation failed'});}};
exports.cancel=async(req,res)=>{const order=await Order.findOne({_id:req.params.id,userId:req.userId});if(!order)return res.status(404).json({message:'Order not found'});if(order.status!=='open')return res.status(409).json({message:'Only open orders can be cancelled'});order.status='cancelled';await order.save();res.json({order});};
