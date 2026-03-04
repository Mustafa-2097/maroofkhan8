import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/features/hadis/controller/hadith_controller.dart';
import 'package:maroofkhan8/features/hadis/models/hadith_book.dart';
import 'package:maroofkhan8/features/hadis/models/hadith_chapter.dart';
import 'package:maroofkhan8/features/quran/views/quran_screen.dart';

import 'hadith_list_details_screen.dart';
import 'saved_hadiths_screen.dart';

class HadithBookDetailsScreen extends StatefulWidget {
  final HadithBook book;
  const HadithBookDetailsScreen({super.key, required this.book});

  @override
  State<HadithBookDetailsScreen> createState() =>
      _HadithBookDetailsScreenState();
}

class _HadithBookDetailsScreenState extends State<HadithBookDetailsScreen> {
  final controller = HadithController.instance;

  @override
  void initState() {
    super.initState();
    // Clear chapter search query only
    controller.chapterSearchQuery.value = '';
    // Fetch chapters using the book slug (id)
    controller.fetchHadithChapters(widget.book.id);
    controller.chapterSearchQuery.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // 1. Header with Decorative Lines
            HeaderDecoration(bookName: widget.book.name),

            const SizedBox(height: 15),

            // 2. Search Bar & Bookmark
            const SearchBarSection(),

            const SizedBox(height: 10),

            // 3. List of Chapters
            Expanded(
              child: Obx(() {
                if (controller.isChaptersLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final chapters = controller.filteredChapters;
                if (chapters.isEmpty) {
                  return const Center(child: Text("No Chapters Available"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HadithListDetailsScreen(
                              slug: widget.book.id,
                              chapterNum: chapter.number,
                              bookName: widget.book.name,
                            ),
                          ),
                        );
                      },
                      child: _buildChapterItem(chapter),
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

  Widget _buildChapterItem(HadithChapter chapter) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            children: [
              HexagonBadge(number: chapter.number),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E2E2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Hadith Chapter  |  ${chapter.number}",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA6A6A6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(height: 1, color: Colors.grey),
        ),
      ],
    );
  }
}

class HeaderDecoration extends StatelessWidget {
  final String bookName;
  const HeaderDecoration({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 20,
            ),
          ),
          const Expanded(
            child: Divider(
              indent: 10,
              endIndent: 10,
              color: Colors.grey,
              thickness: 0.7,
            ),
          ),

          const Icon(Icons.circle, size: 4, color: Color(0xFF8D3C1F)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              bookName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E2E2E),
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
          const SizedBox(width: 30), // Balancing for back button
        ],
      ),
    );
  }
}

class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HadithController.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                onChanged: (value) =>
                    controller.chapterSearchQuery.value = value,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Get.to(() => const SavedHadithsScreen()),
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(Icons.bookmark_outline, color: Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }
}
