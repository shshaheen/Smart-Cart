// Import the express module
const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const cors = require('cors');
const bannerRouter = require('./routes/banner');
const categoryRouter = require('./routes/category');
const SubCategoryRouter = require('./routes/sub_category');
// Defined the port number the server should listen on
const PORT = process.env.PORT || 3000;
require('dotenv').config();

// Create an instance of an express application because it give us the starting point
const app = express();
app.use(cors());


// This middleware function is executed for every request that comes into our server
app.use(express.json());
app.use(authRouter);   
app.use(bannerRouter); 
app.use(categoryRouter);
app.use(SubCategoryRouter);


DB = process.env.MONGO_URI;

mongoose.connect(DB).then(
    ()=>console.log("Connected to MongoDB..!")).
    catch(error => console.error("MongoDB connection error: " + error));


//Start the server and listen on specified port
app.listen(PORT, "0.0.0.0",function(){
    console.log(`Server is running on port http://localhost:${PORT}`);
});