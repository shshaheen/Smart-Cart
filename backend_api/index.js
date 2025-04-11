// Import the express module
const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const cors = require('cors');
const bannerRouter = require('./routes/banner');
const categoryRouter = require('./routes/category');
const SubCategoryRouter = require('./routes/sub_category');
const productRouter = require('./routes/product');
const productReviewRouter = require('./routes/product_review');
const vendorRouter = require('./routes/vendor');
// Defined the port number the server should listen on
const PORT = process.env.PORT || 3000;
require('dotenv').config();

// Create an instance of an express application because it give us the starting point
const app = express();

const allowedOrigins = [
    'http://localhost:3000',
    'https://e4a7-2401-4900-675a-dcfd-9455-9417-1bd8-dcf0.ngrok-free.app' // replace this with your current ngrok URL
  ];
  
  app.use(cors({
    origin: function (origin, callback) {
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(new Error('Not allowed by CORS'));
      }
    }
  }));

// This middleware function is executed for every request that comes into our server
app.use(express.json());
app.use(authRouter);   
app.use(bannerRouter); 
app.use(categoryRouter);
app.use(SubCategoryRouter);
app.use(productRouter);
app.use(productReviewRouter);
app.use(vendorRouter);
// app.use(cors()); //enable CORS for all routes and origin(domain),

DB = process.env.MONGO_URI;

mongoose.connect(DB).then(
    ()=>console.log("Connected to MongoDB..!")).
    catch(error => console.error("MongoDB connection error: " + error));


//Start the server and listen on specified port
app.listen(PORT, "0.0.0.0",function(){
    console.log(`Server is running on port http://localhost:${PORT}`);
});