import 'package:easy_localization/easy_localization.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/salawat/views/saved_salawat_screen.dart';
import '../controller/salawat_controller.dart';
import '../model/salawat_model.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(0xFF1E120D);
const Color kBackground = Color(0xFFF9F9FB);
const Color kCardColor = Colors.white;
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

// ==========================================
// SCREEN 1: SALAWAT LIST
// ==========================================
class SalawatListScreen extends StatelessWidget {
  const SalawatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SalawatController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("salawat")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white70 : Colors.grey,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
        child: Column(
          children: [
            SizedBox(height: sh * 0.015),
            // Search Bar & Bookmark Icon
            Row(
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
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: TextField(
                      onChanged: (value) =>
                          controller.searchQuery.value = value,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: tr("search_hint"),
                        hintStyle: TextStyle(
                          fontSize: sw * 0.035,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: sh * 0.015),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sw * 0.03),
                GestureDetector(
                  onTap: () => Get.to(() => const SavedSalawatScreen()),
                  child: Container(
                    height: sh * 0.055,
                    width: sh * 0.055,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                      ),
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
            SizedBox(height: sh * 0.025),

            // List Items
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryBrown),
                  );
                }
                if (controller.filteredSalawat.isEmpty) {
                  return Center(
                    child: Text(
                      tr("no_items_found"),
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : kTextGrey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: sh * 0.02),
                  itemCount: controller.filteredSalawat.length,
                  itemBuilder: (context, index) {
                    final salawat = controller.filteredSalawat[index];
                    return _SalawatListItem(
                      title: tr(salawat.title ?? "untitled"),
                      arabic: salawat.arabic,
                      isSaved: salawat.isSaved ?? false,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SalawatDetailScreen(salawat: salawat),
                        ),
                      ),
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
}

class _SalawatListItem extends StatelessWidget {
  final String title;
  final String? arabic;
  final bool isSaved;
  final VoidCallback onTap;

  const _SalawatListItem({
    required this.title,
    this.arabic,
    required this.isSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: sh * 0.018),
        padding: EdgeInsets.symmetric(
          vertical: sh * 0.025,
          horizontal: sw * 0.04,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryBrown, width: 1.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.menu_book_outlined,
                color: kPrimaryBrown,
                size: sw * 0.04,
              ),
            ),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: sw * 0.038,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : kTextDark,
                    ),
                  ),
                  if (arabic != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      arabic!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.amiri(
                        fontSize: sw * 0.035,
                        color: isDark ? Colors.grey[400] : kTextGrey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSaved) ...[
              SizedBox(width: sw * 0.02),
              Icon(
                Icons.bookmark,
                color: const Color.fromARGB(255, 146, 35, 27),
                size: sw * 0.045,
              ),
            ],
            SizedBox(width: sw * 0.02),
            Icon(
              Icons.arrow_circle_right_outlined,
              color: kPrimaryBrown.withOpacity(0.8),
              size: sw * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2: SALAWAT DETAIL / PLAYER
// ==========================================
class SalawatDetailScreen extends StatefulWidget {
  final SalawatData salawat;
  const SalawatDetailScreen({super.key, required this.salawat});

  @override
  State<SalawatDetailScreen> createState() => _SalawatDetailScreenState();
}

class _SalawatDetailScreenState extends State<SalawatDetailScreen> {
  final controller = Get.find<SalawatController>();
  late SalawatData currentSalawat;
  bool isFullDataLoaded = false;

  @override
  void initState() {
    super.initState();
    currentSalawat = widget.salawat;
    controller.prepareAudio(currentSalawat);
    _loadFullData();
  }

  @override
  void dispose() {
    controller.stopSalawat();
    super.dispose();
  }

  Future<void> _loadFullData() async {
    if (currentSalawat.id != null) {
      final details = await controller.fetchSalawatDetails(currentSalawat.id!);
      if (details != null) {
        if (mounted) {
          setState(() {
            currentSalawat = details;
            isFullDataLoaded = true;
          });
        }
        controller.prepareAudio(currentSalawat);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("salawat")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white70 : Colors.grey,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sw * 0.05),
        child: Column(
          children: [
            SizedBox(height: sh * 0.01),

            // Title Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: sh * 0.02,
                horizontal: sw * 0.03,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                tr(currentSalawat.title ?? "salawat"),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: sw * 0.045,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            SizedBox(height: sh * 0.025),

            // Main Content Card
            Container(
              padding: EdgeInsets.all(sw * 0.06),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Obx(() {
                      final controllerSalawat =
                          controller.salawatList.firstWhereOrNull(
                            (s) => s.id == currentSalawat.id,
                          ) ??
                          controller.salawatList.firstWhereOrNull(
                            (s) => s.title == currentSalawat.title,
                          );
                      final isSaved =
                          controllerSalawat?.isSaved ??
                          currentSalawat.isSaved ??
                          false;

                      return GestureDetector(
                        onTap: () => controller.toggleBookmark(currentSalawat),
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          size: sw * 0.055,
                          color: isSaved
                              ? const Color.fromARGB(255, 146, 35, 27)
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentSalawat.arabic ?? tr("arabic_content_not_available"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      fontSize: sw * 0.065,
                      fontWeight: FontWeight.bold,
                      height: 1.8,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: sh * 0.025),
                  Text(
                    currentSalawat.transliteration ??
                        currentSalawat.pronunciation ??
                        tr("pronunciation_not_available"),
                    style: TextStyle(
                      fontSize: sw * 0.035,
                      color: isDark ? Colors.grey[400] : kTextDark,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.03),

            // Audio Player
            Obx(() {
              final isPlaying =
                  controller.playerState.value == PlayerState.playing &&
                  controller.currentPlayingSalawatId.value == currentSalawat.id;
              final currentPos = controller.currentDuration.value;
              final totalPos = controller.totalDuration.value;

              String formatDuration(Duration d) {
                String twoDigits(int n) => n.toString().padLeft(2, "0");
                String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
                String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
                return "$twoDigitMinutes:$twoDigitSeconds";
              }

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDuration(currentPos),
                          style: TextStyle(
                            fontSize: sw * 0.03,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[400] : Colors.black,
                          ),
                        ),
                        Text(
                          formatDuration(totalPos),
                          style: TextStyle(
                            fontSize: sw * 0.03,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[400] : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: kPrimaryBrown,
                      inactiveTrackColor: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      thumbColor: kPrimaryBrown,
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: totalPos.inMilliseconds > 0
                          ? currentPos.inMilliseconds / totalPos.inMilliseconds
                          : 0.0,
                      onChanged: (v) {
                        final newPos = Duration(
                          milliseconds: (v * totalPos.inMilliseconds).toInt(),
                        );
                        controller.seekSalawat(newPos);
                      },
                    ),
                  ),
                  SizedBox(height: sh * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          size: sw * 0.07,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        onPressed: () {
                          final prev = controller.getPreviousSalawat(
                            currentSalawat,
                          );
                          if (prev != null) {
                            setState(() {
                              currentSalawat = prev;
                              isFullDataLoaded = false;
                            });
                            _loadFullData();
                            controller.playSalawat(prev);
                          }
                        },
                      ),
                      SizedBox(width: sw * 0.08),
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: sw * 0.12,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            controller.pauseSalawat();
                          } else {
                            controller.playSalawat(currentSalawat);
                          }
                        },
                      ),
                      SizedBox(width: sw * 0.08),
                      IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          size: sw * 0.07,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        onPressed: () {
                          final next = controller.getNextSalawat(
                            currentSalawat,
                          );
                          if (next != null) {
                            setState(() {
                              currentSalawat = next;
                              isFullDataLoaded = false;
                            });
                            _loadFullData();
                            controller.playSalawat(next);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            }),
            SizedBox(height: sh * 0.035),

            // Action Buttons
            Container(
              padding: EdgeInsets.symmetric(
                vertical: sh * 0.015,
                horizontal: sw * 0.02,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: kPrimaryBrown.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // _ActionButton(
                  //   icon: Icons.headset,
                  //   label: tr("listen"),
                  //   isActive: true,
                  //   onTap: () {},
                  // ),
                  _VerticalDivider(),
                  _ActionButton(
                    icon: Icons.auto_awesome,
                    label: tr("ai_explanation"),
                    isActive: false,
                    onTap: () {
                      Get.to(() => const ChatScreen());
                    },
                  ),
                  _VerticalDivider(),
                  _ActionButton(
                    icon: Icons.share_outlined,
                    label: tr("share"),
                    isActive: false,
                    onTap: () => controller.shareSalawat(currentSalawat),
                  ),
                  _VerticalDivider(),
                  _ActionButton(
                    icon: Icons.download_outlined,
                    label: tr("download"),
                    isActive: false,
                    onTap: () => controller.downloadSalawat(currentSalawat),
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.03),

            // Meaning Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(sw * 0.05),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr("meaning_colon"),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: sw * 0.04,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentSalawat.translation ??
                        currentSalawat.meaning ??
                        tr("meaning_not_available"),
                    style: TextStyle(
                      fontSize: sw * 0.035,
                      height: 1.5,
                      color: isDark ? Colors.grey[300] : kTextDark,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.05),
          ],
        ),
      ),
    );
  }
}

// --- HELPER WIDGETS ---

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: sw * 0.045,
            color: isActive
                ? kPrimaryBrown
                : (isDark ? Colors.white70 : Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: sw * 0.025,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? kPrimaryBrown
                  : (isDark ? Colors.white70 : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 25,
      width: 1,
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
    );
  }
}
