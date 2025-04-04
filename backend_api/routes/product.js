const express = require('express');
const Product = require('../models/product');

const productRouter = express.Router();

productRouter.post('/api/add-product', async (req, res) => {
    try {
        const {productName, productPrice,quantity,description, category, subCategory,images} = req.body;
        const product = new Product({productName, productPrice,quantity,description, category, subCategory,images});
        await product.save();
        return res.status(201).send(product);
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});


productRouter.get('/api/popular-products', async (req, res) => {
    try {
        const popularProducts = await Product.find({popular: true});
        if(!popularProducts || popularProducts.length ==0){
            return res.status(400).json({message: 'No products found'});
        }
        return res.status(200).json({popularProducts: popularProducts});
    } catch (e) {
        return res.status(500).json({error: e.message});
    }
});

productRouter.get('/api/recommended-products', async (req, res) => {
    try {
        const recommendedProducts = await Product.find({recommend: true});
        if(!recommendedProducts || recommendedProducts.length ==0){
            return res.status(400).json({message: 'No products found'});
        }
        return res.status(200).json({recommendedProducts: recommendedProducts});
    } catch (e) {
        return res.status(500).json({error: e.message});
    }
});
module.exports = productRouter;