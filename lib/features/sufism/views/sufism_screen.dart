import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:maroofkhan8/features/Islam_meditation/controller/meditation_controller.dart';
import 'package:maroofkhan8/features/home/dhikr/dhikr_screen.dart';
import 'package:maroofkhan8/features/sufism/controller/sufism_controller.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/widgets/header.dart';
import '../../ahle_bait/views/ahle_bait_screen.dart';
import '../../allah_names/views/allah_names.dart';
import '../../home/awliya_allah/awliya_allah_list_screen.dart';
import '../../islamic_books/views/islamic_books_screen.dart';
import '../../sahaba/views/sahaba_screen.dart';
import '../../salawat/views/salawat_screen.dart';
import '../../Islam_meditation/views/islam_meditation_screen.dart'
    show MainMenuScreen, MeditationPlayerScreen;
import '../../islamic_names/views/islamic_names_screen.dart';
import '../model/guided_meditation_model.dart';
import '../model/islamic_teacher_model.dart';

// --- CONSTANTS & THEME ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);
const Color kBackground = Color(0xFFFDFDFD);
const Color kDarkBlack = Color(0xFF1E120D);

// ==========================================
// SCREEN 1: SUFISM HOME
// ==========================================
class SufismHomeScreen extends StatelessWidget {
  final bool hideBack;
  const SufismHomeScreen({super.key, this.hideBack = false});

