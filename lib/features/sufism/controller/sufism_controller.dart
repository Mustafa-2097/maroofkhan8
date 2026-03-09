import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../Islam_meditation/controller/meditation_controller.dart';
import '../../Islam_meditation/model/meditation_model.dart';
import '../model/guided_meditation_model.dart';
import '../model/islamic_teacher_model.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_service.dart';

class SufismController extends GetxController {
  static SufismController get instance => Get.find();

  final MeditationController meditationController =
  Get.find<MeditationController>();

  var searchQuery = "".obs;
  var teacherSearchQuery = "".obs;
  var guidedMeditationList = <GuidedMeditationData>[].obs;
  var isMeditationLoading = false.obs;
  var isMeditationExpanded = false.obs;
  var guidedMeditationSearchQuery = "".obs;

  var teacherList = <IslamicTeacherData>[].obs;
  var isTeacherLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGuidedMeditations();
    fetchIslamicTeachers();
  }

  Future<void> fetchGuidedMeditations() async {
    try {
      isMeditationLoading.value = true;
      final response = await ApiService.get(ApiEndpoints.guidedMeditation);
      debugPrint("Guided Meditation Response: $response");
      if (response['success'] == true) {
        final guidedRes = GuidedMeditationResponse.fromJson(response);
        guidedMeditationList.assignAll(guidedRes.data ?? []);
        debugPrint(
          "SufismController: Fetched ${guidedMeditationList.length} meditations",
        );
      }
    } catch (e) {
      debugPrint("Error fetching guided meditations: $e");
      Get.snackbar("Notice", "Could not load guided meditations");
    } finally {
      isMeditationLoading.value = false;
    }
  }

  Future<GuidedMeditationData?> fetchGuidedMeditationById(String id) async {
    try {
      final response = await ApiService.get(
        ApiEndpoints.singleGuidedMeditation(id),
      );
      if (response['success'] == true) {
        final guidedRes = SingleGuidedMeditationResponse.fromJson(response);
        return guidedRes.data;
      }
    } catch (e) {
      print("Error fetching single guided meditation: $e");
    }
    return null;
  }

  Future<void> fetchIslamicTeachers() async {
    try {
      isTeacherLoading.value = true;
      final response = await ApiService.get(ApiEndpoints.islamicTeacher);
      debugPrint("Islamic Teacher Response: $response");
      if (response['success'] == true) {
        final teacherRes = IslamicTeacherResponse.fromJson(response);
        teacherList.assignAll(teacherRes.data ?? []);
        debugPrint("SufismController: Fetched ${teacherList.length} teachers");
      }
    } catch (e) {
      debugPrint("Error fetching Islamic teachers: $e");
      Get.snackbar("Notice", "Could not load Islamic teachers");
    } finally {
      isTeacherLoading.value = false;
    }
  }

  Future<IslamicTeacherData?> fetchTeacherById(String id) async {
    try {
      final response = await ApiService.get(
        ApiEndpoints.singleIslamicTeacher(id),
      );
      if (response['success'] == true) {
        final teacherRes = SingleIslamicTeacherResponse.fromJson(response);
        return teacherRes.data;
      }
    } catch (e) {
      print("Error fetching single Islamic teacher: $e");
    }
    return null;
  }

  List<IslamicTeacherData> get filteredTeacherList {
    if (teacherSearchQuery.value.isEmpty) {
      return teacherList;
    }
    return teacherList
        .where(
          (t) => t.title!.toLowerCase().contains(
        teacherSearchQuery.value.toLowerCase(),
      ),
    )
        .toList();
  }

  List<GuidedMeditationData> get filteredGuidedMeditationList {
    if (guidedMeditationSearchQuery.value.isEmpty) {
      return guidedMeditationList;
    }
    return guidedMeditationList
        .where(
          (m) =>
      (m.name ?? "").toLowerCase().contains(
        guidedMeditationSearchQuery.value.toLowerCase(),
      ) ||
          (m.meaning ?? "").toLowerCase().contains(
            guidedMeditationSearchQuery.value.toLowerCase(),
          ),
    )
        .toList();
  }

  List<MeditationData> get filteredMeditationList {
    if (searchQuery.value.isEmpty) {
      return meditationController.meditationList;
    }
    final query = searchQuery.value.toLowerCase();
    return meditationController.meditationList
        .where(
          (med) =>
      (med.title ?? "").toLowerCase().contains(query) ||
          (med.subtitle ?? "").toLowerCase().contains(query),
    )
        .toList();
  }
}