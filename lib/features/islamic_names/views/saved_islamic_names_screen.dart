import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/islamic_name_controller.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);

class SavedIslamicNamesScreen extends StatelessWidget {
  const SavedIslamicNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = IslamicNameController.instance;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white70 : Colors.grey,
            size: sw * 0.05,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          tr("saved_names_title"),
          style: GoogleFonts.ebGaramond(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.055,
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
                  size: sw * 0.15,
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                ),
                SizedBox(height: sh * 0.02),
                Text(
                  tr("no_saved_names_yet"),
                  style: GoogleFonts.ebGaramond(
                    fontSize: sw * 0.045,
                    color: isDark ? Colors.grey[500] : const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: sw * 0.05,
            vertical: sh * 0.025,
          ),
          itemCount: savedNames.length,
          itemBuilder: (context, index) {
            final name = savedNames[index];
            return Container(
              margin: EdgeInsets.only(bottom: sh * 0.012),
              padding: EdgeInsets.all(sw * 0.04),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                ),
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
                                fontSize: sw * 0.04,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF2E2E2E),
                              ),
                            ),
                            SizedBox(width: sw * 0.025),
                            Text(
                              "– ${name.arabic}",
                              style: GoogleFonts.amiri(
                                fontSize: sw * 0.04,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF2E2E2E),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: sh * 0.006),
                        Text(
                          "${tr("meaning_colon")} ${name.meaning}",
                          style: GoogleFonts.ebGaramond(
                            fontSize: sw * 0.035,
                            color: isDark
                                ? Colors.grey[400]
                                : const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.toggleSaveStatus(name),
                    child: Icon(
                      Icons.bookmark,
                      color: kPrimaryBrown,
                      size: sw * 0.05,
                    ),
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
