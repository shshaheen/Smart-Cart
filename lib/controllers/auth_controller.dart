import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_cart/providers/delivered_order_count_provider.dart';
import 'package:smart_cart/providers/user_provider.dart';
import 'package:smart_cart/services/manage_http_response.dart';
import 'package:smart_cart/views/screens/authentication_screens/login_screen.dart';
import 'package:smart_cart/views/screens/main_screen.dart';
import 'dart:convert';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import '../global_variables.dart';

// final providerContainer = ProviderContainer();

class AuthController {
  Future<void> signUpUsers(
      {required BuildContext context,
      required String username,
      required String email,
      required String password,
      required WidgetRef ref
      }) async {
    try {
      User user = User(
          id: '',
          username: username,
          email: email,
          state: '',
          city: '',
          locality: '',
          password: password,
          token: '');
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user
            .toJson(), //Convert the user object to json for the request body
        headers: <String, String>{
          "Content-Type":
              "application/json; charset=UTF-8", // specify the content type as Json
        }, // Set the Headers for the request body
      );
      if (!context.mounted) return;
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            showSnackBar(context, 'Account has been created for you.');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signInUsers(
      {required BuildContext context,
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
      if (!context.mounted) return;
      // Handle the response using the manage_http_response
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            // Access sharedPreferences for token and user data storage
            SharedPreferences preferences =
                await SharedPreferences.getInstance();

            //Extract the authentication token from the response body
            String token = jsonDecode(response.body)['token'];

            // Store the authentication token securely in sharedPreferences

            await preferences.setString('auth_token', token);

            // Encode the user data received from the backend as JSON
            final userJson = jsonEncode(jsonDecode(response.body)['user']);

            //Update the application state with the user data using Riverpod
            // Encode the user data received from the backened as json using Riverpod

            // .read(userProvider.notifier).setUser(userJson);
            //store the data in sharedPrefernce for future use
            await preferences.setString('user', userJson);
            if (!context.mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainScreen()),
                (route) => false);
            showSnackBar(context, 'Logged In');
          });
    } catch (e) {
      // print("Error:  $e");
      showSnackBar(context, e.toString());
    }
  }

  //SignOut
  Future<void> signOutUser({required BuildContext context,required WidgetRef ref}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      // Clear the stored token and user from SharedPreference
      await preferences.remove('auth_token');
      await preferences.remove('user');
      // Clear the user state
      ref.read(userProvider.notifier).signOut();
      ref.read(deliveredOrderCountProvider.notifier).resetCount();
      //Navigate the user back to the login screen
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
      showSnackBar(context, 'Signout successfully');
    } catch (e) {
      showSnackBar(context, 'Error Signing out');
    }
  }

  // Update user's state, city and locality
  Future<void> updateUserLocation(
      {required BuildContext context,
      required String id,
      required String state,
      required String city,
      required String locality,
      required WidgetRef ref
      }) async {
    try {
      //Make an HTTP PUT request to update user's state, city and locality
      http.Response response = await http.put(
        Uri.parse('$uri/api/users/$id'),
        // set the headers for the request to specify that the content is Json
        headers: <String, String>{
          "content-Type": "application/json; charset=UTF-8"
        },
        //Encode the updated data(State, City and Locality) as Json Object
        body: jsonEncode({'state': state, 'city': city, 'locality': locality}),
      );
      if (!context.mounted) return;
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            // Decode the updated user data from the response body
            //this converts the json String response into Dart Map
            final updatedUser = jsonDecode(response.body);
            //Access Shared preference for local data storage
            //Shared Preferences allow us to store data persistently on the device
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            // Encode the updated user data as json string
            //this prepared the data for storage in shared preferences
            final userJson = jsonEncode(updatedUser);

            //update the application state with updated user data using Riverpod
            // this ensures the app reflects the most recent user data
            ref.read(userProvider.notifier).setUser(userJson);

            //store the updated user data in shared preferences for future use
            //this allows the app to retrive the user data even after the app restarts
            await preferences.setString('user', userJson);
          });
    } catch (e) {
      // catch any error that occure during the process
      // show an error message to the user if the update fails
      showSnackBar(context, "Error Updating Location");
    }
  }
}
