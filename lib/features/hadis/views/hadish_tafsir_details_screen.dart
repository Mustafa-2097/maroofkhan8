import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/features/hadis/controller/hadith_controller.dart';
import 'package:maroofkhan8/features/hadis/models/last_read_hadith.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';
import 'package:share_plus/share_plus.dart';

class HadishTafsirDetailsScreen extends StatefulWidget {
  final String hadithText;
  final String bookName;
  final String chapterNum;
  final String hadithNumber;
  final String? heading;

  const HadishTafsirDetailsScreen({
    super.key,
    required this.hadithText,
    required this.bookName,
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
        book: widget.bookName,
        chapterNo: widget.chapterNum,
        hadithNo: widget.hadithNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          color: const Color(0xFF2E2E2E),
                        ),
                        children: [
                          TextSpan(text: "${widget.bookName}-"),
                          TextSpan(
                            text: "(Chapter-${widget.chapterNum})",
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
                      "${widget.bookName} > Chapter ${widget.chapterNum} > Hadith ${widget.hadithNumber}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color.fromARGB(255, 78, 78, 78),
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
              Row(children: [_tabButton("Tafsir", darkBlack, Colors.white)]),

              const SizedBox(height: 25),

              // --- MAIN HADITH CARD ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
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
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2E2E2E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "${widget.bookName} • Hadith ${widget.hadithNumber}",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color.fromARGB(255, 78, 78, 78),
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
                    _actionIcon(Icons.headphones_outlined, "Listen"),
                    _actionIcon(
                      Icons.auto_awesome_outlined,
                      "AI Explanation",
                      onTap: () {
                        Get.to(() => const ChatScreen());
                      },
                    ),
                    _actionIcon(
                      Icons.share_outlined,
                      "Share",
                      onTap: () {
                        final shareText =
                            "${widget.heading ?? ''}\n\n"
                            "${widget.hadithText}\n\n"
                            "(${widget.bookName}, Hadith ${widget.hadithNumber})\n\n"
                            "Shared via Maroof Khan App";
                        Share.share(shareText);
                      },
                    ),
                    _actionIcon(Icons.download_outlined, "Download"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --- EXPLANATION SECTION ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Simple Explanation",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Explanation not available from API yet.",
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

  Widget _tabButton(String text, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primaryBrown, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: primaryBrown,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
