import 'package:get/get.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/dua_model.dart';

class DuaController extends GetxController {
  static DuaController get instance => Get.find();

  var duaList = <DuaData>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;
  var selectedCategoryIndex = 0.obs;

  List<String> categories = ["All Duas", "Special Days", "Before & After"];
  List<String> categoryMapping = ["ALL", "SPECIAL_DAYS", "BEFORE_N_AFTER"];

  @override
  void onInit() {
    super.onInit();
    fetchDuas();
  }

  List<DuaData> get filteredDuaList {
    List<DuaData> list = duaList;

    // Category Filter
    if (selectedCategoryIndex.value != 0) {
      String targetType = categoryMapping[selectedCategoryIndex.value];
      list = list.where((d) => d.type == targetType).toList();
    }

    // Search Filter
    if (searchQuery.isNotEmpty) {
      String query = searchQuery.value.toLowerCase();
      list = list.where((d) {
        return (d.title?.toLowerCase().contains(query) ?? false) ||
            (d.meaning?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return list;
  }

  void updateSearch(String query) => searchQuery.value = query;

  void updateCategory(int index) => selectedCategoryIndex.value = index;

  Future<void> fetchDuas() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.duas);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        duaList.value = data.map((json) => DuaData.fromJson(json)).toList();
      }
    } catch (e) {
      duaList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String getCategoryKey(int index) {
    if (index == 0) return "all_duas";
    if (index == 1) return "special_days";
    if (index == 2) return "before_after";
    return "all_duas";
  }
}
