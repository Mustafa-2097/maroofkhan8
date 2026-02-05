import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';
import '../../controller/contact_us_controller.dart';

class ContactUs extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(ContactUsController());
  ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "CONTACT US",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  /// FULL NAME
                  _Label(text: "Full Name"),
                  _TextField(
                    controller: controller.nameController,
                    hint: "User Name",
                    suffixIcon: Icon(
                      Icons.lock_outline,
                      color: isDark ? Colors.white70 : Colors.black45,
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 16),

                  /// EMAIL
                  _Label(text: "Email"),
                  _TextField(
                    controller: controller.emailController,
                    hint: "user@gmail.com",
                    suffixIcon: Icon(
                      Icons.lock_outline,
                      color: isDark ? Colors.white70 : Colors.black45,
                    ),
                    enabled: false,
                  ),
                  const SizedBox(height: 16),

                  /// MESSAGE BOX
                  _Label(text: "Message *"),
                  _TextField(
                    controller: controller.messageController,
                    hint: "Write your message here...",
                    maxLines: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Message is required";
                      }
                      if (value.length < 10) {
                        return "Message must be at least 10 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  /// SEND BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => controller.contactChange(_formKey),
                      child: Text(
                        "Send Message",
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

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Widget? suffixIcon;
  final bool enabled;
  final int maxLines;
  final String? Function(String?)? validator;

  const _TextField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      maxLines: maxLines,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: enabled
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).disabledColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).disabledColor,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: enabled
            ? (isDark ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade50)
            : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 16 : 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}