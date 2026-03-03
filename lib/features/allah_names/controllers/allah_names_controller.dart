import 'package:get/get.dart';
import '../../../../core/network/api_Service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/allah_name_model.dart';
import 'package:flutter/foundation.dart';

class AllahNamesController extends GetxController {
  static AllahNamesController get instance => Get.find();

  var namesList = <AllahName>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;
  var selectedFilterIndex = 0.obs; // 0: All, 1: Meaning, 2: Audio
  var currentAudioIndex = 0.obs;

  List<AllahName> get filteredNamesList {
    List<AllahName> list = namesList;

    // Filter by tab
    if (selectedFilterIndex.value == 1) {
      list = list.where((e) => e.meaning.isNotEmpty).toList();
    } else if (selectedFilterIndex.value == 2) {
      // Assuming 'With Audio' means it has an audio file or as defined by data
      // For now we'll just return the list as is if no specific audio check is needed
      // or filter if there's an audio property.
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list
          .where(
            (e) =>
                e.arabic.toLowerCase().contains(query) ||
                e.pronunciation.toLowerCase().contains(query) ||
                e.meaning.toLowerCase().contains(query),
          )
          .toList();
    }

    return list;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateFilterIndex(int index) {
    selectedFilterIndex.value = index;
    // Reset index when switching to audio mode to show the first one
    if (index == 2) {
      currentAudioIndex.value = 0;
    }
  }

  void nextAudio() {
    final list = filteredNamesList;
    if (list.isEmpty) return;
    if (currentAudioIndex.value < list.length - 1) {
      currentAudioIndex.value++;
    } else {
      currentAudioIndex.value = 0; // Loop back
    }
  }

  void previousAudio() {
    final list = filteredNamesList;
    if (list.isEmpty) return;
    if (currentAudioIndex.value > 0) {
      currentAudioIndex.value--;
    } else {
      currentAudioIndex.value = list.length - 1; // Loop to end
    }
  }

  var savedNamesList = <AllahName>[].obs;
  var isSavedLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllahNames();
    fetchSavedNames();
  }

  Future<void> fetchAllahNames() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.allahNames);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        namesList.value = data.map((json) => AllahName.fromJson(json)).toList();
        _syncSavedNames();
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching Allah names: $e");
      namesList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSavedNames() async {
    isSavedLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.savedAllahNames);
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        savedNamesList.value = data.map((json) {
          final name = AllahName.fromJson(json);
          return AllahName(
            id: name.id,
            arabic: name.arabic,
            pronunciation: name.pronunciation,
            meaning: name.meaning,
            isSaved: true,
          );
        }).toList();
        _syncSavedNames();
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching saved Allah names: $e");
    } finally {
      isSavedLoading.value = false;
    }
  }

  void _syncSavedNames() {
    if (namesList.isEmpty) return;

    for (int i = 0; i < namesList.length; i++) {
      final item = namesList[i];

      // Match firmly by ID, or if ID differs (like relation ID returned from backend),
      // match safely by both Arabic and Pronunciation combined.
      final isSaved = savedNamesList.any(
        (saved) =>
            saved.id == item.id ||
            (saved.arabic == item.arabic &&
                saved.pronunciation == item.pronunciation),
      );

      if (item.isSaved != isSaved) {
        namesList[i] = AllahName(
          id: item.id,
          arabic: item.arabic,
          pronunciation: item.pronunciation,
          meaning: item.meaning,
          isSaved: isSaved,
        );
      }
    }
    namesList.refresh();
  }

  Future<void> toggleSaveName(AllahName item) async {
    try {
      // Find in main list to get the actual Name ID (for POST case)
      final mainIdx = namesList.indexWhere(
        (e) =>
            e.id == item.id ||
            (e.arabic == item.arabic && e.pronunciation == item.pronunciation),
      );

      // Find in saved list to get the relation ID (for DELETE case)
      final savedIdx = savedNamesList.indexWhere(
        (e) =>
            e.id == item.id ||
            (e.arabic == item.arabic && e.pronunciation == item.pronunciation),
      );

      final isCurrentlySaved = savedIdx != -1;

      Map<String, dynamic> response;
      if (isCurrentlySaved) {
        // Unsave (DELETE) using relation ID from savedNamesList
        final relationId = savedNamesList[savedIdx].id;
        response = await ApiService.delete(
          ApiEndpoints.deleteSavedAllahName(relationId),
        );
      } else {
        // Save (POST) using name ID from namesList
        if (mainIdx == -1) return;
        final nameId = namesList[mainIdx].id;
        response = await ApiService.post(
          ApiEndpoints.toggleAllahNameSave(nameId),
          body: {},
        );
      }

      if (response['success'] == true) {
        if (mainIdx != -1) {
          final realItem = namesList[mainIdx];
          namesList[mainIdx] = AllahName(
            id: realItem.id,
            arabic: realItem.arabic,
            pronunciation: realItem.pronunciation,
            meaning: realItem.meaning,
            isSaved: !isCurrentlySaved,
          );
          namesList.refresh();
        }

        // Fetch saved names to update list and synchronize ui
        fetchSavedNames();
      } else {
        if (kDebugMode) print("Failed to toggle save: ${response['message']}");
      }
    } catch (e) {
      if (kDebugMode) print("Error toggling save: $e");
    }
  }
}
