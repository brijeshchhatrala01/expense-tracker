import 'package:expence_tracker/screens/homescreen/homescreen.dart';
import 'package:expence_tracker/screens/loginscreen/loginscreen.dart';
import 'package:expence_tracker/screens/tabpage/tabpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const TabPage();
          } else {
            return  LoginScreen();
          }
        },
      ),
    );
  }
}
