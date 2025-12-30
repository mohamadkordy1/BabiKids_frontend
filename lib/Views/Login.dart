import 'package:frontend/Controllers/LoginController.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Routes/AppRoute.dart';

final LoginController controller = Get.put(LoginController());

class Login extends GetView<LoginController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0E10),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.school, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 30),

                // Title
                Text(
                  "Welcome Back!",
                  style: GoogleFonts.manrope(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Please sign in to continue",
                  style: GoogleFonts.manrope(fontSize: 16, color: Color(0xFFE0E0E0)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),

                // Email Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email Address",
                    style: GoogleFonts.manrope(
                        color: Color(0xFFE0E0E0),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                _buildInputField(hint: "Enter your email", controller: controller.email, obscure: false),
                const SizedBox(height: 25),

                // Password Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: GoogleFonts.manrope(
                        color: Color(0xFFE0E0E0),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => _buildInputField(
                  hint: "Enter your password",
                  controller: controller.password,
                  obscure: !controller.showPassword.value,
                  isPassword: true,
                  onToggle: () => controller.showPassword.toggle(),
                )),
                const SizedBox(height: 30),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    // Inside your Sign In button
                    onPressed: () async {
                      try {
                        await controller.loginUser();
                      } catch (_) {
                        // Show short friendly message regardless of the server response
                        Get.snackbar(
                          'Login Failed',
                          'Invalid email or password',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },

                    child: Text(
                      "Sign In",
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Forgot Password

                const SizedBox(height: 10),

                // Sign Up
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.manrope(color: Color(0xFFE0E0E0), fontSize: 14),
                  ),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoute.registrater),
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.manrope(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    bool isPassword = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.manrope(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1F2224),
        hintText: hint,
        hintStyle: GoogleFonts.manrope(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x803B82F6), width: 2),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFD1D5DB)),
          onPressed: onToggle,
        )
            : null,
      ),
    );
  }
}
