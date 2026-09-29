require('dotenv').config();const express=require('express');const cors=require('cors');const mongoose=require('mongoose');
const app=express();app.use(cors());app.use(express.json({limit:'256kb',verify:(req,res,buf)=>{if(req.originalUrl.includes('/payments/webhooks/razorpay'))req.rawBody=Buffer.from(buf);}}));
app.get('/health',(_,res)=>res.json({ok:true,service:'TradeSphere API'}));
app.use('/api/v1/auth',require('./routes/auth'));app.use('/api/v1/orders',require('./routes/orders'));app.use('/api/v1/portfolio',require('./routes/portfolio'));app.use('/api/v1/payments',require('./routes/payments'));
const port=process.env.PORT||5000;(async()=>{try{await mongoose.connect(process.env.MONGO_URI);app.listen(port,()=>console.log(`TradeSphere API listening on ${port}`));}catch(e){console.error(e);process.exit(1);}})();
