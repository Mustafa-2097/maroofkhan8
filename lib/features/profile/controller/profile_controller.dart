import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../quran/controller/quran_controller.dart';
import '../../hadis/controller/hadith_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/offline_storage/shared_pref.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  var isLoading = false.obs;
  var name = "Checking...".obs;
  var email = "Checking...".obs;
  var avatar = "".obs;
  var isSubscribed = false.obs;
  var currentPlan = RxnString();
  var currentPlanType = RxnString();
  var subscriptionEndDate = Rxn<DateTime>();
  var subscriptionStartDate = Rxn<DateTime>();
  var gender = "".obs;

  bool get canDownloadFiles {
    final title = currentPlan.value?.toLowerCase() ?? "";
    return title.contains('premium') || title.contains('basic');
  }

  void handleDownloadAction(VoidCallback onDownload) {
    if (canDownloadFiles) {
      onDownload();
    } else {
      Get.snackbar(
        tr("subscription_required_title"),
        tr("subscription_required_download"),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.getMe);
      if (response['success'] == true) {
        final data = response['data'];
        email.value = data['email'] ?? "No Email";
        // isSubscribed.value is evaluated later

        final profile = data['profile'];
        if (profile != null) {
          if (profile['name'] != null &&
              profile['name'].toString().isNotEmpty) {
            name.value = profile['name'];
          } else {
            name.value = "User";
          }
          avatar.value = profile['avatar'] ?? "";
          gender.value = profile['gender'] ?? "";
        }

        isSubscribed.value =
            data['subscribed'] ?? (data['subscription'] != null);

        // Check if there's any subscription details in the response
        if (data['subscription'] != null) {
          if (data['subscription']['title'] != null) {
            currentPlan.value = data['subscription']['title'];
          } else if (data['subscription']['plan'] != null) {
            currentPlan.value = data['subscription']['plan']['title'];
          }

          if (data['subscription']['type'] != null) {
            currentPlanType.value = data['subscription']['type'];
          } else if (data['subscription']['plan'] != null &&
              data['subscription']['plan']['type'] != null) {
            currentPlanType.value = data['subscription']['plan']['type'];
          }

          if (data['subscription']['endDate'] != null) {
            subscriptionEndDate.value = DateTime.tryParse(
              data['subscription']['endDate'],
            );
          }
          if (data['subscription']['startDate'] != null) {
            subscriptionStartDate.value = DateTime.tryParse(
              data['subscription']['startDate'],
            );
          }
        }
        
        _handleOfflineDataSync();
      }
    } catch (e) {
      // Error is handled in ApiService
      name.value = "Error";
      email.value = "Error";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLanguage(String languageCode) async {
    isLoading.value = true;
    try {
      String language;
      switch (languageCode) {
        case 'ar':
          language = 'ARABIC';
          break;
        case 'ur':
          language = 'URDU';
          break;
        case 'hi':
          language = 'HINDI';
          break;
        default:
          language = 'ENGLISH';
      }

      await ApiService.patch(
        ApiEndpoints.profile,
        body: {'language': language},
      );
    } catch (e) {
      // Error handled by ApiService
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateGender(String genderValue) async {
    isLoading.value = true;
    try {
      await ApiService.patch(
        ApiEndpoints.profile,
        body: {'gender': genderValue.toUpperCase()},
      );
      gender.value = genderValue.toUpperCase();
    } catch (e) {
      // Error handled by ApiService
    } finally {
      isLoading.value = false;
    }
  }

  void _handleOfflineDataSync() {
    if (canDownloadFiles) {
      if (Get.isRegistered<QuranController>()) {
        Get.find<QuranController>().loadOfflineData();
      }
      if (Get.isRegistered<HadithController>()) {
        Get.find<HadithController>().loadOfflineData();
      }
    } else {
      if (Get.isRegistered<QuranController>()) {
        Get.find<QuranController>().clearOfflineData();
      }
      if (Get.isRegistered<HadithController>()) {
        Get.find<HadithController>().clearOfflineData();
      }
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint('Error signing out from Google: $e');
    }
    
    // Clear offline trackings on logout
    if (Get.isRegistered<QuranController>()) {
      Get.find<QuranController>().clearOfflineData();
    }
    if (Get.isRegistered<HadithController>()) {
      Get.find<HadithController>().clearOfflineData();
    }
    
    await SharedPreferencesHelper.clearToken();
  }
}


