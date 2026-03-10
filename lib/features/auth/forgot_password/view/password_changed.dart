import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../signin_signup/view/signin_signup_page.dart';

class PasswordChange extends StatelessWidget {
  const PasswordChange({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/success.png",
                width: sw * 0.25,
                fit: BoxFit.cover,
              ),
              SizedBox(height: sh * 0.03),
              Text(
                'Password Changed',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: sh * 0.015),

              /// Subtitle
              Text(
                'Your password has been changed successfully.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: sh * 0.04),

              SizedBox(
                width: double.infinity,
                height: sh * 0.06,
                child: ElevatedButton(
                  onPressed: () => Get.offAll((() => SignInSignUpPage())),
                  child: const Text('Back to Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
