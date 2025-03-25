import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _errorMessage = '';

  bool get isLoggedIn => _isLoggedIn;
  String get errorMessage => _errorMessage;

  final String loginUrl = 'http://salvagefinancial.xyz:5000/api/Login';
  final String signUpUrl = 'http://salvagefinancial.xyz/api/SignUp';

  Future<void> login(String email, String password) async {
    try {
      _errorMessage = '';
      notifyListeners();

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode({'Email': email.trim(), 'Password': password.trim()}),
      );

      final responseData = json.decode(response.body);
      //final String storeToken = responseData['token'];

      if (response.statusCode == 200) {
        if (responseData['Result'] == 'Found user' &&
            responseData['token'] != null) {
            _isLoggedIn = true;
            _errorMessage = '';
        } else {
            _errorMessage =
              responseData['message'] ??
              (responseData['error'] ?? 'User/Password Invaild');
              return;
        }
      } else {
          _errorMessage =
            responseData['message'] ??
            'Server responded with ${response.statusCode}';
            return;
      }
    } on FormatException {
      _errorMessage = 'Invalid server response format';
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      _errorMessage = '';
      notifyListeners();

      final response = await http.post(
        Uri.parse(signUpUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'Email': email, 'Password': password}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          _isLoggedIn = true;
          _errorMessage = '';
        } else {
          _errorMessage = responseData['message'] ?? 'Sign-up failed';
          _isLoggedIn = false;
        }
      } else {
        if (response.statusCode == 400) {
          _errorMessage = 'Email already exists';
        } else {
          _errorMessage = 'Sign-up failed. Please try again.';
        }
        _isLoggedIn = false;
      }
    } catch (e) {
      _errorMessage = 'Network error. Please check your connection.';
      _isLoggedIn = false;
    } finally {
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _errorMessage = '';
    notifyListeners();
  }
}
