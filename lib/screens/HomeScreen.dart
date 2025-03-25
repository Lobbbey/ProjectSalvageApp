import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/AuthProvider.dart';
import 'package:flutter_application_1/routes/Routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salvage Financials'),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Text('Welcome to Salvage Financials!'), 
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Dashboard'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            if(!authProvider.isLoggedIn)
              ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            if(!authProvider.isLoggedIn)
            ListTile(
              title: const Text('SignUp'),
              onTap: () {
                Navigator.pushNamed(context, '/SignUp');
              },
            ),
            if(authProvider.isLoggedIn)
            ListTile(
              title: const Text('Income'),
              onTap: () {
                Navigator.pushNamed(context, '/income');
              },
            ),
            if(authProvider.isLoggedIn)
            ListTile(
              title: const Text('Expenses'),
              onTap: () {
                Navigator.pushNamed(context, '/expense');
              },
            ),
            if(authProvider.isLoggedIn)
            ListTile(
              title: const Text('Analytics'),
              onTap: () {
                Navigator.pushNamed(context, '/analytics');
              },
            ),
            if(authProvider.isLoggedIn)
              ListTile(
                title: const Text('Logout'),
                onTap: () async {
                  authProvider.logout();
                  Navigator.pop(context, '/home');
                },
              ),
          ],
        ),
      );
  }
}