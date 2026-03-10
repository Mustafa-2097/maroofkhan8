import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_colors.dart';
import '../../forgot_password/view/forgot_password_page.dart';
import '../controller/signin_signup_controller.dart';

class SignInSignUpPage extends StatelessWidget {
  SignInSignUpPage({super.key});
  final controller = Get.put(SignInSignUpController());

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

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
                  SizedBox(height: sh * 0.03),

                  /// Title
                  Center(
                    child: Text(
                      controller.isLogin.value ? 'Login' : 'Sign Up',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),

                  SizedBox(height: sh * 0.01),

                  /// Subtitle
                  Center(
                    child: Text(
                      'Log in or register to save your progress',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Theme.of(context).disabledColor),
                    ),
                  ),

                  SizedBox(height: sh * 0.03),

                  /// Toggle buttons
                  _AuthToggle(),

                  SizedBox(height: sh * 0.04),

                  if (!controller.isLogin.value) ...[
                    _Label(text: 'Full Name *'),
                    _TextField(
                      controller: controller.nameController,
                      hint: 'Your name',
                      validator: (value) => value == null || value.isEmpty
                          ? "Name is required"
                          : null,
                    ),
                    SizedBox(height: sh * 0.02),
                  ],

                  _Label(text: 'Email *'),
                  _TextField(
                    controller: controller.emailController,
                    hint: 'Enter your email',
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Email is required";
                      if (!GetUtils.isEmail(value))
                        return "Enter a valid email";
                      return null;
                    },
                  ),

                  SizedBox(height: sh * 0.02),

                  if (!controller.isLogin.value) ...[
                    _Label(text: 'Phone Number *'),
                    _PhoneField(),
                    SizedBox(height: sh * 0.02),
                  ],

                  ///
                  _Label(
                    text: controller.isLogin.value
                        ? 'Password'
                        : 'Create a password *',
                  ),
                  _TextField(
                    controller: controller.passwordController,
                    hint: 'Enter your password',
                    obscure: !controller.isPasswordVisible.value,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Password is required";
                      if (value.length < 6)
                        return "Password must be at least 6 characters";
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).disabledColor,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),

                  /// Confirm Password (Signup Only)
                  if (!controller.isLogin.value) ...[
                    SizedBox(height: sh * 0.02),
                    _Label(text: 'Confirm password *'),
                    _TextField(
                      controller: controller.confirmPasswordController,
                      hint: 'Repeat the password',
                      obscure: !controller.isConfirmPasswordVisible.value,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please confirm your password';
                        if (value != controller.passwordController.text)
                          return "Passwords do not match";
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ),

                  SizedBox(height: sh * 0.03),

                  /// LogIn or SignUp button
                  SizedBox(
                    width: double.infinity,
                    height: sh * 0.06,
                    child: ElevatedButton(
                      onPressed: controller.submit,
                      child: Text(
                        controller.isLogin.value ? 'Log in' : 'Sign Up',
                      ),
                    ),
                  ),

                  SizedBox(height: sh * 0.03),

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

                  SizedBox(height: sh * 0.02),

                  /// Google Logo
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Builder(
                        builder: (context) {
                          final theme = Theme.of(context);
                          final isDark = theme.brightness == Brightness.dark;

                          return Container(
                            height: sw * 0.12,
                            width: sw * 0.12,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Image.asset(
                              'assets/images/google.png',
                              height: sw * 0.1,
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
    final sh = MediaQuery.of(context).size.height;
    return Container(
      height: sh * 0.05,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(
        () => Row(
          // Add Obx here so the button colors update
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
          height: 30, // Keeping this fixed or using sh? Let's use it relative.
          margin: const EdgeInsets.only(left: 6, right: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).scaffoldBackgroundColor
                : Colors.transparent, // Colors.white : Colors.transparent
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(text, style: Theme.of(context).textTheme.titleLarge),
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
            color: isDark
                ? AppColors.primaryColorDark
                : AppColors.primaryColorLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.primaryColorDark
                : AppColors.primaryColorLight,
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

class _PhoneField extends GetView<SignInSignUpController> {
  const _PhoneField();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(
      () => IntlPhoneField(
        controller: controller.phoneController,
        initialCountryCode: 'BD', // Adjust as needed
        autovalidateMode: AutovalidateMode.disabled,
        disableLengthCheck: true,
        onChanged: (phone) {
          controller.fullPhoneNumber.value = phone.completeNumber;
          controller.phoneError.value = null;
        },
        decoration: InputDecoration(
          hintText: 'Your Phone Number',
          counterText: '',
          errorText: controller.phoneError.value,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark
                  ? AppColors.primaryColorDark
                  : AppColors.primaryColorLight,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDark
                  ? AppColors.primaryColorDark
                  : AppColors.primaryColorLight,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
