import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/islamic_name_controller.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFFBFBFD);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class SavedIslamicNamesScreen extends StatelessWidget {
  const SavedIslamicNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = IslamicNameController.instance;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          // "Saved Names",
          tr("saved_names_title"),
          style: GoogleFonts.ebGaramond(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isSavedLoading.value &&
            controller.savedNameList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryBrown),
          );
        }

        final savedNames = controller.savedNameList;

        if (savedNames.isEmpty) {
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
                  // "No saved names yet",
                  tr("no_saved_names_yet"),
                  style: GoogleFonts.ebGaramond(fontSize: 18, color: kTextGrey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: savedNames.length,
          itemBuilder: (context, index) {
            final name = savedNames[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name.name,
                              style: GoogleFonts.ebGaramond(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kTextDark,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "– ${name.arabic}",
                              style: GoogleFonts.amiri(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kTextDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          // "Meaning: ${name.meaning}",
                          "${tr("meaning_colon")} ${name.meaning}",
                          style: GoogleFonts.ebGaramond(
                            fontSize: 14,
                            color: kTextGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.toggleSaveStatus(name),
                    child: Icon(Icons.bookmark, color: kPrimaryBrown, size: 20),
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
