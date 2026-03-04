import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/features/hadis/controller/hadith_controller.dart';
import 'package:maroofkhan8/features/hadis/models/hadith.dart';

import 'hadish_tafsir_details_screen.dart';
import 'saved_hadiths_screen.dart';

class HadithListDetailsScreen extends StatefulWidget {
  final String slug;
  final String chapterNum;
  final String bookName;

  const HadithListDetailsScreen({
    super.key,
    required this.slug,
    required this.chapterNum,
    required this.bookName,
  });

  @override
  State<HadithListDetailsScreen> createState() =>
      _HadithListDetailsScreenState();
}

class _HadithListDetailsScreenState extends State<HadithListDetailsScreen> {
  final controller = HadithController.instance;

  @override
  void initState() {
    super.initState();
    controller.hadithSearchQuery.value = '';
    controller.fetchHadithList(widget.slug, widget.chapterNum);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBrown = Color(0xFF8D3C1F);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // 1. Header with custom title and lines
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _backButton(),
                  const Expanded(
                    child: Divider(
                      indent: 10,
                      endIndent: 10,
                      color: Colors.grey,
                      thickness: 0.7,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.circle, size: 4, color: Color(0xFF8D3C1F)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(text: "${widget.bookName}-"),
                          TextSpan(
                            text: "(Chapter-${widget.chapterNum})",
                            style: const TextStyle(color: primaryBrown),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.circle, size: 4, color: Color(0xFF8D3C1F)),
                  const Expanded(
                    child: Divider(
                      indent: 10,
                      endIndent: 10,
                      color: Colors.grey,
                      thickness: 0.7,
                    ),
                  ),
                  const SizedBox(width: 40), // Placeholder for balance
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 2. Search Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            controller.hadithSearchQuery.value = value,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.to(() => const SavedHadithsScreen()),
                    child: _iconContainer(Icons.bookmark_outline),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 3. Scrollable Hadith List
            Expanded(
              child: Obx(() {
                if (controller.isHadithLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final hadiths = controller.filteredHadithList;
                if (hadiths.isEmpty) {
                  return const Center(child: Text("No Hadiths Available"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: hadiths.length,
                  itemBuilder: (context, index) {
                    final hadith = hadiths[index];
                    return HadithCard(
                      hadith: hadith,
                      bookName: widget.bookName,
                      chapterNum: widget.chapterNum,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
    );
  }

  Widget _iconContainer(IconData icon) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Icon(icon, color: Colors.grey.shade300),
    );
  }
}

class HadithCard extends StatelessWidget {
  final Hadith hadith;
  final String bookName;
  final String chapterNum;

  const HadithCard({
    super.key,
    required this.hadith,
    required this.bookName,
    required this.chapterNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hadith.heading.isNotEmpty) ...[
            Text(
              hadith.heading,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8D3C1F),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            hadith.hadith,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF2E2E2E),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "$bookName • Hadith ${hadith.number}",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const Divider(height: 30, color: Color(0xFFEEEEEE)),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  HadithController.instance.toggleSaveHadith(
                    hadithText: hadith.hadith,
                    book: bookName,
                    chapterNo: chapterNum,
                    hadithNo: hadith.number,
                    currentlySaved: hadith.isSaved,
                    savedId: hadith.savedId,
                  );
                },
                child: Icon(
                  hadith.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  size: 18,
                  color: hadith.isSaved ? Color(0xFF8D3C1F) : Color(0xFF8D3C1F),
                ),
              ),
              const SizedBox(width: 15),
              const Icon(
                Icons.share_outlined,
                size: 18,
                color: Color(0xFF8D3C1F),
              ),
              const Spacer(),
              //  _footerAction(Icons.volume_up_outlined, "Listen"),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Get.to(
                    HadishTafsirDetailsScreen(
                      hadithText: hadith.hadith,
                      hadithNumber: hadith.number,
                      heading: hadith.heading,
                      bookName: bookName,
                      chapterNum: chapterNum,
                    ),
                  );
                },
                child: _footerAction(Icons.visibility_outlined, "Full View"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerAction(IconData icon, String label) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 5),
        Icon(icon, size: 16, color: const Color(0xFF8D3C1F)),
      ],
    );
  }
}
