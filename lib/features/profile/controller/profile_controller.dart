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
