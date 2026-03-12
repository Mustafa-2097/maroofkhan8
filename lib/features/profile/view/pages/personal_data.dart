import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
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
          tr("profile_details"),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: isDark
                                ? const Color(0xFF494358)
                                : Colors.grey.shade200,
                            backgroundImage:
                                controller.profileImage.value != null
                                ? FileImage(controller.profileImage.value!)
                                : (controller.userData.value?.profile?.avatar !=
                                              null
                                          ? NetworkImage(
                                              controller
                                                  .userData
                                                  .value!
                                                  .profile!
                                                  .avatar!,
                                            )
                                          : null)
                                      as ImageProvider?,
                            child:
                                (controller.profileImage.value == null &&
                                    controller
                                            .userData
                                            .value
                                            ?.profile
                                            ?.avatar ==
                                        null)
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: isDark
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade600,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: GestureDetector(
                            onTap: controller.pickImage,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// --- Form Fields (Using your Project Standards) ---
                  const _Label(text: "full_name"),
                  _TextField(
                    controller: controller.nameController,
                    hint: tr("enter_your_name"),
                  ),

                  const SizedBox(height: 16),
                  const _Label(text: "phone_number"),
                  _TextField(
                    controller: controller.phoneController,
                    hint: "Enter your phone number", // Keep as sample
                  ),

                  const SizedBox(height: 16),
                  const _Label(text: "email"),
                  _TextField(
                    controller: controller.emailController,
                    hint: "Enter your email address",
                  ),

                  const SizedBox(height: 16),
                  const _Label(text: "country_region"),
                  Obx(
                    () => _DropdownField(
                      value: controller.selectedCountry.value,
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: false,
                          onSelect: (Country country) {
                            controller.selectedCountry.value =
                                "${country.flagEmoji} ${country.name}";
                          },
                          countryListTheme: CountryListThemeData(
                            bottomSheetHeight: 450, // Approximately 5 items
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            inputDecoration: InputDecoration(
                              labelText: tr('search'),
                              hintText: tr('search'),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(
                                    0xFF8C98A8,
                                  ).withOpacity(0.2),
                                ),
                              ),
                            ),
                            backgroundColor: isDark
                                ? const Color(0xFF2A2438)
                                : Colors.white,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  const _Label(text: "gender"),
                  Obx(
                    () => _DropdownField(
                      value: tr(controller.selectedGender.value),
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            color: isDark
                                ? const Color(0xFF2A2438)
                                : Colors.white,
                            child: ListView(
                              shrinkWrap: true,
                              children: ["male", "female"]
                                  .map(
                                    (g) => ListTile(
                                      title: Text(tr(g)),
                                      onTap: () {
                                        controller.selectedGender.value = g;
                                        Get.back();
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  const _Label(text: "date_of_birth"),
                  GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          final isDarkLocal =
                              Theme.of(context).brightness == Brightness.dark;
                          return Theme(
                            data: Theme.of(context).copyWith(
                              datePickerTheme: DatePickerThemeData(
                                headerBackgroundColor: isDarkLocal
                                    ? const Color(0xFF2A2438)
                                    : Colors.white,
                                headerForegroundColor: isDarkLocal
                                    ? AppColors.primaryColorDark
                                    : AppColors.primaryColorLight,
                                headerHelpStyle: TextStyle(
                                  // "SELECT DATE" text
                                  color: isDarkLocal
                                      ? AppColors.primaryColorDark.withOpacity(
                                          0.8,
                                        )
                                      : AppColors.primaryColorLight.withOpacity(
                                          0.8,
                                        ),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  backgroundColor: isDarkLocal
                                      ? AppColors.primaryColorDark.withOpacity(
                                          0.15,
                                        )
                                      : AppColors.primaryColorLight.withOpacity(
                                          0.1,
                                        ),
                                  foregroundColor: isDarkLocal
                                      ? AppColors.primaryColorDark
                                      : AppColors.primaryColorLight,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 360,
                                  maxHeight: 520,
                                ),
                                child: Transform.scale(
                                  scale: 0.9,
                                  child: child!,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      if (picked != null) {
                        controller.dobController.text =
                            "${picked.day}/${picked.month}/${picked.year}";
                      }
                    },
                    child: AbsorbPointer(
                      child: _TextField(
                        controller: controller.dobController,
                        hint: "DD/MM/YYYY",
                        suffixIcon: Icon(
                          Icons.calendar_month_outlined,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// --- Save Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.saveProfile,
                      child: Text(tr("save_changes")),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      }),
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
        tr(text),
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? suffixIcon;

  const _TextField({
    required this.controller,
    required this.hint,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.primaryColorDark
                : AppColors.primaryColorLight,
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String value;
  final VoidCallback? onTap;
  const _DropdownField({required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark
                ? AppColors.primaryColorDark
                : AppColors.primaryColorLight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
            Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}
