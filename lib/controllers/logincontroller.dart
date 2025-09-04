import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expence_tracker/firebase_service/firebase_auth/authentication_check.dart';
import 'package:expence_tracker/firebase_service/firebase_auth/authentication_service.dart';

import '../constant/colorsfile.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs; // RxBool for toggle

  final formKey = GlobalKey<FormState>();

  void login(BuildContext context) {
    if (formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      AuthenticationService().signInUser(email, password).whenComplete(() {
        Get.snackbar(
          "Login Successful 🎉",
          "Welcome back!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: kWhiteColor,
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
        );
        Get.offAll(() => AuthCheck());
      },);
    }
  }

  void googleLogin(BuildContext context) {
    AuthenticationService().googleSignin(context).whenComplete(() {
      Get.snackbar(
        "Login Successful 🎉",
        "Welcome back!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: kWhiteColor,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
      );
      Get.offAll(() => AuthCheck());
    });
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }
}
