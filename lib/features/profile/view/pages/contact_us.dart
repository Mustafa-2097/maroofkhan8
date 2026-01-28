import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controller/contact_us_controller.dart';

class ContactUs extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(ContactUsController());
  ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "SUPPORT CENTER",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// FULL NAME
                  InputField(
                    controller: controller.nameController,
                    suffixIcon:
                    const Icon(Icons.lock_outline, color: Colors.black45),
                    hint: "User Name",
                    enabled: false,
                  ),
                  SizedBox(height: 15.h),

                  /// EMAIL
                  InputField(
                    controller: controller.emailController,
                    suffixIcon:
                    const Icon(Icons.lock_outline, color: Colors.black45),
                    hint: "user@gmail.com",
                    enabled: false,
                  ),
                  SizedBox(height: 15.h),

                  /// MESSAGE BOX
                  InputField(
                    controller: controller.messageController,
                    hint: "Write your message...",
                    maxLines: 6,
                    contentPadding: EdgeInsets.all(16.w),
                    validator: (v) =>
                        controller.validateMessage(v!.trim()),
                  ),

                  SizedBox(height: 40.h),

                  /// SEND BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Send"),
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

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final int maxLines;
  final EdgeInsetsGeometry? contentPadding;

  const InputField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        filled: true,
        fillColor:
        enabled ? Colors.grey.shade100 : Colors.grey.shade200,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
