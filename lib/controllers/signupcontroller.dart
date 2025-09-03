import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expence_tracker/firebase_service/firebase_auth/authentication_check.dart';
import 'package:expence_tracker/firebase_service/firebase_auth/authentication_service.dart';

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
      final email = emailController.text.trim();
      // TODO: Firebase Sign Up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signing up as $email")),
      );
    }
  }

  void googleSignup(BuildContext context) {
    AuthenticationService().googleSignin(context).whenComplete(() {
      Get.offAll(() => AuthCheck());
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Google Sign-Up clicked")),
    );
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
}
