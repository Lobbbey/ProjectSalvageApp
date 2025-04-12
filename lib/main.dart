import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/routes/Routes.dart'; // Ensure this import is correct
import 'package:flutter_application_1/AuthProvider.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        home: const PersistentNavScaffold(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        routes: Routes.getroutes, // Ensure Routes.getroutes is defined
      ),
    );
  }
}
