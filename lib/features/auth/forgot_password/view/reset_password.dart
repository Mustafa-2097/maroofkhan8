import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:maroofkhan8/features/auth/forgot_password/controller/reset_password_controller.dart';

import '../../../../core/constant/app_colors.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});
  final controller = Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.resetPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: sh * 0.05),
                Center(
                  child: Text(
                    tr('reset_title'),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                /// Subtitle
                Text(
                  tr('reset_subtitle'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: sh * 0.04),

                /// Create a password
                _Label(text: tr('reset_new_password_label')),
                Obx(
                  () => _TextField(
                    controller: controller.passwordController,
                    hint: tr('reset_new_password_hint'),
                    obscure: !controller.isPasswordVisible.value,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return tr('reset_password_required');
                      if (value.length < 6)
                        return tr('reset_password_min_length');
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
                ),

                SizedBox(height: sh * 0.02),

                /// Confirm password
                _Label(text: tr('reset_confirm_label')),
                Obx(
                  () => _TextField(
                    controller: controller.confirmPasswordController,
                    hint: tr('reset_confirm_hint'),
                    obscure: !controller.isConfirmPasswordVisible.value,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return tr('reset_confirm_required');
                      if (value != controller.passwordController.text)
                        return tr('reset_passwords_not_match');
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
                ),

                SizedBox(height: sh * 0.04),

                /// Reset Password button
                SizedBox(
                  width: double.infinity,
                  height: sh * 0.06,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.resetPassword(), // Call the method
                    child: Text(tr('reset_button')),
                  ),
                ),
              ],
            ),
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
        // Error styling
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
