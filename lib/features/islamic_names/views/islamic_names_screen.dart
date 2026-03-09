import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/islamic_names/views/name_importance_screen.dart';
import 'package:maroofkhan8/features/islamic_names/views/name_guidelines_screen.dart';
import 'package:maroofkhan8/features/islamic_names/views/girl_names_screen.dart';
import 'package:maroofkhan8/features/islamic_names/views/boy_names_screen.dart';
import '../controller/islamic_name_controller.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);

class IslamicNamesScreen extends StatelessWidget {
  const IslamicNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(IslamicNameController());
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFBFBFD),
      appBar: AppBar(
        title: HeaderSection(title: tr("islamic_names")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white70 : Colors.grey,
            size: sw * 0.05,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: sw * 0.05,
          vertical: sh * 0.03,
        ),
        child: Column(
          children: [
            // Top Cards Row
            Row(
              children: [
                Expanded(
                  child: _genderCard(
                    context,
                    tr("girls_names_with_meanings"),
                    Icons.face_outlined,
                    hasBorder: false,
                    onTap: () {
                      Get.to(() => const GirlNamesScreen());
                    },
                  ),
                ),
                SizedBox(width: sw * 0.04),
                Expanded(
                  child: _genderCard(
                    context,
                    tr("boys_names_with_meanings"),
                    Icons.face_6_outlined,
                    hasBorder: false,
                    onTap: () {
                      Get.to(() => const BoyNamesScreen());
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: sh * 0.035),

            // Horizontal Info Cards
            _infoCard(
              context,
              tr("importance_of_name"),
              imagePath: "assets/icons/children.png",
              onTap: () {
                Get.to(() => const NameImportanceScreen());
              },
            ),
            SizedBox(height: sh * 0.018),
            _infoCard(
              context,
              tr("choosing_name_guidelines"),
              imagePath: "assets/icons/baby.png",
              onTap: () {
                Get.to(() => const NameGuidelinesScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderCard(
    BuildContext context,
    String text,
    IconData icon, {
    required bool hasBorder,
    VoidCallback? onTap,
  }) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: sh * 0.2,
        padding: EdgeInsets.all(sw * 0.03),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasBorder
                ? kPrimaryBrown
                : (isDark ? Colors.grey.shade900 : Colors.grey.shade200),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: sw * 0.12,
              color: isDark
                  ? kPrimaryBrown
                  : const Color.fromARGB(255, 113, 113, 113),
            ),
            SizedBox(height: sh * 0.015),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(
                fontSize: sw * 0.035,
                color: isDark
                    ? Colors.white
                    : const Color.fromARGB(255, 0, 0, 0),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    BuildContext context,
    String text, {
    IconData? icon,
    String? imagePath,
    VoidCallback? onTap,
  }) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sw * 0.04,
          vertical: sh * 0.025,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (imagePath != null)
              Image.asset(imagePath, width: sw * 0.12, height: sw * 0.12)
            else if (icon != null)
              Icon(
                icon,
                size: sw * 0.12,
                color: isDark ? Colors.white38 : Colors.grey.shade400,
              ),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.ebGaramond(
                  fontSize: sw * 0.038,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2E2E2E),
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(width: sw * 0.025),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryBrown, width: 1.5),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: kPrimaryBrown,
                size: sw * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
