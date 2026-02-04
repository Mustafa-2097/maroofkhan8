import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_colors.dart';
import '../../controller/personal_data_controller.dart';

class PersonalData extends StatelessWidget {
  const PersonalData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalDataController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile Details",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24), // Standard Padding
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                /// --- Profile Image Section ---
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: isDark ? Color(0xFF494358) : Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                /// --- Form Fields (Using your Project Standards) ---
                const _Label(text: "Full Name"),
                _TextField(
                  controller: controller.nameController,
                  hint: "Enter your name",
                ),

                const SizedBox(height: 16),
                const _Label(text: "Phone Number"),
                _TextField(
                  controller: controller.phoneController,
                  hint: "12345678",
                ),

                const SizedBox(height: 16),
                const _Label(text: "Email"),
                _TextField(
                  controller: controller.emailController,
                  hint: "example@gmail.com",
                ),

                const SizedBox(height: 16),
                const _Label(text: "Country / Region"),
                _DropdownField(value: "Bangladesh"),

                const SizedBox(height: 16),
                const _Label(text: "Gender"),
                _DropdownField(value: "Male"),

                const SizedBox(height: 16),
                const _Label(text: "Date of Birth"),
                _TextField(
                  controller: controller.dobController,
                  hint: "DD/MM/YYYY",
                  suffixIcon: Icon(Icons.calendar_month_outlined,
                      color: Theme.of(context).disabledColor),
                ),

                const SizedBox(height: 40),

                /// --- Save Button ---
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.saveProfile,
                    child: const Text("Save Changes"),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// REUSABLE COMPONENTS (Matches your Auth Page Architecture)

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? suffixIcon;

  const _TextField({required this.controller, required this.hint, this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppColors.primaryColorDark : AppColors.primaryColorLight,
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String value;
  const _DropdownField({required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.primaryColorDark : AppColors.primaryColorLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
          Icon(Icons.keyboard_arrow_down, color: Theme.of(context).disabledColor),
        ],
      ),
    );
  }
}