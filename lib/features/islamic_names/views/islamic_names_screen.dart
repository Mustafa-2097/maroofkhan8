import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/features/islamic_names/views/name_importance_screen.dart';
import 'package:maroofkhan8/features/islamic_names/views/name_guidelines_screen.dart';
import 'package:maroofkhan8/features/islamic_names/views/girl_names_screen.dart';
import 'package:maroofkhan8/features/islamic_names/views/boy_names_screen.dart';
import '../controller/islamic_name_controller.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFFBFBFD);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class IslamicNamesScreen extends StatelessWidget {
  const IslamicNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(IslamicNameController());
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
          "Islamic Name",
          style: GoogleFonts.ebGaramond(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Top Cards Row
            Row(
              children: [
                Expanded(
                  child: _genderCard(
                    "Islamic girls' names with meanings",
                    Icons.face_outlined,
                    hasBorder: false,
                    onTap: () {
                      Get.to(() => const GirlNamesScreen());
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _genderCard(
                    "Islamic Boys' names with meanings",
                    Icons.face_6_outlined,
                    hasBorder: false,
                    onTap: () {
                      Get.to(() => const BoyNamesScreen());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Horizontal Info Cards
            _infoCard(
              "The Importance of Giving a Beautiful Name to a Child in Islam",
              imagePath: "assets/icons/children.png",
              onTap: () {
                Get.to(() => const NameImportanceScreen());
              },
            ),
            const SizedBox(height: 15),
            _infoCard(
              "Islamic Guidelines for Choosing a Name",
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
    String text,
    IconData icon, {
    required bool hasBorder,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasBorder ? kPrimaryBrown : Colors.grey.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
              size: 50,
              color: const Color.fromARGB(255, 113, 113, 113),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(
                fontSize: 14,
                color: const Color.fromARGB(255, 0, 0, 0),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    String text, {
    IconData? icon,
    String? imagePath,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (imagePath != null)
              Image.asset(imagePath, width: 45, height: 45)
            else if (icon != null)
              Icon(icon, size: 45, color: Colors.grey.shade400),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.ebGaramond(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryBrown, width: 1.5),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: kPrimaryBrown,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
