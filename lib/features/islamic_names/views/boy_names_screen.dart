import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/islamic_name_controller.dart';
import 'saved_islamic_names_screen.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);

class BoyNamesScreen extends StatelessWidget {
  const BoyNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IslamicNameController>();
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
          tr("islamic_boys_name_title"),
          style: GoogleFonts.ebGaramond(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.05,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.nameList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryBrown),
          );
        }

        final boyNames = controller.boyNames;

        return Column(
          children: [
            // Search Bar & Saved Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.05,
                vertical: sh * 0.018,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: sh * 0.055,
                      padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade900
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: TextField(
                        onChanged: (val) =>
                            controller.boySearchQuery.value = val,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: tr("search_hint"),
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.grey[600]
                                : Colors.grey.shade300,
                            fontSize: sw * 0.035,
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: sh * 0.015,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: sw * 0.025),
                  GestureDetector(
                    onTap: () => Get.to(() => const SavedIslamicNamesScreen()),
                    child: Container(
                      height: sh * 0.055,
                      width: sh * 0.055,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade900
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        color: isDark ? Colors.white70 : Colors.grey,
                        size: sw * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List of Names
            Expanded(
              child: boyNames.isEmpty
                  ? Center(
                      child: Text(
                        tr("no_names_found"),
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.black,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
                      itemCount: boyNames.length,
                      itemBuilder: (context, index) {
                        final name = boyNames[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: sh * 0.012),
                          padding: EdgeInsets.all(sw * 0.04),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade200,
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
                                  name.isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: name.isSaved
                                      ? kPrimaryBrown
                                      : (isDark ? Colors.white38 : Colors.grey),
                                  size: sw * 0.05,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
