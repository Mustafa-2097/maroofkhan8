import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constant/app_colors.dart';
import '../controller/signup_otp_controller.dart';

class SignupOtpVerificationPage extends StatelessWidget {
  SignupOtpVerificationPage({super.key});
  final controller = Get.put(SignupOtpController());

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

              /// Back Button
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back),
              ),

              /// Title
              Center(
                child: Text(
                  'OTP Verification',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(height: sh * 0.01),

              /// Subtitle
              Text(
                'Enter the verification code we just sent on your email address.',
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
                  onPressed: () => controller.verifyOtp(),
                  child: const Text('Verify'),
                ),
              ),

              SizedBox(height: sh * 0.03),

              /// Resend OTP
              Center(
                child: Obx(
                  () => TextButton(
                    onPressed: controller.canResend.value
                        ? controller.resendOtp
                        : null,
                    child: Text(
                      controller.canResend.value
                          ? 'Resend OTP'
                          : 'Resend OTP in ${controller.secondsRemaining.value}s',
                      style: TextStyle(
                        color: controller.canResend.value
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).disabledColor,
                      ),
                    ),
                  ),
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
