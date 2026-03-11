import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constant/app_colors.dart';
import '../controller/otp_controller.dart';

class OtpVerificationPage extends StatelessWidget {
  OtpVerificationPage({super.key});
  final controller = Get.put(VerificationCodeController());

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: sh * 0.03),

              /// Title
              Center(
                child: Text(
                  tr('otp_title'),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(height: sh * 0.01),

              /// Subtitle
              Text(
                tr('otp_subtitle'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: sh * 0.04),

              /// OTP Code Input
              OtpBox(onChanged: (value) => controller.otp.value = value),

              SizedBox(height: sh * 0.04),

              /// Submit button
              SizedBox(
                width: double.infinity,
                height: sh * 0.06,
                child: ElevatedButton(
                  // CHANGE THIS: Call the controller method
                  onPressed: () => controller.verifyOtp(),
                  child: Text(tr('otp_verify')),
                ),
              ),

              SizedBox(height: sh * 0.03),

              /// Resend code
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr('otp_no_code'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: controller.canResend.value
                            ? () => controller.resendOtp()
                            : null,
                        child: Text(
                          controller.canResend.value
                              ? tr('otp_resend')
                              : tr('otp_resend_in').replaceAll('{}', '${controller.secondsRemaining.value}'),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: controller.canResend.value
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).disabledColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpBox extends StatelessWidget {
  final Function(String)? onChanged;
  const OtpBox({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return PinCodeTextField(
      appContext: context,
      length: 6,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: sh * 0.06,
        fieldWidth: sw * 0.12,
        inactiveColor: isDark
            ? AppColors.primaryColorDark
            : AppColors.primaryColorLight,
        activeColor: isDark
            ? AppColors.primaryColorDark
            : AppColors.primaryColorLight,
        selectedColor: isDark
            ? AppColors.primaryColorDark
            : AppColors.primaryColorLight,
      ),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onChanged: onChanged,
    );
  }
}
