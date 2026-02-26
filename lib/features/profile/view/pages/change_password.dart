import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/change_password_controller.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Change Password",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Form(
            key: controller.resetPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Old Password",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => _TextField(
                    controller: controller.oldPasswordController,
                    hintText: "Enter your old password",
                    isDark: isDark,
                    isPassword: true,
                    obscureText: !controller.isOldPasswordVisible.value,
                    toggleVisibility: controller.toggleOldPasswordVisibility,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Old Password is required";
                      if (value.length < 6)
                        return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "New Password",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => _TextField(
                    controller: controller.passwordController,
                    hintText: "Enter your new password",
                    isDark: isDark,
                    isPassword: true,
                    obscureText: !controller.isNewPasswordVisible.value,
                    toggleVisibility: controller.toggleNewPasswordVisibility,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "New password is required";
                      if (value.length < 6)
                        return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Confirm Password",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => _TextField(
                    controller: controller.confirmPasswordController,
                    hintText: "Confirm your new password",
                    isDark: isDark,
                    isPassword: true,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    toggleVisibility:
                        controller.toggleConfirmPasswordVisibility,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Confirm password is required";
                      if (value != controller.passwordController.text)
                        return "Passwords do not match";
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 48.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.changePassword(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isDark;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  final String? Function(String?)? validator;

  const _TextField({
    required this.controller,
    required this.hintText,
    required this.isDark,
    this.isPassword = false,
    this.obscureText = false,
    this.toggleVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.black38,
          fontSize: 14.sp,
        ),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.03),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.black12,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.black12,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  size: 20.r,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                onPressed: toggleVisibility,
              )
            : null,
      ),
    );
  }
}
