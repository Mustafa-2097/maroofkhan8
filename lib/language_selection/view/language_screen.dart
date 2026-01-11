import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/language_controller.dart';

class LanguageScreen extends GetView<LanguageController> {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 11.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
        
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Choose the language',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEE7600).withValues(alpha: 0.8),
                  ),
                ),
              ),
        
              const SizedBox(height: 8),
              Text(
                'Select your preferred language below. This helps us serve you better.',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.disabledColor,
                ),
                textAlign: TextAlign.center,
              ),
        
              const SizedBox(height: 32),
        
              Text(
                'Select Language',
                style: theme.textTheme.titleLarge,
              ),
        
              const SizedBox(height: 12),
        
              /// Language List
              Expanded(
                child: Obx( () {
                  final selectedLanguage = controller.selectedLanguage.value;
                  return ListView.separated(
                    itemCount: controller.languages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final language = controller.languages[index];
                      final isSelected = selectedLanguage == language;
                      return InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => controller.selectLanguage(language),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary.withOpacity(0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  language,
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.disabledColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                ),
              ),
            ],
          ),
        ),
      ),

      /// Bottom Button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24, 16, 24,  111.h),
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: controller.onGetStarted,
            child: const Text('Get Started'),
          ),
        ),
      ),
    );
  }
}
