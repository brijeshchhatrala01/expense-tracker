import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expence_tracker/screens/loginscreen/signupscreen.dart';

import '../../controllers/logincontroller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController()); // Inject Controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
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
          child: ListView(
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat-SemiBold',
                ),
              ),
              const SizedBox(height: 20),

              // Email
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat-Medium',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 16),

              // Password with GetX toggle
              Obx(() => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.obscurePassword.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    fontFamily: 'Montserrat-Medium',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(controller.obscurePassword.value
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: controller.togglePassword,
                  ),
                ),
                validator: (value) => value == null || value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              )),
              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: () => controller.login(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Montserrat-SemiBold',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
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

              // Google Sign In
              OutlinedButton.icon(
                onPressed: () => controller.googleLogin(context),
                icon: Image.asset(
                  'assets/google.png',
                  height: 24,
                ),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontFamily: 'Montserrat-SemiBold',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              // Signup Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not Registered on App?',
                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Montserrat-Regular'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Get.to(() =>  SignupScreen());
                    },
                    child: const Text('SignUp here',style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat-SemiBold',
                    ),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
