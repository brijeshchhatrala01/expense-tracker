import 'package:expence_tracker/screens/loginscreen/loginscreen.dart';
import 'package:expence_tracker/widgets/customcontainerbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constant/colorsfile.dart';
import '../../controllers/signupcontroller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final controller = Get.put(SignupController());

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontFamily: 'Montserrat-Medium',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: kBlackColor,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: kBlackColor, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: kBlackColor, width: 1.5),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: kBlackColor, width: 1),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: kBlackColor, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Expense-Tracker',
          style: TextStyle(
            fontFamily: 'Montserrat-Regular',
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                120.verticalSpace,
                Align(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat-SemiBold',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
            
                // Full Name
                TextFormField(
                  controller: controller.nameController,
                  cursorColor: kBlackColor,
                  decoration: _inputDecoration('Full Name'),
                  validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Enter your name'
                      : null,
                ),
                const SizedBox(height: 16),
            
                // Email
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: kBlackColor,
                  decoration: _inputDecoration('Email'),
                  validator: (value) =>
                  value == null || !value.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 16),
            
                // Password
                Obx(() => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  cursorColor: kBlackColor,
                  decoration: _inputDecoration(
                    'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kBlackColor,
                      ),
                      onPressed: controller.togglePassword,
                    ),
                  ),
                  validator: (value) => value == null || value.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                )),
                const SizedBox(height: 16),
            
                // Confirm Password
                Obx(() => TextFormField(
                  controller: controller.confirmPasswordController,
                  obscureText: controller.obscureConfirmPassword.value,
                  cursorColor: kBlackColor,
                  decoration: _inputDecoration(
                    'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureConfirmPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kBlackColor,
                      ),
                      onPressed: controller.toggleConfirmPassword,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm your password';
                    } else if (value !=
                        controller.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                )),
                const SizedBox(height: 24),
            
                // Sign Up Button (CustomContainerButton)
                CustomContainerButton(
                  onPressed: () => controller.signup(context),
                  buttonHeight: 60,
                  buttonWidth: double.infinity,
                  buttonColor: kBlackColor,
                  buttonRadius: 12,
                  buttonText: 'Sign Up',
                  buttonTextFontWeight: FontWeight.w400,
                  buttonTextFontFamily: 'Montserrat-SemiBold',
                  buttonTextFontSize: 16,
                  buttonTextColor: kWhiteColor,
                ),
                const SizedBox(height: 12),
            
                // Divider
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontFamily: 'Montserrat-Regular',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),
            
                // Google Sign-Up (CustomContainerButton with svg)
                CustomContainerButton(
                  onPressed: () => controller.googleSignup(context),
                  buttonHeight: 60,
                  buttonWidth: double.infinity,
                  buttonColor: kBlackColor,
                  buttonRadius: 12,
                  buttonText: 'Sign up with Google',
                  buttonTextFontWeight: FontWeight.w400,
                  buttonTextFontFamily: 'Montserrat-SemiBold',
                  buttonTextFontSize: 16,
                  buttonTextColor: kWhiteColor,
                  svgAsset: 'assets/svgIcons/google.svg',
                ),
                40.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already Registered on App?',
                      style: TextStyle(
                        color: kBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat-Regular',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => LoginScreen());
                      },
                      child: const Text(
                        'Log in here',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat-SemiBold',
                            color: kBlackColor
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
