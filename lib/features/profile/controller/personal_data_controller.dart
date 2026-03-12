import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/offline_storage/shared_pref.dart';
import '../../../core/network/api_Service.dart';
import '../model/user_model.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'profile_controller.dart';

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

    String apiCountry = currentData.country ?? "Select Your Country";
    bool countryChanged = selectedCountry.value != apiCountry;

    String currentApiGender = (currentData.gender ?? "").toLowerCase();
    bool genderChanged = selectedGender.value.toLowerCase() != currentApiGender;

    String apiDob = _formatDobToUI(currentData.dateOfBirth);
    bool dobChanged = dobController.text != apiDob;

    return nameChanged ||
        phoneChanged ||
        imageChanged ||
        countryChanged ||
        genderChanged ||
        dobChanged;
  }

  // Mapper helpers
  String _mapGenderToAPI(String uiGender) {
    String lower = uiGender.toLowerCase();
    if (lower == "male") return "MALE";
    if (lower == "female") return "FEMALE";
    return "";
  }

  String _mapGenderToUI(String? apiGender) {
    if (apiGender == "MALE") return "male";
    if (apiGender == "FEMALE") return "female";
    return "choose_gender";
  }

  String _formatDobToAPI(String uiDob) {
    if (uiDob.isEmpty) return "";
    try {
      final parts = uiDob.split('/');
      if (parts.length == 3) {
        // DD/MM/YYYY -> ISO-8601 DateTime
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime.utc(year, month, day).toIso8601String();
      }
    } catch (e) {
      print("Error formatting DOB for API: $e");
    }
    return uiDob;
  }

  String _formatDobToUI(String? apiDob) {
    if (apiDob == null || apiDob.isEmpty) return "";
    try {
      // YYYY-MM-DD -> DD/MM/YYYY
      final date = DateTime.parse(apiDob);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      print("Error formatting DOB for UI: $e");
    }
    return apiDob;
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
          selectedCountry.value =
              userRes.data!.profile?.country ?? "Select Your Country";
          selectedGender.value = _mapGenderToUI(userRes.data!.profile?.gender);
          dobController.text = _formatDobToUI(
            userRes.data!.profile?.dateOfBirth,
          );
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
        SnackbarUtils.showSnackbar(tr("no_changes"), tr("data_already_exists"));
        return;
      }

      try {
        isLoading.value = true;
        final currentData = userData.value?.profile;

        // Collect changed fields
        Map<String, dynamic> changedFields = {};

        if (nameController.text != (currentData?.name ?? "")) {
          changedFields['name'] = nameController.text;
        }
        if (phoneController.text != (currentData?.phone ?? "")) {
          changedFields['phone'] = phoneController.text;
        }
        String apiCountry = currentData?.country ?? "Select Your Country";
        if (selectedCountry.value != apiCountry &&
            selectedCountry.value != "Select Your Country") {
          // Strip emoji if present (e.g., "🇧🇩 Bangladesh" -> "Bangladesh")
          String countryValue = selectedCountry.value;
          if (countryValue.contains(" ") && countryValue.length > 2) {
            // Check if first part looks like an emoji (rough check)
            final parts = countryValue.split(" ");
            if (parts.length > 1 && parts[0].runes.length <= 4) { // Emojis are often 2-4 runes
              countryValue = parts.sublist(1).join(" ");
            }
          }
          changedFields['country'] = countryValue;
        }

        String uiCurrentGender = _mapGenderToUI(currentData?.gender).toLowerCase();
        if (selectedGender.value.toLowerCase() != uiCurrentGender &&
            selectedGender.value != "choose_gender") {
          changedFields['gender'] = _mapGenderToAPI(selectedGender.value);
        }

        String uiCurrentDob = _formatDobToUI(currentData?.dateOfBirth);
        if (dobController.text != uiCurrentDob && dobController.text.isNotEmpty) {
          changedFields['dateOfBirth'] = _formatDobToAPI(dobController.text);
        }

        if (profileImage.value != null) {
          // Use Multi-part if image is present
          final token = await SharedPreferencesHelper.getToken();
          var request = http.MultipartRequest(
            'PATCH',
            Uri.parse(ApiEndpoints.profile),
          );

          if (token != null) {
            request.headers['Authorization'] = '$token';
            request.headers['token'] = '$token';
          }

          // Add only changed fields
          changedFields.forEach((key, value) {
            request.fields[key] = value.toString();
          });

          // Add image
          request.files.add(
            await http.MultipartFile.fromPath(
              'avatar',
              profileImage.value!.path,
            ),
          );

          final streamedResponse = await request.send();
          final responseBody = await streamedResponse.stream.bytesToString();
          final decodedResponse = jsonDecode(responseBody);

          if (streamedResponse.statusCode >= 200 &&
              streamedResponse.statusCode < 300) {
            _onSaveSuccess();
          } else {
            SnackbarUtils.showSnackbar(
              tr("error"),
              _getErrorMessage(decodedResponse),
              isError: true,
            );
          }
        } else {
          // Use regular PATCH for JSON
          await ApiService.patch(
            ApiEndpoints.profile,
            body: changedFields,
          );
          _onSaveSuccess();
        }
      } catch (e) {
        print("Error updating profile: $e");
        // Error handled by ApiService for patch
        if (profileImage.value != null) {
          SnackbarUtils.showSnackbar(tr("error"), e.toString(), isError: true);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  void _onSaveSuccess() {
    SnackbarUtils.showSnackbar(tr("success"), tr("user_data_updated"));
    profileImage.value = null;
    fetchProfile();
    if (Get.isRegistered<ProfileController>()) {
      ProfileController.instance.fetchUserData();
    }
  }

  String _getErrorMessage(dynamic decodedResponse) {
    if (decodedResponse['message'] != null) {
      String msg = decodedResponse['message'];
      if (decodedResponse['errorMessages'] != null &&
          decodedResponse['errorMessages'] is List &&
          (decodedResponse['errorMessages'] as List).isNotEmpty) {
        final firstError = (decodedResponse['errorMessages'] as List).first;
        if (firstError is Map && firstError['message'] != null) {
          msg += ": ${firstError['message']}";
        }
      }
      return msg;
    }
    return tr("failed_to_update_profile");
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