import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../auth/forgot_password/view/password_changed.dart';

class ChangePasswordController extends GetxController {
  static ChangePasswordController get instance => Get.find();

  // Form Key for validation
  final resetPasswordFormKey = GlobalKey<FormState>();

  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  void toggleOldPasswordVisibility() =>
      isOldPasswordVisible.value = !isOldPasswordVisible.value;
  void toggleNewPasswordVisibility() =>
      isNewPasswordVisible.value = !isNewPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> changePassword() async {
    // This triggers the "validator" functions in the TextFormFields
    if (!resetPasswordFormKey.currentState!.validate()) {
      return;
    }

    EasyLoading.show(status: 'Changing Password...');

    try {
      final body = {
        "oldPassword": oldPasswordController.text,
        "newPassword": passwordController.text,
      };

      // Check if token exists before calling
      final token = await SharedPreferencesHelper.getToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        SnackbarUtils.showSnackbar(
          'Error',
          'Authentication token is missing. Please log in again.',
          isError: true,
        );
        return;
      }

      final response = await ApiService.post(
        ApiEndpoints.changePassword,
        body: body,
      );

      EasyLoading.dismiss();

      SnackbarUtils.showSnackbar(
        'Success',
        response['message'] ?? 'Password Changed successfully',
      );

      // Clear fields after success
      oldPasswordController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Navigate to success screen
      Get.to(() => const PasswordChange());
    } catch (e) {
      EasyLoading.dismiss();
      // Error is already handled/shown in ApiService.post
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
