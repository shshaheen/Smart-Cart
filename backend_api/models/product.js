const mongoose = require('mongoose');
const Category = require('./category');

const productSchema = mongoose.Schema({
    productName:{
        type: String,
        required: true,
        trim: true
    },
    productPrice:{
        type: Number,
        required: true,
    },
    quantity:{
        type: Number,
        required: true,
    },
    description:{
        type: String,
        required: true,
    },
    category:{
        type: String,
        required: true
    },
    subCategory:{
        type: String,
        required: true,
    },
    image:[
        {
            type: String,
            required: true  
        },
    ],
    popular: {
        type: Boolean,
        default: false
    },
    recommend:{
        type: Boolean,
        default: false
    }

});

const Product = mongoose.model('Product',productSchema);

module.exports = Product;