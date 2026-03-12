import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/offline_storage/shared_pref.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../bottom_nav_bar.dart';
import '../view/signup_otp_verification_page.dart';

class SignInSignUpController extends GetxController {
  static SignInSignUpController get instance => Get.find();

  final formKey = GlobalKey<FormState>();
  var showErrors = false.obs;

  final isLogin = true.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final fullPhoneNumber = ''.obs;
  final phoneError = RxnString();

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  // --- FIX STARTS HERE ---

  void showLogin() {
    if (isLogin.value) return; // Do nothing if already on Login
    isLogin.value = true;
    _resetFormState();
  }

  void showRegister() {
    if (!isLogin.value) return; // Do nothing if already on Register
    isLogin.value = false;
    _resetFormState();
  }

  /// Clears validation errors and sensitive fields when switching tabs
  void _resetFormState() {
    showErrors.value = false;

    // 1. Reset the UI validation (removes red error text)
    formKey.currentState?.reset();

    // 2. Clear password fields for security/UX when switching
    passwordController.clear();
    confirmPasswordController.clear();
    fullPhoneNumber.value = '';
    phoneError.value = null;

    // Optional: If you want to clear EVERYTHING (including email/name) when switching:
    // emailController.clear();
    // nameController.clear();
    // phoneController.clear();

    // Reset visibility icons to hidden
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
  }

  // --- FIX ENDS HERE ---

  void submit() async {
    showErrors.value = true;
    if (formKey.currentState!.validate()) {
      if (isLogin.value) {
        await _loginUser();
      } else {
        await _registerUser();
      }
    }
  }

  // ─── Google Sign-In ───────────────────────────────────────────────────────
  // serverClientId = your Web Application OAuth 2.0 Client ID.
  // This is REQUIRED on Android to generate the idToken the backend needs.
  static const _webClientId = '47761947894-hondhs24je2tkjsi3rhus924nrp2c7h1';

  Future<void> signInWithGoogle() async {
    try {
      EasyLoading.show(status: 'Connecting Google...');

      // 1. Open Google account picker
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: _webClientId,
        scopes: ['email', 'profile'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // User cancelled the picker
      if (googleUser == null) {
        EasyLoading.dismiss();
        return;
      }

      // 2. Get auth tokens from the chosen account
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      debugPrint("Google Auth Print: $googleAuth");

      debugPrint("ID Token: ${googleAuth.idToken}");
      debugPrint("Access Token: ${googleAuth.accessToken}");

      if (idToken == null) {
        EasyLoading.dismiss();
        SnackbarUtils.showSnackbar(
          'Google Sign-In Failed',
          'Could not retrieve ID Token. Check your OAuth setup.',
        );
        return;
      }

      // 3. Send { idToken } to the backend  →  POST /auth/google
      final response = await ApiService.post(
        ApiEndpoints.googleAuth,
        body: {'idToken': idToken},
      );

      EasyLoading.dismiss();

      // 4. Save accessToken & navigate home
      if (response['data'] != null && response['data']['accessToken'] != null) {
        await SharedPreferencesHelper.saveToken(
          response['data']['accessToken'],
        );
      }

      SnackbarUtils.showSnackbar('Login successful', 'Welcome!');
      Get.offAll(() => const CustomBottomNavBar());
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Google Sign-In Error: $e');
      SnackbarUtils.showSnackbar(
        'Error',
        'Google Sign-In failed. Please try again.',
      );
    }
  }
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _loginUser() async {
    EasyLoading.show(status: 'Logging in...');
    try {
      final body = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      };

      final response = await ApiService.post(ApiEndpoints.login, body: body);
      debugPrint("****************************************");
      debugPrint("DEBUG: Login Response: $response");
      debugPrint("****************************************");

      EasyLoading.dismiss();

      SnackbarUtils.showSnackbar('Login successful', 'Welcome!');

      if (response['data'] != null && response['data']['accessToken'] != null) {
        await SharedPreferencesHelper.saveToken(
          response['data']['accessToken'],
        );
      }

      Get.offAll(() => const CustomBottomNavBar());
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<void> _registerUser() async {
    EasyLoading.show(status: 'Registering...');
    phoneError.value = null;
    try {
      final body = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": fullPhoneNumber.value.isNotEmpty
            ? fullPhoneNumber.value
            : phoneController.text.trim(),
        "password": passwordController.text,
      };

      final response = await ApiService.post(ApiEndpoints.register, body: body);

      EasyLoading.dismiss();

      SnackbarUtils.showSnackbar(
        'Success',
        response['message'] ?? 'OTP Sent to your Email',
      );

      Get.to(
        () => SignupOtpVerificationPage(),
        arguments: {'email': emailController.text.trim()},
      );
    } catch (e) {
      EasyLoading.dismiss();
      final msg = e.toString();
      if (msg.toLowerCase().contains('phone must be a valid phone number')) {
        phoneError.value = 'Enter a valid phone number';
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
