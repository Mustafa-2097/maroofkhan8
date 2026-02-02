import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_colors.dart';
import '../../forgot_password/view/forgot_password_page.dart';
import '../controller/signin_signup_controller.dart';

class SignInSignUpPage extends StatelessWidget {
  SignInSignUpPage({super.key});
  final controller = Get.put(SignInSignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Obx(
                  () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  /// Title
                  Center(
                    child: Text(
                      controller.isLogin.value ? 'Login' : 'Sign Up',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Subtitle
                  Center(
                    child: Text(
                      'Log in or register to save your progress',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Toggle buttons
                  _AuthToggle(),

                  const SizedBox(height: 32),

                  if (!controller.isLogin.value) ...[
                    _Label(text: 'Full Name *'),
                    _TextField(
                      controller: controller.nameController,
                      hint: 'Username',
                      validator: (value) => value == null || value.isEmpty ? "Name is required" : null,
                    ),
                    const SizedBox(height: 16),
                  ],

                  _Label(text: 'Email *'),
                  _TextField(
                    controller: controller.emailController,
                    hint: 'example@gmail.com',
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Email is required";
                      if (!GetUtils.isEmail(value)) return "Enter a valid email";
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  ///
                  _Label(
                    text: controller.isLogin.value
                        ? 'Password'
                        : 'Create a password *',
                  ),
                  _TextField(
                    controller: controller.passwordController,
                    hint: 'must be 6 characters',
                    obscure: !controller.isPasswordVisible.value,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Password is required";
                      if (value.length < 6) return "Password must be at least 6 characters";
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).disabledColor,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),

                  /// Confirm Password (Signup Only)
                  if (!controller.isLogin.value) ...[
                    const SizedBox(height: 16),
                    _Label(text: 'Confirm password *'),
                    _TextField(
                      controller: controller.confirmPasswordController,
                      hint: 'repeat password',
                      obscure: !controller.isConfirmPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please confirm your password';
                        if (value != controller.passwordController.text) return "Passwords do not match";
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).disabledColor,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ],

                  if (controller.isLogin.value)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.to(() => ForgotPasswordPage()),
                        child: Text(
                          'Forgot password?',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  /// LogIn or SignUp button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.submit,
                      child: Text(
                        controller.isLogin.value
                         ? 'Log in'
                         : 'Sign Up',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Social login
                  Center(
                    child: Text(
                      controller.isLogin.value
                          ? 'Other Login options'
                          : 'Or Register with',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Google Logo
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Builder(
                        builder: (context) {
                          final theme = Theme.of(context);
                          final isDark = theme.brightness == Brightness.dark;

                          return Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: isDark ? Colors.grey.shade400 : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Image.asset(
                              'assets/images/google.png',
                              height: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthToggle extends GetView<SignInSignUpController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() => Row( // Add Obx here so the button colors update
        children: [
          _ToggleButton(
            text: 'Sign in',
            selected: controller.isLogin.value,
            onTap: controller.showLogin,
          ),
          _ToggleButton(
            text: 'Register',
            selected: !controller.isLogin.value,
            onTap: controller.showRegister,
          ),
        ],
      )),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          margin: EdgeInsets.only(left: 6, right: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent, // Colors.white : Colors.transparent
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _TextField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppColors.primaryColorDark : AppColors.primaryColorLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppColors.primaryColorDark : AppColors.primaryColorLight,
            width: 2,
          ),
        ),
        // Added error styling
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
