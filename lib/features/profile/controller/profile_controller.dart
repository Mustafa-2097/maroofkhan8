import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  var isLoading = false.obs;
  var name = "Checking...".obs;
  var email = "Checking...".obs;
  var avatar = "".obs;
  var isSubscribed = false.obs;
  var currentPlan = RxnString();

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
        isSubscribed.value = data['subscribed'] ?? false;

        final profile = data['profile'];
        if (profile != null) {
          if (profile['name'] != null &&
              profile['name'].toString().isNotEmpty) {
            name.value = profile['name'];
          } else {
            name.value = "User";
          }
          avatar.value = profile['avatar'] ?? "";
        }

        // Check if there's any subscription details in the response
        if (data['subscription'] != null &&
            data['subscription']['plan'] != null) {
          currentPlan.value = data['subscription']['plan']['title'];
        }

        // Fallback for currentPlan if subscribed but no title found
        if (isSubscribed.value &&
            (currentPlan.value == null || currentPlan.value!.isEmpty)) {
          currentPlan.value = "premium_plan";
        }

        // Normalize if it's already "Premium" from API to use our key
        if (currentPlan.value?.toLowerCase() == "premium") {
          currentPlan.value = "premium_plan";
        }
        if (currentPlan.value?.toLowerCase() == "basic") {
          currentPlan.value = "basic_plan";
        }
      }
    } catch (e) {
      // Error is handled in ApiService
      name.value = "Error";
      email.value = "Error";
    } finally {
      isLoading.value = false;
    }
  }
}
