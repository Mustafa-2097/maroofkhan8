import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/constant/app_colors.dart';
import '../controller/otp_controller.dart';

class OtpVerificationPage extends StatelessWidget {
  OtpVerificationPage({super.key});
  final controller = Get.put(VerificationCodeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              /// Title
              Center(
                child: Text(
                  'OTP VERIFICATION',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// Subtitle
              Text(
                'Enter the verification code we just sent on your email address.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              /// OTP Code Input
              OtpBox(
                onChanged: (value) => controller.otp.value = value,
              ),

              const SizedBox(height: 32),

              /// Submit button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Get.to(()=> OtpVerificationPage()),
                  child: Text(
                    'Verify',
                  ),
                ),
              ),

              const SizedBox(height: 24),

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
    return PinCodeTextField(
      appContext: context,
      length: 6,
      keyboardType: TextInputType.number,
      //cursorColor: Colors.,
      //textStyle: AppTextStyles.h224,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12.r),
        fieldHeight: 50.h,
        fieldWidth: 50.w,
        inactiveColor: Colors.white70,
        activeColor: Colors.white,
        selectedColor: Colors.white,
      ),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onChanged: onChanged,
    );
  }
}
