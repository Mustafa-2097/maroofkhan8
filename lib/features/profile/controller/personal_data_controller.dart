import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/network/api_endpoints.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../model/user_model.dart';

class PersonalDataController extends GetxController {
  // Use Get.isDarkMode instead of Theme.of(context)
  bool get isDark => Get.isDarkMode;
  final formKey = GlobalKey<FormState>();

  // Helper to check if data has changed
  bool _hasChanges() {
    final currentData = userData.value?.profile;
    if (currentData == null) return true; // Treat as changes if no data exists

    bool nameChanged = nameController.text != (currentData.name ?? "");
    bool phoneChanged = phoneController.text != (currentData.phone ?? "");
    bool imageChanged = profileImage.value != null;

    return nameChanged || phoneChanged || imageChanged;
  }

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();

  // Reactive variables
  var selectedCountry = "Select Your Country".obs;
  var selectedGender = "Select Your Gender".obs;
  // var selectedCountry = "🇧🇩 Bangladesh".obs;
  // var selectedGender = "Male".obs;
  var isLoading = false.obs;
  var userData = Rxn<UserData>();
  var profileImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final token = await SharedPreferencesHelper.getToken();

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': '$token',
        if (token != null) 'token': '$token',
        if (token != null) 'access_token': '$token',
      };

      final url = Uri.parse(ApiEndpoints.profile);
      final response = await http.get(url, headers: headers);

      print("DEBUG: Profile Status Code: ${response.statusCode}");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        final userRes = UserResponse.fromJson(decoded);
        if (userRes.data != null) {
          userData.value = userRes.data;

          // Populate controllers
          nameController.text = userRes.data!.profile?.name ?? "";
          phoneController.text = userRes.data!.profile?.phone ?? "";
          emailController.text = userRes.data!.email ?? "";
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile() async {
    if (formKey.currentState?.validate() ?? false) {
      if (!_hasChanges()) {
        Get.snackbar(
          "No Changes",
          "Data already exists",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      try {
        isLoading.value = true;
        final token = await SharedPreferencesHelper.getToken();

        var request = http.MultipartRequest(
          'PATCH',
          Uri.parse(ApiEndpoints.profile),
        );

        // Headers
        if (token != null) {
          request.headers['Authorization'] = '$token';
          request.headers['token'] = '$token';
          request.headers['access_token'] = '$token';
        }

        // Fields
        request.fields['name'] = nameController.text;
        request.fields['phone'] = phoneController.text;

        // Image
        if (profileImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'avatar',
              profileImage.value!.path,
            ),
          );
        }

        print("DEBUG: Profile Update Request to: ${ApiEndpoints.profile}");
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        print("DEBUG: Profile Update Status Code: ${response.statusCode}");
        print("DEBUG: Profile Update Response Body: ${response.body}");

        if (response.statusCode >= 200 && response.statusCode < 300) {
          Get.snackbar(
            "Success",
            "User data updated",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          profileImage.value = null; // Clear picked image
          fetchProfile(); // Refresh the data to be sure
        } else {
          final error = jsonDecode(response.body);
          Get.snackbar(
            "Error",
            error['message'] ?? "Failed to update profile",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print("Error updating profile: $e");
        Get.snackbar(
          "Error",
          "An unexpected error occurred",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    // Always dispose of controllers to prevent memory leaks
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