  @override
  Widget build(BuildContext context) {
    Get.put(MeditationController());
    final sufismController = Get.put(SufismController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await sufismController.fetchGuidedMeditations();
            await sufismController.fetchIslamicTeachers();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: sw * 0.04,
              vertical: sh * 0.012,
            ),
            child: Column(
              children: [
                HeaderSection(title: tr("sufism")),
                Center(
                  child: Text(
                    // "Daily Wisdom & Meditation",
                    tr("daily_wisdom_meditation"),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.whiteColor : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Search
                // Search
                // CustomSearchBar(
                //   onChanged: (val) => sufismController.searchQuery.value = val,
                // ),
                const SizedBox(height: 20),

                // Quote Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Theme.of(context).colorScheme.surface
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Text(
                      //   "مَنْ عَرَفَ نَفْسَهُ عَرَفَ رَبَّهُ",
                      //   style: GoogleFonts.amiri(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Text(
                        tr("sufi_quote_arabic"),
                        textAlign: TextAlign.center,

                        style: GoogleFonts.amiri(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: sw * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: sh * 0.01),
                      // const SizedBox(height: 10),
                      // Text(
                      //   "Man ‘arafa nafsahu ‘arafa rabbahu.",
                      //   style: GoogleFonts.playfairDisplay(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.bold,
                      //     fontStyle: FontStyle.italic,
                      //   ),
                      // ),
                      Text(
                        tr("sufi_quote_transliteration"),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: sw * 0.035,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: sh * 0.015),
                      // const SizedBox(height: 5),
                      // const Text(
                      //   "Whoever knows himself knows his Lord.\"",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(fontSize: 12, color: kTextGrey),
                      // ),
                      Text(
                        tr("sufi_quote"),
                        textAlign: TextAlign.center,
                        //style: Theme.of(context).textTheme.headlineMedium,
                        style: isDark
                            ? Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.black,
                                fontSize: sw * 0.045,
                                fontWeight: FontWeight.w600,
                              ),
                        // style: GoogleFonts.outfit(
                        //   color: isDark ? Colors.white : Colors.black,
                        //   fontSize: 16.sp,
                        //   fontWeight: FontWeight.w500,
                        // ),
                      ),
                      // const SizedBox(height: 10),
                      HeaderDecorationMini(
                        // label: "Ibn Arabi",
                        label: tr("ibn_arabi"),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        // child: Icon(
                        //   Icons.favorite_border,
                        //   size: 18,
                        //   color: Colors.grey.shade400,
                        // ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // 3. Explore more Section
                Row(
                  children: [
                    Icon(
                      Icons.explore_outlined,
                      color: kPrimaryBrown,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Explore",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const ExploreMoreGrid(),

                const SizedBox(height: 25),

                // Guided Meditation List
                Text(
                  tr("guided_meditation"),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Obx(() {
                  if (sufismController.isMeditationLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (sufismController.guidedMeditationList.isEmpty) {
                    return Center(child: Text(tr("no_records_found")));
                  }
                  final fullList = sufismController.guidedMeditationList
                      .toList();
                  final displayList = fullList.take(2).toList();
                  return Column(
                    children: List.generate(
                      displayList.length,
                      (i) => _meditationTile(
                        context,
                        displayList[i].name ?? tr("untitled"),
                        displayList[i].nameArabic ?? "",
                        displayList[i].meaning ?? "",
                        medData: displayList[i],
                        allMeditations: fullList,
                        index: i,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 10),
                Obx(() {
                  if (sufismController.guidedMeditationList.length <= 2) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () =>
                        Get.to(() => const GuidedMeditationListScreen()),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryBrown,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tr("more"),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward,
                              size: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 25),

                // Teaching Section
                Text(
                  tr("teaching"),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                Obx(() {
                  if (sufismController.isTeacherLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (sufismController.teacherList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(tr("no_records_found")),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () =>
                                sufismController.fetchIslamicTeachers(),
                            child: Text(
                              tr("retry"),
                              style: TextStyle(color: kPrimaryBrown),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: sufismController.teacherList
                              .take(2)
                              .map(
                                (teacher) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: _teachingCard(
                                      context,
                                      // teacher.title ?? "",
                                      teacher.title ?? tr("untitled"),
                                      teacher.image ?? "",
                                      teacherId: teacher.id,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () =>
                              Get.to(() => const IslamicTeachersScreen()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryBrown,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Text(
                                //   "More",
                                Text(
                                  tr("more"),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _meditationTile(
    BuildContext context,
    String title,
    String titleArabic,
    String sub, {
    GuidedMeditationData? medData,
    List<GuidedMeditationData> allMeditations = const [],
    int index = 0,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        if (medData != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MeditationPlayerScreen(
                guidedMeditation: medData,
                allGuidedMeditations: allMeditations,
                initialIndex: index,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: sh * 0.014),
        padding: EdgeInsets.symmetric(
          vertical: sh * 0.014,
          horizontal: sw * 0.04,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: kPrimaryBrown,
              child: Icon(Icons.donut_large, color: Colors.white, size: 18),
            ),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleArabic.isNotEmpty ? '$title ($titleArabic)' : title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: sw * 0.033,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: sw * 0.025,
                      color: isDark ? Colors.grey[400] : kTextGrey,
                    ),
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 12,
              backgroundColor: kPrimaryBrown,
              child: Icon(Icons.chevron_right, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _teachingCard(
    BuildContext context,
    String title,
    String imgUrl, {
    String? teacherId,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (teacherId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TeachingDetailsScreen(teacherId: teacherId),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const IslamicTeachersScreen()),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: sw * 0.03,
          horizontal: sw * 0.02,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imgUrl),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: sw * 0.03,
                color: isDark ? Colors.grey[300] : kTextGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 1A: GUIDED MEDITATION LIST
// ==========================================
class GuidedMeditationListScreen extends StatelessWidget {
  const GuidedMeditationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final sufismController = SufismController.instance;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("guided_meditation")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [const SizedBox(width: 40)],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
          child: Column(
            children: [
              SizedBox(height: sh * 0.012),
              // Simple Border Search
              Container(
                height: sh * 0.055,
                padding: EdgeInsets.symmetric(horizontal: sw * 0.025),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  onChanged: (val) =>
                      sufismController.guidedMeditationSearchQuery.value = val,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: tr("search"),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: sh * 0.025),
              // List
              Expanded(
                child: Obx(() {
                  if (sufismController.isMeditationLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (sufismController.filteredGuidedMeditationList.isEmpty) {
                    // return const Center(child: Text("No records found"));
                    return Center(child: Text(tr("no_records_found")));
                  }
                  return ListView.builder(
                    itemCount:
                        sufismController.filteredGuidedMeditationList.length,
                    itemBuilder: (context, index) {
                      final list =
                          sufismController.filteredGuidedMeditationList;
                      final med = list[index];
                      return _meditationTile(
                        context,
                        med.name ?? tr("untitled"),
                        med.nameArabic ?? "",
                        med.meaning ?? "",
                        medData: med,
                        allMeditations: list,
                        index: index,
                        isDark: isDark,
                        sw: sw,
                        sh: sh,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meditationTile(
    BuildContext context,
    String title,
    String titleArabic,
    String sub, {
    GuidedMeditationData? medData,
    List<GuidedMeditationData> allMeditations = const [],
    int index = 0,
    bool isDark = false,
    double sw = 0,
    double sh = 0,
  }) {
    return GestureDetector(
      onTap: () {
        if (medData != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MeditationPlayerScreen(
                guidedMeditation: medData,
                allGuidedMeditations: allMeditations,
                initialIndex: index,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: sh > 0 ? sh * 0.014 : 12),
        padding: EdgeInsets.symmetric(
          vertical: sh > 0 ? sh * 0.014 : 12,
          horizontal: sw > 0 ? sw * 0.04 : 15,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: kPrimaryBrown,
              child: Icon(Icons.donut_large, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleArabic.isNotEmpty ? '$title ($titleArabic)' : title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: sw > 0 ? sw * 0.033 : 13,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: sw > 0 ? sw * 0.025 : 10,
                      color: isDark ? Colors.grey[400] : kTextGrey,
                    ),
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 12,
              backgroundColor: kPrimaryBrown,
              child: Icon(Icons.chevron_right, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2: ISLAMIC TEACHERS LIST
// ==========================================
class IslamicTeachersScreen extends StatelessWidget {
  const IslamicTeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final sufismController = SufismController.instance;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("islamic_teachers")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [const SizedBox(width: 40)],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
          child: Column(
            children: [
              SizedBox(height: sh * 0.012),
              // Simple Border Search
              Container(
                height: sh * 0.055,
                padding: EdgeInsets.symmetric(horizontal: sw * 0.025),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  onChanged: (val) =>
                      sufismController.teacherSearchQuery.value = val,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: tr("search"),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: sh * 0.025),
              // List
              Expanded(
                child: Obx(() {
                  if (sufismController.isTeacherLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (sufismController.filteredTeacherList.isEmpty) {
                    // return const Center(child: Text("No teachers found"));
                    return Center(child: Text(tr("no_teachers_found")));
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: sufismController.filteredTeacherList.length,
                    itemBuilder: (context, index) {
                      final teacher =
                          sufismController.filteredTeacherList[index];
                      return _teacherCard(context, teacher);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _teacherCard(BuildContext context, IslamicTeacherData teacher) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final sw = MediaQuery.of(context).size.width;
  final sh = MediaQuery.of(context).size.height;
  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeachingDetailsScreen(teacherId: teacher.id!),
      ),
    ),
    child: Container(
      margin: EdgeInsets.only(bottom: sh * 0.018),
      padding: EdgeInsets.all(sw * 0.03),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: sw * 0.07,
            backgroundImage: NetworkImage(teacher.image ?? ""),
            backgroundColor: Colors.grey.shade200,
          ),
          SizedBox(width: sw * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teacher.title ?? tr("untitled"),
                  style: GoogleFonts.playfairDisplay(
                    fontWeight: FontWeight.bold,
                    fontSize: sw * 0.04,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  teacher.subtitle ?? "",
                  style: TextStyle(
                    fontSize: sw * 0.03,
                    color: isDark ? Colors.grey[400] : kTextGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: sw * 0.09,
            width: sw * 0.09,
            decoration: BoxDecoration(
              color: kPrimaryBrown,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    ),
  );
}

// ==========================================
// SCREEN 3: TEACHING DETAILS
// ==========================================
class TeachingDetailsScreen extends StatefulWidget {
  final String teacherId;
  const TeachingDetailsScreen({super.key, required this.teacherId});

  @override
  State<TeachingDetailsScreen> createState() => _TeachingDetailsScreenState();
}

class _TeachingDetailsScreenState extends State<TeachingDetailsScreen> {
  IslamicTeacherData? teacherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final data = await SufismController.instance.fetchTeacherById(
      widget.teacherId,
    );
    if (mounted) {
      setState(() {
        teacherData = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    if (isLoading) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (teacherData == null) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
        body: Center(child: Text(tr("teacher_details_not_found"))),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sw * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
              CircleAvatar(
                radius: sw * 0.13,
                backgroundImage: NetworkImage(teacherData!.image ?? ""),
                backgroundColor: Colors.grey.shade200,
              ),
              SizedBox(height: sh * 0.018),
              Text(
                teacherData!.title ?? "",
                style: GoogleFonts.playfairDisplay(
                  fontSize: sw * 0.05,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: sh * 0.006),
              Text(
                teacherData!.subtitle ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.ebGaramond(
                  fontSize: sw * 0.04,
                  color: isDark ? Colors.grey[400] : kTextGrey,
                ),
              ),
              SizedBox(height: sh * 0.03),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tr("his_teaching"),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: sw * 0.045,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              SizedBox(height: sh * 0.018),

              if (teacherData!.teachings == null ||
                  teacherData!.teachings!.isEmpty)
                // const Center(child: Text("No special teachings recorded."))
                Center(child: Text(tr("no_teachings_found")))
              else
                ...teacherData!.teachings!
                    .map(
                      (t) => _teachingContentCard(
                        context,
                        t.title ?? "",
                        t.description ?? "",
                      ),
                    )
                    .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teachingContentCard(
    BuildContext context,
    String title,
    String description,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: sh * 0.018),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              fontSize: sw * 0.04,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: sh * 0.01),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: sw * 0.033,
              color: isDark ? Colors.grey[400] : kTextGrey,
              height: 1.5,
            ),
          ),
          SizedBox(height: sh * 0.012),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    final isDarkSheet =
                        Theme.of(context).brightness == Brightness.dark;
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkSheet
                            ? const Color(0xFF1E1E1E)
                            : Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      padding: EdgeInsets.all(sw * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            title,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: sw * 0.055,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryBrown,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Text(
                                description,
                                style: GoogleFonts.ebGaramond(
                                  fontSize: sw * 0.045,
                                  height: 1.6,
                                  color: isDarkSheet
                                      ? Colors.grey[300]
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryBrown,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tr("read_more"),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SHARED HELPER WIDGETS ---

class HeaderWithLines extends StatelessWidget {
  final String title;
  const HeaderWithLines({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.circle, size: 4, color: kPrimaryBrown),
        Container(width: 40, height: 1, color: Colors.grey.shade300),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Container(width: 40, height: 1, color: Colors.grey.shade300),
        const Icon(Icons.circle, size: 4, color: kPrimaryBrown),
      ],
    );
  }
}

class HeaderDecorationMini extends StatelessWidget {
  final String label;
  const HeaderDecorationMini({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 20, height: 1, color: kPrimaryBrown),
        const SizedBox(width: 5),
        const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 5),
        const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
        const SizedBox(width: 5),
        Container(width: 20, height: 1, color: kPrimaryBrown),
      ],
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const CustomSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E120D) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          // hintText: "Search...",
          hintText: tr("search"),
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 8),
        ),
      ),
    );
  }
}

class ExploreMoreGrid extends StatelessWidget {
  const ExploreMoreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.75,
      mainAxisSpacing: MediaQuery.of(context).size.height * 0.015,
      crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => AhleBaitListScreen());
          },
          child: _GridCard(
            // title: "Ahle Bait",
            title: tr("ahle_bait"),
            icon: Icons.diversity_3,
            color: isDark
                ? Colors.green.withOpacity(0.15)
                : const Color(0xFFE6F5D8),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => AwliyaAllahListScreen());
          },
          child: _GridCard(
            // title: "Awliya\nAllah",
            title: tr("awliya_allah"),
            icon: Icons.nightlight_round,
            color: isDark
                ? primaryColor.withOpacity(0.1)
                : const Color(0xFFE0D9FA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SahabaListScreen());
          },
          child: _GridCard(
            // title: "Sahaba",
            title: tr("sahaba"),
            icon: Icons.groups,
            color: isDark
                ? Colors.orange.withOpacity(0.15)
                : const Color(0xFFFFD6CA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => DhikrListScreen());
          },
          child: _GridCard(
            // title: "Dhikr",
            title: tr("dhikr"),
            icon: Icons.search,
            color: isDark
                ? Colors.pink.withOpacity(0.15)
                : const Color(0xFFE94E77),
            isPinkCard: true,
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => NamesOfAllahScreen());
          },
          child: _GridCard(
            // title: "99\nNames",
            title: tr("names_99"),
            icon: Icons.verified_outlined,
            color: isDark
                ? Colors.green.withOpacity(0.15)
                : const Color(0xFFE6F5D8),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => const MainMenuScreen());
          },
          child: _GridCard(
            // title: "Islaah &\nMeditation",
            title: tr("islaah_meditation"),
            icon: Icons.self_improvement,
            color: isDark
                ? primaryColor.withOpacity(0.1)
                : const Color(0xFFE0D9FA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SalawatListScreen());
          },
          child: _GridCard(
            // title: "Salawat",
            title: tr("salawat"),
            icon: Icons.handshake_outlined,
            color: isDark
                ? Colors.orange.withOpacity(0.15)
                : const Color(0xFFFFD6CA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => IslamicBooksListScreen());
          },
          child: _GridCard(
            // title: "Islamic\nBooks",
            title: tr("islamic_books"),
            icon: Icons.diversity_2,
            color: isDark
                ? Colors.pink.withOpacity(0.15)
                : const Color(0xFFE94E77),
            isPinkCard: true,
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => const IslamicNamesScreen());
          },
          child: _GridCard(
            // title: "Islamic\nNames",
            title: tr("islamic_names"),
            icon: Icons.child_care,
            color: isDark
                ? Colors.green.withOpacity(0.15)
                : const Color(0xFFE6F5D8),
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _GridCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isPinkCard;
  final bool isDark;

  const _GridCard({
    required this.title,
    required this.icon,
    required this.color,
    this.isPinkCard = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
            child: Icon(
              icon,
              size: 18,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: MediaQuery.of(context).size.width * 0.028,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
