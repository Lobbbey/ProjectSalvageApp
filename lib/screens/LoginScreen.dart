import 'package:flutter/material.dart';
import 'package:flutter_application_1/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screens/HomeScreen.dart';
import 'package:flutter_application_1/widgets/navbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.errorMessage.isNotEmpty && !_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () async {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1.0,
                vertical: 1.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Login
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Login',
                        hintText: 'Enter Your Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 10),
                  //Password
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter Your Password',
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 10),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          await authProvider.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          setState(() => _isLoading = false);
                          if (authProvider.isLoggedIn) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PersistentNavScaffold(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text('Don\'t have an account?\n Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
