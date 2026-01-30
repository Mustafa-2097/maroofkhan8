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
                    hint: 'Your name',
                  ),
                  const SizedBox(height: 16),
                ],

                _Label(text: 'Email *'),
                _TextField(
                  controller: controller.emailController,
                  hint: 'example@gmail.com',
                ),

                const SizedBox(height: 16),

                _Label(
                  text: controller.isLogin.value
                      ? 'Password'
                      : 'Create a password *',
                ),
                _TextField(
                  controller: controller.passwordController,
                  hint: 'must be 6 characters',
                  obscure: true,
                ),

                if (!controller.isLogin.value) ...[
                  const SizedBox(height: 16),
                  _Label(text: 'Confirm password *'),
                  _TextField(
                    controller: controller.confirmPasswordController,
                    hint: 'repeat password',
                    obscure: true,
                  ),
                ],

                if (controller.isLogin.value)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.to(() => ForgotPasswordPage()),
                      child: const Text('Forgot password?'),
                    ),
                  ),

                const SizedBox(height: 24),

                /// Submit button
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
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Builder(
                      builder: (context) {
                        final theme = Theme.of(context);
                        final isDark = theme.brightness == Brightness.dark;

                        return Image.asset(
                          'assets/images/google.png',
                          height: 50,
                        );
                      },
                    ),
                  ),
                )

              ],
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
      child: Row(
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
      ),
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

  const _TextField({
    required this.controller,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
