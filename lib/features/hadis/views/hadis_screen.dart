import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:share_plus/share_plus.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';
import '../controller/hadith_controller.dart';
import 'hadith_book_details_screen.dart';
import 'hadith_tafsir_details_screen.dart';
import 'saved_hadiths_screen.dart';

class HadithScreen extends StatefulWidget {
  final bool hideBack;
  const HadithScreen({super.key, this.hideBack = false});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  final controller = Get.put(HadithController());
  int _selectedIndex = 0;
  final Color primaryBrown = const Color(0xFF8D3C1F);
  final Color darkBlack = const Color(0xFF1E120D);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: HeaderSection(title: tr("al_hadith")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40,
        leading: widget.hideBack
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 12),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
        actions: [if (!widget.hideBack) const SizedBox(width: 40)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 2. Search & Bookmark Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        onChanged: (val) {
                          controller.searchQuery.value = val;
                        },
                        decoration: InputDecoration(
                          hintText: tr('search'),
                          hintStyle: const TextStyle(
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
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Icon(
                        Icons.bookmark_outline,
                        color: isDark
                            ? Colors.grey.shade600
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 3. Pill Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _tabButton(tr("hadith_book"), 0),
                  const SizedBox(width: 8),
                  _tabButton(tr("popular_hadith"), 1),
                  const SizedBox(width: 8),
                  _tabButton(tr("last_read"), 2, icon: Icons.access_time),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 4. Content List
            Expanded(
              child: _selectedIndex == 0
                  ? _buildBookList()
                  : _selectedIndex == 1
                  ? _buildHadithList()
                  : _buildLastReadList(),
            ),
          ],
        ),
      ),
    );
  }

  // Book List for Screen 1
  Widget _buildBookList() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final books = controller.filteredHadithBooks;
      if (books.isEmpty) {
        return Center(child: Text(tr("no_books_available")));
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Get.to(HadithBookDetailsScreen(book: book));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Book Image Placeholder
                  Container(
                    width: 45,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr("book_${book.id}_name"),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          tr("book_${book.id}_writer"),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.grey.shade500
                                : const Color(0xFFA6A6A6),
                          ),
                        ),
                        Text(
                          "${tr('chapters')} - ${localizeDigits(book.chapters.toString(), context)}",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.grey.shade500
                                : const Color(0xFFA6A6A6),
                          ),
                        ),
                        Text(
                          "${tr('hadiths')} - ${localizeDigits(book.hadiths.toString(), context)}",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.grey.shade500
                                : const Color(0xFFA6A6A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryBrown,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // Hadith Detail List for Screen 2 & 3
  Widget _buildHadithList() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      if (controller.isPopularLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final popular = controller.filteredPopularHadiths;
      if (popular.isEmpty) {
        return Center(child: Text(tr("no_popular_hadiths_available")));
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: popular.length,
        itemBuilder: (context, index) {
          final item = popular[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  item.hadith,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    item.reference.isNotEmpty
                        ? "— ${item.reference}"
                        : "— ${tr('hadith')} ${localizeDigits(item.hadithNo?.toString() ?? '0', context)}",
                    style: TextStyle(
                      color: primaryBrown,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 30),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.toggleSaveHadith(
                          hadithText: item.hadith,
                          book: item.book ?? item.reference,
                          chapterNo: item.chapterNo?.toString() ?? "0",
                          hadithNo: item.hadithNo?.toString() ?? "0",
                          currentlySaved: item.isSaved,
                          savedId: item.savedId,
                        );
                      },
                      child: Icon(
                        item.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        size: 18,
                        color: item.isSaved ? primaryBrown : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        final shareText =
                            "${item.book ?? tr('popular_hadith')}\n\n"
                            "${item.hadith}\n\n"
                            "(${item.reference.isNotEmpty ? item.reference : tr('hadith') + ' ' + localizeDigits(item.hadithNo?.toString() ?? 'N/A', context)})\n\n"
                            "Shared via Digital Khanqah App";
                        Share.share(shareText);
                      },
                      child: const Icon(
                        Icons.share_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    // _iconLabel(Icons.volume_up_outlined, tr("listen")),
                    // const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          HadishTafsirDetailsScreen(
                            hadithText: item.hadith,
                            hadithNumber: item.hadithNo?.toString() ?? "N/A",
                            bookName: item.reference.isNotEmpty
                                ? item.reference
                                : "Popular",
                            bookSlug: item.book ?? "popular",
                            chapterNum: item.chapterNo?.toString() ?? "N/A",
                          ),
                        );
                      },
                      child: _iconLabel(
                        Icons.visibility_outlined,
                        tr("full_view"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  // Last Read Hadith List for Screen 3
  Widget _buildLastReadList() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      if (controller.isLastReadLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final lastRead = controller.filteredLastReadHadiths;
      if (lastRead.isEmpty) {
        return Center(child: Text(tr("no_last_read_records")));
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: lastRead.length,
        itemBuilder: (context, index) {
          final item = lastRead[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  item.hadith,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "— ${tr("book_${item.book}_name").contains("book_") ? item.book : tr("book_${item.book}_name")}",
                    style: TextStyle(
                      color: primaryBrown,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 30),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.toggleSaveHadith(
                          hadithText: item.hadith,
                          book: item.book,
                          chapterNo: item.chapterNo ?? "0",
                          hadithNo: item.hadithNo ?? "0",
                          currentlySaved: item.isSaved,
                          savedId: item.savedId,
                        );
                      },
                      child: Icon(
                        item.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        size: 18,
                        color: item.isSaved ? primaryBrown : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        final shareText =
                            "${item.book}\n\n"
                            "${item.hadith}\n\n"
                            "(${tr('hadith')} ${localizeDigits(item.hadithNo ?? 'N/A', context)})\n\n"
                            "Shared via Digital Khanqah App";
                        Share.share(shareText);
                      },
                      child: const Icon(
                        Icons.share_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    // _iconLabel(Icons.volume_up_outlined, tr("listen")),
                    // const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          HadishTafsirDetailsScreen(
                            hadithText: item.hadith,
                            hadithNumber: item.hadithNo ?? "N/A",
                            bookName:
                                tr("book_${item.book}_name").contains("book_")
                                ? item.book
                                : tr("book_${item.book}_name"),
                            bookSlug: item.book,
                            chapterNum: item.chapterNo ?? "N/A",
                          ),
                        );
                      },
                      child: _iconLabel(
                        Icons.visibility_outlined,
                        tr("full_view"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _iconLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _tabButton(String text, int index, {IconData? icon}) {
    bool isSelected = _selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected
                ? primaryBrown
                : isDark
                ? Colors.white
                : Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isSelected
                      ? Colors.white
                      : isDark
                      ? Colors.black
                      : Colors.white,
                ),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isDark
                        ? Colors.black
                        : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderDecoration extends StatelessWidget {
  const HeaderDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF8D3C1F);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          const SizedBox(width: 10),
          const Icon(Icons.circle, size: 4, color: brown),
          const SizedBox(width: 10),
          Text(
            tr("hadith"),
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.circle, size: 4, color: brown),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }
}
