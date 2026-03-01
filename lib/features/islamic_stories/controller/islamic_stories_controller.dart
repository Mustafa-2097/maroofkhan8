import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/islamic_story.dart';

class IslamicStoriesController extends GetxController {
  static IslamicStoriesController get instance => Get.find();

  var isLoading = false.obs;
  var stories = <IslamicStory>[].obs;
  var searchQuery = ''.obs;

  var isDetailLoading = false.obs;
  var storyDetail = Rxn<IslamicStory>();

  List<IslamicStory> get filteredStories {
    if (searchQuery.value.isEmpty) return stories;
    return stories
        .where(
          (s) =>
              s.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

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

  Future<void> fetchStoryDetails(String id) async {
    isDetailLoading.value = true;
    storyDetail.value = null;
    try {
      final response = await ApiService.get(ApiEndpoints.storyDetails(id));
      if (response['success'] == true) {
        storyDetail.value = IslamicStory.fromJson(response['data']);
      }
    } catch (e) {
      // Error handled in ApiService
    } finally {
      isDetailLoading.value = false;
    }
  }
}
