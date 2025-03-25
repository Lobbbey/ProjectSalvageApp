import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  final String loginUrl = 'http://salvagefinancial.xyz/api/login';
  final String signUpUrl = 'http://salvagefinancial.xyz/api/SignUp';

  Future<void> login(String email, String password) async {
    try{
      final response = await http.post(
        Uri.parse(loginUrl),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        if(responseData['success']){
          _isLoggedIn = true;
          notifyListeners();
        } else{
          throw Exception('Invalid Login');
        }
      } else{
        throw Exception('Failed to Login');
      }
    } catch(e) {
      throw Exception('Error: $e');
    }
  }

  // Method to sign up using API
  Future<void> signUp(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(signUpUrl),
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successful sign-up
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          _isLoggedIn = true;
          notifyListeners();
        } else {
          throw Exception('Sign-up failed');
        }
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners(); 
  }
}

