import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pockit/presentation/constant/utils.dart';
import 'package:pockit/presentation/screens/login.dart';
import 'package:pockit/utils/shared_prefs.dart';
import 'package:flutter/material.dart';


class AuthService {
  static const String baseUrl = 'https://83mbl26v-7777.asse.devtunnels.ms/api/v1';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(
      String fullname, String gender, String email, String password, String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullname': fullname,
        'gender': gender,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await SharedPrefs.saveUser(userData);
  }

  static Future<void> logout(BuildContext context) async {
    await SharedPrefs.clearUser();
    Utils.pushReplacementWithFade(context, LoginScreen());
  }
}
