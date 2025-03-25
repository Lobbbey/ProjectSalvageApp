import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/routes/Routes.dart'; // Ensure this import is correct
import 'package:flutter_application_1/AuthProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      routes: Routes.getroutes, // Ensure Routes.getroutes is defined
      ),
    );
  }
}