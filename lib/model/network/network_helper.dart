import 'dart:convert';

import 'package:authentikate/model/login/login_response.dart';
import 'package:authentikate/model/registration/registration_response.dart';
import 'package:authentikate/utils/urls.dart';
import 'package:http/http.dart' as http;

class ApiCall {
  /// ====================== Registration ========================
  Future<RegistrationResponse> createUser(
      String name, String email, String phone, String password) async {
    try {
      final body = {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
      };

      final response = await http.post(
        Uri.parse("${Url.baseUrl}${Url.signup}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final registrationResponse = jsonDecode(response.body);
      RegistrationResponse regResponse =
      RegistrationResponse(message: registrationResponse);

      return regResponse;
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  /// =============== Login ===============
  Future<LoginResponse> signInUser(String email, String password) async {
    try {
      final body = jsonEncode({"email": email, "password": password});
      final response = await http.post(
        Uri.parse("${Url.baseUrl}${Url.login}"),
        body: body,
      );
      final signInResponse = jsonDecode(response.body);
      LoginResponse loginResponse = LoginResponse(success: signInResponse);
      return loginResponse;
    } catch (e) {
      throw ("exception: ${e.toString()}");
    }
  }
}
