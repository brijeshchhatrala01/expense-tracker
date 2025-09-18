import 'package:expence_tracker/widgets/customcontainerbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expence_tracker/screens/loginscreen/signupscreen.dart';
import '../../constant/colorsfile.dart';
import '../../controllers/logincontroller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController()); // Inject Controller

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
                180.verticalSpace,
                Align(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Welcome Back!',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat-SemiBold',
                    ),
                  ),
                ),
                60.verticalSpace,
                // Email
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: kBlackColor,
                  // 👈 black cursor
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      fontFamily: 'Montserrat-Medium',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: kBlackColor, // 👈 label color black
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: kBlackColor,
                        width: 1,
                      ), // 👈 black border
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: kBlackColor,
                        width: 1.5,
                      ), // 👈 black border when focused
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: kBlackColor,
                        width: 1,
                      ), // 👈 black border on error
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: kBlackColor,
                        width: 1.5,
                      ), // 👈 black border on error + focus
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty || !value.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
            
                60.verticalSpace,
                // Password with GetX toggle
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword.value,
                    cursorColor: kBlackColor,
                    // 👈 black cursor
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontFamily: 'Montserrat-Medium',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: kBlackColor, // 👈 label text black
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: kBlackColor,
                          width: 1,
                        ), // 👈 black border
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: kBlackColor,
                          width: 1.5,
                        ), // 👈 black border when focused
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: kBlackColor,
                          width: 1,
                        ), // 👈 black border on error
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: kBlackColor,
                          width: 1.5,
                        ), // 👈 black border on error + focus
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: kBlackColor, // 👈 make eye icon black too
                        ),
                        onPressed: controller.togglePassword,
                      ),
                    ),
                    validator: (value) => value == null || value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
            
                CustomContainerButton(
                  onPressed: () => controller.login(context),
                  buttonHeight: 60,
                  buttonWidth: 370,
                  buttonColor: kBlackColor,
                  buttonRadius: 12,
                  buttonText: 'Login',
                  buttonTextFontWeight: FontWeight.w400,
                  buttonTextFontFamily: 'Montserrat-SemiBold',
                  buttonTextFontSize: 16,
                  buttonTextColor: kWhiteColor,
                ),
                // Login Button
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
            
                CustomContainerButton(
                  onPressed: () =>controller.googleLogin(context),
                  buttonHeight: 60,
                  buttonWidth: 370,
                  buttonColor: kBlackColor,
                  buttonRadius: 12,
                  buttonText: 'Sign in with Google',
                  buttonTextFontWeight: FontWeight.w400,
                  buttonTextFontFamily: 'Montserrat-SemiBold',
                  buttonTextFontSize: 16,
                  buttonTextColor: kWhiteColor,
                  svgAsset: 'assets/svgIcons/google.svg',
                ),
            
                const SizedBox(height: 12),
            
                // Signup Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not Registered on App?',
                      style: TextStyle(
                        color: kBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat-Regular',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => SignupScreen());
                      },
                      child: const Text(
                        'SignUp here',
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
