import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _errorMessage = '';

  bool get isLoggedIn => _isLoggedIn;
  String get errorMessage => _errorMessage;

  final String loginUrl = 'http://salvagefinancial.xyz:5000/api/Login';

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

  // Method to sign up using API
  Future<void> signUp(
    String fName,
    String lName,
    String email,
    String password,
  ) async {
    try {
      const String signUpUrl = 'http://salvagefinancial.xyz:5000/api/signup';
      final response = await http.post(
        Uri.parse(signUpUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Email': email,
          'Password': password,
          'FName': fName,
          'LName': lName,
        }),
      );

      if (response.statusCode == 200) {
        // Successful sign-up
        final responseData = json.decode(response.body);
        String result = responseData['Result'] ?? "Unknown error";
        if (result == 'Added user') {
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
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> ResetPassword(String email, String newPass) async {
    try{
      const String rstPwdURI = 'http://salvagefinancial.xyz:5000/api/ResetPassword';
      final Map<String, String> requestBody = {
        'Email': email,
        'NewPass': newPass,
      };

      final response = await http.post(
        Uri.parse(rstPwdURI),
        headers: {
          'Content-Type': 'application/json',
        },
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode(requestBody),
      );


        if(response.statusCode == 200){
          
        }
        else{

        }
    }
    catch (e){
      _errorMessage = '';
    }
    finally{
      notifyListeners();
    }
  }

  Future<void> AddInitial(int InitialDebt, int InitialAmount) async{
    const Result = "Could not add amount and debt";
    try{

    }
    catch(e){
      _errorMessage = 'Could Not add amount and debt';
    }
    finally{
      notifyListeners();
    }
  }

  Future<void> AddIncome(String Name, int Amount, bool ifReccuring ) async{}

  Future<void> AddExpense(String Name, int Amount, String Catagory) async {}

  Future<void> EditIncome(String temp) async {}
}