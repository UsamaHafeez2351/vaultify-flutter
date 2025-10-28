import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../utils/constants.dart';
import '../../routes/app_routes.dart';
import '../../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kPrimaryColor,
              kPrimaryColor.withOpacity(0.8),
              kAccentColor.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    const SizedBox(height: 40),
                    // 🔹 Animated Icon
                    Center(
                      child: Hero(
                        tag: 'app_icon',
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.lock_rounded,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // 🔹 App Title
                    const Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black26,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Login to your secure vault",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // 🔹 Email Field
                    _buildTextField(
                      controller: emailController,
                      label: "Email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Password Field
                    _buildTextField(
                      controller: passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 🔹 Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showForgotPasswordDialog(context),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Login Button
                    Obx(() => _buildGradientButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : () {
                        authController.login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                      child: authController.isLoading.value
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )),
                    const SizedBox(height: 30),

                    // 🔹 Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.signup),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: onPressed == null
              ? [Colors.grey, Colors.grey.shade600]
              : [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: onPressed == null
            ? []
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildOutlineButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: child,
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final authController = Get.find<AuthController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.defaultDialog(
      title: 'Reset Password',
      titleStyle: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: isDark ? const Color(0xFF1E1E2D) : Colors.white,
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? kPrimaryColorDark : kPrimaryColorLight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
              ),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
      confirm: Obx(() => authController.isLoading.value
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () async {
                if (emailController.text.trim().isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please enter your email address',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                try {
                  await authController.forgotPassword(emailController.text.trim());
                  Get.back();
                  Get.snackbar(
                    'Email Sent',
                    'Check your email for a password reset link',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 5),
                  );
                } catch (e) {
                  // Error is shown by the authController
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Send Reset Link'),
            )),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
    );
  }
}
