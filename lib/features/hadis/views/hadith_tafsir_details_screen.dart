import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/features/hadis/controller/hadith_controller.dart';
import 'package:maroofkhan8/features/hadis/models/last_read_hadith.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

class HadishTafsirDetailsScreen extends StatefulWidget {
  final String hadithText;
  final String bookName;
  final String bookSlug;
  final String chapterNum;
  final String hadithNumber;
  final String? heading;

  const HadishTafsirDetailsScreen({
    super.key,
    required this.hadithText,
    required this.bookName,
    required this.bookSlug,
    required this.chapterNum,
    required this.hadithNumber,
    this.heading,
  });

  @override
  State<HadishTafsirDetailsScreen> createState() =>
      _HadishTafsirDetailsScreenState();
}

class _HadishTafsirDetailsScreenState extends State<HadishTafsirDetailsScreen> {
  final Color primaryBrown = const Color(0xFF8D3C1F);
  final Color darkBlack = const Color(0xFF1E120D);

  @override
  void initState() {
    super.initState();
    _trackLastRead();
  }

  void _trackLastRead() {
    HadithController.instance.updateLastReadHadith(
      LastReadHadith(
        hadith: widget.hadithText,
        book: widget.bookSlug,
        chapterNo: widget.chapterNum,
        hadithNo: widget.hadithNumber,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      // Icons.chevron_left,
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF2E2E2E),
                        ),
                        children: [
                          TextSpan(text: "${widget.bookName}-"),
                          TextSpan(
                            text:
                                "(${tr('chapters')}-${localizeDigits(widget.chapterNum, context)})",
                            style: TextStyle(color: primaryBrown),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance back button
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "${widget.bookName} > ${tr('chapters')} ${localizeDigits(widget.chapterNum, context)} > ${tr('hadith')} ${localizeDigits(widget.hadithNumber, context)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.grey.shade500
                            : const Color.fromARGB(255, 78, 78, 78),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Obx(() {
                    final isSaved = HadithController.instance.isHadithSaved(
                      widget.hadithText,
                    );
                    final sId = HadithController.instance.getSavedId(
                      widget.hadithText,
                    );

                    return GestureDetector(
                      onTap: () {
                        HadithController.instance.toggleSaveHadith(
                          hadithText: widget.hadithText,
                          book: widget.bookName,
                          chapterNo: widget.chapterNum,
                          hadithNo: widget.hadithNumber,
                          currentlySaved: isSaved,
                          savedId: sId,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          size: 18,
                          color: isSaved ? Color(0xFF8D3C1F) : Colors.grey,
                        ),
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 20),

              // --- TABS ---
              Row(children: [_tabButton(tr("tafsir"), true)]),

              const SizedBox(height: 25),

              // --- MAIN HADITH CARD ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Obx(() {
                    //   final isSaved = HadithController.instance.isHadithSaved(
                    //     widget.hadithText,
                    //   );
                    //   final sId = HadithController.instance.getSavedId(
                    //     widget.hadithText,
                    //   );

                    //   return GestureDetector(
                    //     onTap: () {
                    //       HadithController.instance.toggleSaveHadith(
                    //         hadithText: widget.hadithText,
                    //         book: widget.bookName,
                    //         chapterNo: widget.chapterNum,
                    //         hadithNo: widget.hadithNumber,
                    //         currentlySaved: isSaved,
                    //         savedId: sId,
                    //       );
                    //     },
                    //     child: Align(
                    //       alignment: Alignment.topRight,
                    //       child: Icon(
                    //         isSaved ? Icons.favorite : Icons.favorite_border,
                    //         color: isSaved
                    //             ? Colors.red
                    //             : const Color(0xFF2E2E2E),
                    //         size: 20,
                    //       ),
                    //     ),
                    //   );
                    // }),
                    if (widget.heading != null &&
                        widget.heading!.isNotEmpty) ...[
                      Text(
                        widget.heading!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryBrown,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                    Text(
                      widget.hadithText,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF2E2E2E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "${widget.bookName} • ${tr('hadith')} ${localizeDigits(widget.hadithNumber, context)}",
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? Colors.grey.shade500
                              : const Color.fromARGB(255, 78, 78, 78),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --- ACTION BAR ---
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryBrown.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // _actionIcon(Icons.headphones_outlined, tr("listen")),
                    _actionIcon(
                      Icons.auto_awesome_outlined,
                      tr("ai_explanation"),
                      onTap: () {
                        Get.to(() => const ChatScreen());
                      },
                    ),
                    _actionIcon(
                      Icons.share_outlined,
                      tr("share"),
                      onTap: () {
                        final shareText =
                            "${widget.heading ?? ''}\n\n"
                            "${widget.hadithText}\n\n"
                            "(${widget.bookName}, ${tr('hadith')} ${localizeDigits(widget.hadithNumber, context)})\n\n"
                            "Shared via Maroof Khan App";
                        Share.share(shareText);
                      },
                    ),
                    /* Obx(() {
                      final key = "${widget.bookSlug}_${widget.hadithNumber}";
                      final isDownloading =
                          HadithController.instance.isDownloadingHadith[key] ?? false;
                      final isDownloaded =
                          HadithController.instance.downloadedHadiths.containsKey(key);

                      if (isDownloading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF8D3C1F),
                            ),
                          ),
                        );
                      }

                      if (isDownloaded) {
                        return _actionIcon(
                          Icons.delete_outline,
                          tr("remove"),
                          color: Colors.red,
                          onTap: () {
                            HadithController.instance.deleteDownloadedHadith(
                              widget.bookSlug,
                              widget.hadithNumber,
                            );
                          },
                        );
                      }

                      return _actionIcon(
                        Icons.download_outlined,
                        tr("download"),
                        onTap: () {
                          HadithController.instance.downloadHadith(
                            hadithText: widget.hadithText,
                            bookSlug: widget.bookSlug,
                            bookName: widget.bookName,
                            chapterNum: widget.chapterNum,
                            hadithNumber: widget.hadithNumber,
                            heading: widget.heading,
                          );
                        },
                      );
                    }), */
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --- EXPLANATION SECTION ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr("simple_explanation"),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      tr("no_explanation_available"),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 150), // For scroll room
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String label, bool isSelected) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? primaryBrown
              : isDark
              ? Colors.white
              : Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isDark
                ? Colors.black
                : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, String label, {VoidCallback? onTap, Color? color}) {
    final effectiveColor = color ?? primaryBrown;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: effectiveColor, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: effectiveColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
