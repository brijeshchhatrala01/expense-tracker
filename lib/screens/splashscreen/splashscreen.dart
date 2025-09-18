import 'package:expence_tracker/constant/colorsfile.dart';
import 'package:expence_tracker/screens/loginscreen/loginscreen.dart';
import 'package:expence_tracker/screens/tabpage/tabpage.dart'; // Import your TabPage
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // Check if user already logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is logged in → go to TabPage
        Get.off(() =>  TabPage());
      } else {
        // User not logged in → go to LoginScreen
        Get.off(() => LoginScreen());
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Expense-Tracker',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat-Bold',
                color: kBlackColor,
              ),
            ),
            const SizedBox(height: 38),
            Text(
              'Smart tracking for \nsmarter spending',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat-SemiBold',
                color: kBlackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
