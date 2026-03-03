import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/quran_controller.dart';
import '../model/surah_model.dart';
import 'quran_screen.dart';

class SavedSurasScreen extends StatelessWidget {
  const SavedSurasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuranController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const Color kPrimaryBrown = Color(0xFF8D3C1F);

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
          height: 45,
          margin: const EdgeInsets.only(right: 20),
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
            "Saved Surahs",
            style: GoogleFonts.playfairDisplay(
              color: isDark ? Colors.white : const Color(0xFF2E2E2E),
              fontWeight: FontWeight.w500,
              fontSize: 18,
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
                  size: 64,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  "No saved surahs yet",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: savedItems.length,
          itemBuilder: (context, index) {
            final surah = savedItems[index];
            return SurahCard(
              num: "${surah.id}",
              title: surah.name,
              sub: "${surah.translatedName}  | ${surah.versesCount} Ayah",
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

    return GestureDetector(
      onTap: () => Get.to(() => QuranDetailsScreen(surah: surah)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
              width: 40,
              height: 40,
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
