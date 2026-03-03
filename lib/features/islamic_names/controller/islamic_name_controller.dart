import 'package:get/get.dart';
import 'package:maroofkhan8/core/network/api_Service.dart';
import 'package:maroofkhan8/core/network/api_endpoints.dart';
import '../models/islamic_name_model.dart';

class IslamicNameController extends GetxController {
  static IslamicNameController get instance => Get.find();

  var nameList = <IslamicNameModel>[].obs;
  var savedNameList = <IslamicNameModel>[].obs;
  var isLoading = false.obs;
  var isSavedLoading = false.obs;

  var boySearchQuery = "".obs;
  var girlSearchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchNames();
    fetchSavedNames();
  }

  void fetchNames() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.islamicNames);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        nameList.assignAll(
          data.map((json) => IslamicNameModel.fromJson(json)).toList(),
        );
        _syncSaveStatus();
      }
    } catch (e) {
      print("Error fetching names: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchSavedNames() async {
    isSavedLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.savedIslamicNames);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        savedNameList.assignAll(
          data.map((json) {
            // Since these are from the saved names endpoint, they are all saved
            final model = IslamicNameModel.fromJson(json);
            return IslamicNameModel(
              id: model.id, // This is the RELATION ID
              name: model.name,
              arabic: model.arabic,
              meaning: model.meaning,
              gender: model.gender,
              isSaved: true,
            );
          }).toList(),
        );
        _syncSaveStatus();
      }
    } catch (e) {
      print("Error fetching saved names: $e");
      savedNameList.clear();
    } finally {
      isSavedLoading.value = false;
    }
  }

  void _syncSaveStatus() {
    if (nameList.isEmpty) return;
    for (int i = 0; i < nameList.length; i++) {
      final item = nameList[i];
      final isSaved = savedNameList.any(
        (s) => s.name == item.name && s.arabic == item.arabic,
      );
      if (item.isSaved != isSaved) {
        nameList[i] = IslamicNameModel(
          id: item.id,
          name: item.name,
          arabic: item.arabic,
          meaning: item.meaning,
          gender: item.gender,
          isSaved: isSaved,
        );
      }
    }
    nameList.refresh();
  }

  List<IslamicNameModel> get boyNames {
    List<IslamicNameModel> filtered = nameList
        .where((n) => n.gender == "MALE")
        .toList();
    if (boySearchQuery.value.isNotEmpty) {
      String query = boySearchQuery.value.toLowerCase();
      filtered = filtered
          .where(
            (n) =>
                n.name.toLowerCase().contains(query) ||
                n.meaning.toLowerCase().contains(query),
          )
          .toList();
    }
    return filtered;
  }

  List<IslamicNameModel> get girlNames {
    List<IslamicNameModel> filtered = nameList
        .where((n) => n.gender == "FEMALE")
        .toList();
    if (girlSearchQuery.value.isNotEmpty) {
      String query = girlSearchQuery.value.toLowerCase();
      filtered = filtered
          .where(
            (n) =>
                n.name.toLowerCase().contains(query) ||
                n.meaning.toLowerCase().contains(query),
          )
          .toList();
    }
    return filtered;
  }

  Future<void> toggleSaveStatus(IslamicNameModel name) async {
    final index = nameList.indexWhere(
      (n) => n.name == name.name && n.arabic == name.arabic,
    );

    // Determine if we are unsaving or saving
    // If name comes from savedNameList, it's definitely being unsaved.
    // If it comes from nameList, check its current isSaved status.
    final bool isUnsaving = name.isSaved;

    try {
      if (isUnsaving) {
        // Find relation ID and index from savedNameList
        final savedIdx = savedNameList.indexWhere(
          (s) => s.name == name.name && s.arabic == name.arabic,
        );
        final String deleteId = (savedIdx != -1)
            ? savedNameList[savedIdx].id
            : name.id;

        // Optimistic UI update in saved list
        if (savedIdx != -1) {
          savedNameList.removeAt(savedIdx);
          savedNameList.refresh();
        }

        // Optimistic UI update in main list if found
        if (index != -1) {
          final item = nameList[index];
          nameList[index] = IslamicNameModel(
            id: item.id,
            name: item.name,
            arabic: item.arabic,
            meaning: item.meaning,
            gender: item.gender,
            isSaved: false,
          );
          nameList.refresh();
        }

        await ApiService.delete(ApiEndpoints.deleteSavedIslamicName(deleteId));
      } else {
        // Saving - use name.id as the target ID

        // Optimistic UI update in main list
        if (index != -1) {
          final item = nameList[index];
          nameList[index] = IslamicNameModel(
            id: item.id,
            name: item.name,
            arabic: item.arabic,
            meaning: item.meaning,
            gender: item.gender,
            isSaved: true,
          );
          nameList.refresh();
        }

        await ApiService.post(
          ApiEndpoints.toggleIslamicNameSave(name.id),
          body: {},
        );
      }
      fetchSavedNames(); // Refresh saved list to get new relation IDs
    } catch (e) {
      // On error, sync back
      fetchNames();
      fetchSavedNames();
      print("Error toggling save status: $e");
    }
  }
}
