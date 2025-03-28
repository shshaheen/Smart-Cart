import 'package:smart_cart/services/manage_http_response.dart';
import 'dart:convert';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import '../global_variables.dart';

class AuthController {
  Future<void> signUpUsers(
      {required context,
      required String username,
      required String email,
      required String password}) async {
    try {
      User user = User(
          id: '',
          username: username,
          email: email,
          state: '',
          city: '',
          locality: '',
          password: password,
          token: ''
          );
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user
            .toJson(), //Convert the user object to json for the request body
        headers: <String, String>{
          "Content-Type":
              "application/json; charset=UTF-8", // specify the content type as Json
        }, // Set the Headers for the request body
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Account has been created for you.');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInUsers(
      {required context,
      required String email,
      required String password}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode(
          {
            'email': email, // include the email in the request body,
            'password': password, // include the password in the request body
          },
        ), //Convert the user object to json for the request body
        headers: <String, String>{
          // this will set the header
          "Content-Type":
              "application/json; charset=UTF-8", // specify the content type as Json
        }, // Set the Headers for the request body
      );
      // Handle the response using the manage_http_response
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Logged In');
          });
    } catch (e) {
      // print("Error:  $e");
      showSnackBar(context, e.toString());
    }
  }
}
