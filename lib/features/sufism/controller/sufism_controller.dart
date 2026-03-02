import 'package:get/get.dart';
import '../../Islam_meditation/controller/meditation_controller.dart';
import '../../Islam_meditation/model/meditation_model.dart';

class SufismController extends GetxController {
  static SufismController get instance => Get.find();

  final MeditationController meditationController =
      Get.find<MeditationController>();

  var searchQuery = "".obs;
  var teacherSearchQuery = "".obs;

  final teachers = [
    {
      "name": "Islamic Mentor",
      "img":
          "https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=200",
    },
    {
      "name": "Islamic Mentor",
      "img":
          "https://images.unsplash.com/photo-1542358827-046645367332?auto=format&fit=crop&q=80&w=200",
    },
    {
      "name": "Deen Guide",
      "img":
          "https://images.unsplash.com/photo-1519817650390-64a93db51149?auto=format&fit=crop&q=80&w=200",
    },
    {
      "name": "Fiqh Instructor",
      "img":
          "https://images.unsplash.com/photo-1545989253-02cc26577f88?auto=format&fit=crop&q=80&w=200",
    },
  ];

  List<Map<String, String>> get filteredTeacherList {
    if (teacherSearchQuery.value.isEmpty) {
      return teachers;
    }
    return teachers
        .where(
          (t) => t['name']!.toLowerCase().contains(
            teacherSearchQuery.value.toLowerCase(),
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
