import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/salawat_controller.dart';
import '../model/salawat_model.dart';
import 'salawat_screen.dart';

class SavedSalawatScreen extends StatelessWidget {
  const SavedSalawatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalawatController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    const Color kPrimaryBrown = Color(0xFF8D3C1F);
    const Color kBackground = Color(0xFFF9F9FB);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
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
          height: sh * 0.055,
          margin: EdgeInsets.only(right: sw * 0.05),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            tr("bookmarked_salawat"),
            style: GoogleFonts.playfairDisplay(
              color: isDark ? Colors.white : const Color(0xFF2E2E2E),
              fontWeight: FontWeight.w500,
              fontSize: sw * 0.045,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.savedSalawatList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryBrown),
          );
        }

        final savedItems = controller.savedSalawatList;

        if (savedItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: sw * 0.15,
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(height: sh * 0.02),
                Text(
                  tr("no_saved_salawat_yet"),
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey,
                    fontSize: sw * 0.04,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(sw * 0.05),
          itemCount: savedItems.length,
          itemBuilder: (context, index) {
            final salawat = savedItems[index];
            return _SavedSalawatCard(salawat: salawat);
          },
        );
      }),
    );
  }
}

class _SavedSalawatCard extends StatelessWidget {
  final SalawatData salawat;

  const _SavedSalawatCard({required this.salawat});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalawatController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    const Color kPrimaryBrown = Color(0xFF8D3C1F);
    const Color kTextDark = Color(0xFF2E2E2E);
    const Color kTextGrey = Color(0xFF757575);

    return GestureDetector(
      onTap: () => Get.to(() => SalawatDetailScreen(salawat: salawat)),
      child: Container(
        margin: EdgeInsets.only(bottom: sh * 0.015),
        padding: EdgeInsets.all(sw * 0.04),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: sw * 0.1,
              height: sw * 0.1,
              decoration: BoxDecoration(
                color: kPrimaryBrown.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  color: kPrimaryBrown,
                  size: sw * 0.055,
                ),
              ),
            ),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(salawat.title ?? "untitled"),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: sw * 0.04,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kTextDark,
                    ),
                  ),
                  if (salawat.arabic != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      salawat.arabic!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.amiri(
                        fontSize: sw * 0.038,
                        color: isDark ? Colors.grey[400] : kTextGrey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () => controller.toggleBookmark(salawat),
              icon: Icon(
                Icons.bookmark,
                color: const Color.fromARGB(255, 146, 35, 27),
                size: sw * 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
