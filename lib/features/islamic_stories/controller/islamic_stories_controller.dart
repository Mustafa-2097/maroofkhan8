import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/islamic_story.dart';

class IslamicStoriesController extends GetxController {
  static IslamicStoriesController get instance => Get.find();

  var isLoading = false.obs;
  var stories = <IslamicStory>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStories();
  }

  Future<void> fetchStories() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.stories);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        stories.value = data
            .map((json) => IslamicStory.fromJson(json))
            .toList();
      }
    } catch (e) {
      // Error is handled in ApiService
    } finally {
      isLoading.value = false;
    }
  }
}
