import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expence_tracker/firebase_service/firebase_auth/authentication_check.dart';
import 'package:expence_tracker/firebase_service/firebase_auth/authentication_service.dart';

import '../constant/colorsfile.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;

  void signup(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      AuthenticationService().signUpUser(email, password,name).whenComplete(() {
        Get.snackbar(
          "Signup Successful 🎉",
          "Welcome!",
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
  }

  void googleSignup(BuildContext context) {
    AuthenticationService().googleSignin(context).whenComplete(() {
      Get.snackbar(
        "Signup Successful 🎉",
        "Welcome!",
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

  void toggleConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
}
