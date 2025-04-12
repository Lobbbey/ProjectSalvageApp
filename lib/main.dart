import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/routes/Routes.dart';
import 'package:flutter_application_1/AuthProvider.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/theme/ThemeProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      home: const PersistentNavScaffold(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      routes: Routes.getroutes,
    );
  }
}


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Inter',
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Color(0xFF646CFF),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xFF213547),
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    headlineLarge: TextStyle(
      fontSize: 51.2,
      height: 1.1,
      fontWeight: FontWeight.w400,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFF9F9F9),
      foregroundColor: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.transparent),
      ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Inter',
  scaffoldBackgroundColor: Color(0xFF242424),
  primaryColor: Color(0xFF646CFF),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xDEFFFFFF),
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    headlineLarge: TextStyle(
      fontSize: 51.2,
      height: 1.1,
      fontWeight: FontWeight.w400,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.transparent),
      ),
    ),
  ),
);
