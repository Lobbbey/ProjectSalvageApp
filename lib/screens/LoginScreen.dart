import 'package:flutter/material.dart';
import 'package:flutter_application_1/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salvage Financials'),
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
      drawer: CustomDrawer(),
      backgroundColor: Colors.grey,
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
                        hintText: 'Enter Your Login Name',
                      ),
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
                    ),
                  ),
                  SizedBox(height: 10),
                  //Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await authProvider.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                        Navigator.pushNamed(context, '/analytics');
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(e.toString())
                          )
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
