import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/quran_controller.dart';
import '../model/surah_model.dart';
import 'quran_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

class SavedSurasScreen extends StatelessWidget {
  const SavedSurasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuranController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const Color kPrimaryBrown = Color(0xFF8D3C1F);
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Container(
          width: double.infinity,
          // height: 45,
          height: sh * 0.05,
          // margin: const EdgeInsets.only(right: 20),
          margin: EdgeInsets.only(right: sw * 0.05),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            tr("bookmarked_surahs"),
            style: GoogleFonts.playfairDisplay(
              color: isDark ? Colors.white : const Color(0xFF2E2E2E),
              fontWeight: FontWeight.w500,
              // fontSize: 18,
              fontSize: sw * 0.045,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isSavedLoading.value && controller.savedSurahs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryBrown),
          );
        }

        final savedItems = controller.savedSurahs;

        if (savedItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  // size: 64,
                  size: sw * 0.15,
                  color: Colors.grey.withOpacity(0.5),
                ),
                // const SizedBox(height: 16),
                SizedBox(height: sh * 0.02),
                Text(
                  tr("no_saved_surahs"),
                  // style: const TextStyle(color: Colors.grey, fontSize: 16),
                  style: TextStyle(color: Colors.grey, fontSize: sw * 0.04),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          // padding: const EdgeInsets.all(20),
          padding: EdgeInsets.all(sw * 0.05),
          itemCount: savedItems.length,
          itemBuilder: (context, index) {
            final surah = savedItems[index];
            final nameKey = "surah_${surah.id}_name";
            final transKey = "surah_${surah.id}_trans";
            // final localizedName = tr(nameKey) == nameKey
            //     ? surah.name
            //     : tr(nameKey);
            // final localizedTrans = tr(transKey) == transKey
            //     ? surah.translatedName
            //     : tr(transKey);
            final localizedName = tr(nameKey);
            final localizedTrans = tr(transKey);

            return SurahCard(
              num: localizeDigits("${surah.id}", context),
              title: localizedName,
              sub:
                  "$localizedTrans  | ${localizeDigits("${surah.versesCount}", context)} ${tr('ayah')}",
              surah: surah,
            );
          },
        );
      }),
    );
  }
}

class SurahCard extends StatelessWidget {
  final String num;
  final String title;
  final String sub;
  final SurahModel surah;

  const SurahCard({
    super.key,
    required this.num,
    required this.title,
    required this.sub,
    required this.surah,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuranController>();
    const Color kPrimaryBrown = Color(0xFF8D3C1F);
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Get.to(() => QuranDetailsScreen(surah: surah)),
      child: Container(
        // margin: const EdgeInsets.only(bottom: 12),
        margin: EdgeInsets.only(bottom: sh * 0.015),
        // padding: const EdgeInsets.all(16),
        padding: EdgeInsets.all(sw * 0.04),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              // width: 40,
              // height: 40,
              width: sw * 0.1,
              height: sw * 0.1,
              decoration: BoxDecoration(
                color: kPrimaryBrown.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  num,
                  style: const TextStyle(
                    color: kPrimaryBrown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // const SizedBox(width: 16),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      // fontSize: 16,
                      fontSize: sw * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sub,
                    // style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    style: TextStyle(
                      fontSize: sw * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => controller.toggleSaveSurah(surah),
              icon: const Icon(Icons.bookmark, color: kPrimaryBrown),
            ),
          ],
        ),
      ),
    );
  }
}
