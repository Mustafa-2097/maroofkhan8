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
    const Color kPrimaryBrown = Color(0xFF8D3C1F);
    const Color kBackground = Color(0xFFF9F9FB);

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Container(
          width: double.infinity,
          height: 45,
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            "Bookmarked Salawat",
            style: GoogleFonts.playfairDisplay(
              color: const Color(0xFF2E2E2E),
              fontWeight: FontWeight.w500,
              fontSize: 18,
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
                  size: 64,
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  "No saved salawat yet",
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
    const Color kPrimaryBrown = Color(0xFF8D3C1F);
    const Color kTextDark = Color(0xFF2E2E2E);
    const Color kTextGrey = Color(0xFF757575);

    return GestureDetector(
      onTap: () => Get.to(() => SalawatDetailScreen(salawat: salawat)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
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
                color: kPrimaryBrown.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome, color: kPrimaryBrown, size: 20),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salawat.title ?? "Untitled",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  if (salawat.arabic != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      salawat.arabic!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.amiri(fontSize: 14, color: kTextGrey),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () => controller.toggleBookmark(salawat),
              icon: const Icon(
                Icons.bookmark,
                color: Color.fromARGB(255, 146, 35, 27),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
