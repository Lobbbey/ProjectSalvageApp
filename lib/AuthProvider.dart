import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _errorMessage = '';
  bool _addedInitial = false;
  String _jwtToken = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get addedInitial => _addedInitial;
  String get errorMessage => _errorMessage;
  String get jwtToken => _jwtToken;


  Future<void> login(String email, String password) async {
    try {
      final String loginUrl = 'http://salvagefinancial.xyz:5000/api/Login';
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
          _jwtToken = responseData['token'];
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

  Future<void> ResetPassword(String newEmail, String newPass) async {
    try {
      const String rstPwdURI =
          'http://salvagefinancial.xyz:5000/api/ResetPassword';
      final response = await http.post(
        Uri.parse(rstPwdURI),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_jwtToken'},
        body: json.encode({'Email': newEmail, 'Password': newPass}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String result = responseData['Result'] ?? "Unknown error";
        if (result != 'Changed password of user') {
          throw Exception('Password Change Failed Check info');
        }
      } else {}
    } catch (e) {
      _errorMessage = '';
    } finally {
      notifyListeners();
    }
  }

  Future<void> AddInitial(int InitialDebt, int InitialAmount) async {
    _errorMessage = '';
    _addedInitial = false;
    print(jwtToken);
    try {
      const String addInitURL =
          'http://salvagefinancial.xyz:5000/api/AddInitial';
      final response = await http.post(
        Uri.parse(addInitURL),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_jwtToken'},
        body: json.encode({
          'InitialDebt': InitialDebt,
          'InitialAmount': InitialAmount,
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _addedInitial = true; 
        _errorMessage = ''; 
      } else {
        _addedInitial = false;
        _errorMessage = responseData['message'] ?? 
                       (responseData['error'] ?? 'Error adding info');
      }
    } catch (e) {
      _errorMessage = 'Could Not add amount and debt';
      return;
    } finally {
      notifyListeners();
    }
  }

  Future<void> AddIncome(
    String Name,
    int Amount,
    bool ifReccuring, {
    String? InitialTime,
    String? timeFrame,
  }) async {
    final String addIncomeURL =
        'http://salvagefinancial.xyz:5000/api/AddIncome';
    try {
      _errorMessage = '';

      final response = await http.post(
        Uri.parse(addIncomeURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_jwtToken'
        },
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode({
          'Name': Name,
          'Amount': Amount,
          'IfReccuring': ifReccuring,
          if (InitialTime != null) 'InittialTime': InitialTime,
          if (timeFrame != null) 'timeFrame': timeFrame,
        }),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _errorMessage = "Success: ${responseData['Result']}";
      } else {
        _errorMessage = "⚠️ Error: ${responseData['Result']}";
      }
    } catch (e) {
      _errorMessage = "Failed to Add Income";
    }
  }

  Future<void> AddExpense(
    String Name,
    String Catagory,
    int Amount,
    bool IfReccuring, {
    String? InitialTime,
    String? timeFrame,
  }) async {
    _errorMessage = '';
    final String addExpenseURL =
        'http://salvagefinancial.xyz:5000/api/AddExpense';
    try {
      final response = await http.post(
        Uri.parse(addExpenseURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_jwtToken'
        },
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode({
          'Name': Name,
          'Amount': Amount,
          'IfReccuring': IfReccuring,
          if (InitialTime != null) 'InittialTime': InitialTime,
          if (timeFrame != null) 'timeFrame': timeFrame,
        }),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _errorMessage = "Success: ${responseData['Result']}";
      } else {
        _errorMessage = "Error: ${responseData['Result']}";
      }
    } catch (e) {
      _errorMessage = 'Failed to add expense';
    }
  }

  Future<void> EditIncome(
    String newName,
    int index,
    int newAmount,
    bool newIfReccuring, {
    String? newInitialTime,
    String? newTimeFrame,
  }) async {
    _errorMessage = '';
    final String editIncomeURL =
        'http://salvagefinancial.xyz:5000/api/EditIncome';

    try {
      final response = await http.post(
        Uri.parse(editIncomeURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_jwtToken'
        },
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode({
          'Name': newName,
          'index': index,
          'Amount': newAmount,
          'IfReccuring': newIfReccuring,
          if (newInitialTime != null) 'InittialTime': newInitialTime,
          if (newTimeFrame != null) 'timeFrame': newTimeFrame,
        }),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _errorMessage = "Success: ${responseData['Result']}";
      } else {
        _errorMessage = "⚠️ Error: ${responseData['Result']}";
      }
    } catch (e) {
      _errorMessage = "Failed to edit income";
    }
  }

  Future<void> EditExpense(
    String newName,
    int index,
    int newAmount,
    String newCatagory,
    bool newIfReccuring, {
    String? newInitialTime,
    String? newTimeFrame,
  }) async {
    _errorMessage = '';
    final String editExpenseURL =
        'http://salvagefinancial.xyz:5000/api/EditExpense';

    try {
      final response = await http.post(
        Uri.parse(editExpenseURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_jwtToken'
        },
        encoding: Encoding.getByName("utf-8"),
        body: jsonEncode({
          'Name': newName,
          'index': index,
          'Amount': newAmount,
          'IfReccuring': newIfReccuring,
          if (newInitialTime != null) 'InittialTime': newInitialTime,
          if (newTimeFrame != null) 'timeFrame': newTimeFrame,
        }),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _errorMessage = "Success: ${responseData['Result']}";
      } else {
        _errorMessage = "⚠️ Error: ${responseData['Result']}";
      }
    } catch (e) {
      _errorMessage = "Failed to edit income";
    }
  }

  Future<void> DeleteIncome(int index) async {
    _errorMessage = '';
    final String deleteIncmURL =
        'http://salvagefinancial.xyz:5000/api/DeleteIncome';

    try {
      final response = await http.post(
        Uri.parse(deleteIncmURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_jwtToken'
        },
        body: jsonEncode({'index': index}),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _errorMessage = "Success: ${responseData['Result']}";
      } else {
        _errorMessage = "⚠️ Error: ${responseData['Result']}";
      }
    } catch (e) {
      _errorMessage = 'Could Not Delete Income';
    }
  }

  Future<void> DeleteExpense(int index) async {
    _errorMessage = '';
    final String deleteExpenseURL =
        'http://salvagefinancial.xyz:5000/api/DeleteExpense';

    try {
      final response = await http.post(
        Uri.parse(deleteExpenseURL),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_jwtToken'
        },
        body: jsonEncode({'index': index}),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _errorMessage = "Success: ${responseData['Result']}";
      } else {
        _errorMessage = "⚠️ Error: ${responseData['Result']}";
      }
    } catch (e) {
      _errorMessage = 'Could Not Delete Income';
    }
  }

  Future<void> ShowAllInfo() async {
    _errorMessage = '';
    final String ShowAllInfoURL =
        'http://salvagefinancial.xyz:5000/api/ShowAllInfo';

    try {
      final response = await http.post(
        Uri.parse('http://YOUR_LOCAL_IP:5000/api/ShowAllInfo'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_jwtToken'
        },
        body: jsonEncode({
        }),
      );

      final responseData = json.decode(response.body);
      print("Fetch User Info Response: ${response.body}"); // Debugging

      if (response.statusCode == 200 &&
          responseData['Result'] == "Found user") {
        return responseData['User']; // Return user object
      } else {
        print("⚠️ Error: ${responseData['Result']}");
        return null;
      }
    } catch (e) {
      _errorMessage = 'Could not display all user info';
    }
  }
}
