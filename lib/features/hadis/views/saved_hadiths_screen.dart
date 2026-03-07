import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/hadith_controller.dart';
import 'hadith_tafsir_details_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

class SavedHadithsScreen extends StatelessWidget {
  const SavedHadithsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HadithController.instance;
    const Color primaryBrown = Color(0xFF8D3C1F);
    const Color background = Color(0xFFFBFBFD);
    const Color textDark = Color(0xFF2E2E2E);
    const Color textGrey = Color(0xFF757575);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          tr("saved_hadiths"),
          style: GoogleFonts.ebGaramond(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isSavedLoading.value &&
            controller.savedHadiths.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: primaryBrown),
          );
        }

        final savedItems = controller.savedHadiths;

        if (savedItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  tr("no_saved_hadiths_yet"),
                  style: GoogleFonts.ebGaramond(fontSize: 18, color: textGrey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: savedItems.length,
          itemBuilder: (context, index) {
            final hadith = savedItems[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hadith.hadith,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.ebGaramond(
                      fontSize: 15,
                      height: 1.5,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        hadith.heading.isNotEmpty
                            ? hadith.heading
                            : tr("hadith"),
                        style: const TextStyle(
                          fontSize: 11,
                          color: textGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          controller.toggleSaveHadith(
                            hadithText: hadith.hadith,
                            book: hadith.heading,
                            chapterNo: "0",
                            hadithNo: hadith.number,
                            currentlySaved: true,
                            savedId: hadith.savedId,
                          );
                        },
                        child: const Icon(
                          Icons.bookmark,
                          color: Color(0xFF8D3C1F),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          final shareText =
                              "(${hadith.heading.isNotEmpty ? hadith.heading : ''})\n\n"
                              "${hadith.hadith}\n\n"
                              "(${tr('hadith')} ${localizeDigits(hadith.number, context)})\n\n"
                              "Shared via Maroof Khan App";
                          Share.share(shareText);
                        },
                        child: const Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: Color(0xFF8D3C1F),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => HadishTafsirDetailsScreen(
                              hadithText: hadith.hadith,
                              bookName: hadith.heading,
                              chapterNum: "0",
                              hadithNumber: hadith.number,
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.visibility_outlined,
                          color: primaryBrown,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
