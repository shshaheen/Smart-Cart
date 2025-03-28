import 'package:smart_cart/services/manage_http_response.dart';

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
          password: password);
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user
            .toJson(), //Convert the user object to json for the request body
        headers: <String, String>{
          "content-Type":
              "application/json; charset=UTF-8", // specify the content type as Json
        }, // Set the Headers for the request body
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Account has been created for you.');
          });
    } catch (e) {}
  }
}
