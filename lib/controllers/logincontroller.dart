import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expence_tracker/firebase_service/firebase_auth/authentication_check.dart';
import 'package:expence_tracker/firebase_service/firebase_auth/authentication_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var obscurePassword = true.obs; // RxBool for toggle

  final formKey = GlobalKey<FormState>();

  void login(BuildContext context) {
    if (formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;

      // TODO: Firebase or custom logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logging in as $email")),
      );
    }
  }

  void googleLogin(BuildContext context) {
    AuthenticationService().googleSignin(context).whenComplete(() {
      Get.offAll(() => AuthCheck());
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In clicked')),
    );
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }
}
