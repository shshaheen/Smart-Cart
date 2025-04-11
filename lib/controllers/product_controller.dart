import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_cart/global_variables.dart';
import 'package:smart_cart/models/product.dart';

class ProductController {
  //Define a function that returns a future containing list of the product model objects
  Future<List<Product>> loadPopularProducts() async {
    // use  a try block to handle any exceptions that might occur in the http request proccss
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/popular-products"),
        // set the http headers for the request , specifying that the content type is json with the UTF-8 encoding
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      // print(response.body);
      //check if the HTTP response status code is 200, whihc means  the request was successfull

      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Error loading product : $e');
    }
  }

//load product by category function
  Future<List<Product>> loadProductByCategory(String category) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products-by-category/$category'),
        headers: <String, String>{
          'Content-Type': 'application/json; chartset=UTF-8 ',
        },
      );
      if (response.statusCode == 200) {
        //Decode the json response body into a list  of dynamic object
        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        //map each items in the list to product model object which we can use

        List<Product> products = data
            .map((product) => Product.fromMap(product as Map<String, dynamic>))
            .toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //if status code is not 200 , throw an execption   indicating failure to load the popular products
        throw Exception('Failed to load popular products');
      }
    } catch (e) {
      throw Exception('Error loading product : $e');
    }
  }

  
}
