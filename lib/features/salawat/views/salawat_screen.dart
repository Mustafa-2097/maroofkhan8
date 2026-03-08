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

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const HeaderSection(title: "Salawat"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Search Bar & Bookmark Icon
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      onChanged: (value) =>
                      controller.searchQuery.value = value,
                      decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Get.to(() => const SavedSalawatScreen()),
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.bookmark_border,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List Items
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredSalawat.isEmpty) {
                  return const Center(child: Text("No items found"));
                }

                return ListView.builder(
                  itemCount: controller.filteredSalawat.length,
                  itemBuilder: (context, index) {
                    final salawat = controller.filteredSalawat[index];
                    return _SalawatListItem(
                      title: salawat.title ?? "Untitled",
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
              child: const Icon(
                Icons.menu_book_outlined,
                color: kPrimaryBrown,
                size: 16,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kTextDark,
                    ),
                  ),
                  if (arabic != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      arabic!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.amiri(fontSize: 12, color: kTextGrey),
                    ),
                  ],
                ],
              ),
            ),
            if (isSaved) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.bookmark,
                color: Color.fromARGB(255, 146, 35, 27),
                size: 16,
              ),
            ],
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_circle_right_outlined,
              color: kPrimaryBrown.withValues(alpha: 0.8),
              size: 22,
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
        setState(() {
          currentSalawat = details;
          isFullDataLoaded = true;
        });
        // Prepare again in case the file URL was only in the details
        controller.prepareAudio(currentSalawat);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const HeaderSection(title: "Salawat"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // children: [
              //   _TabButton(text: "Salawat", isActive: true),
              //   const SizedBox(width: 10),
              //   _TabButton(text: "Translation", isActive: false),
              //   const SizedBox(width: 10),
              //   _TabButton(text: "Tafsir", isActive: false),
              // ],
            ),
            const SizedBox(height: 20),

            // Title Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                currentSalawat.title ?? "Salawat",
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Main Content Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
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
                          size: 20,
                          color: isSaved
                              ? const Color.fromARGB(255, 146, 35, 27)
                              : Colors.grey,
                        ), //
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentSalawat.arabic ?? "ARABIC CONTENT NOT AVAILABLE",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentSalawat.transliteration ??
                        currentSalawat.pronunciation ??
                        "PRONUNCIATION NOT AVAILABLE",
                    style: const TextStyle(
                      fontSize: 12,
                      color: kTextDark,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatDuration(currentPos),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatDuration(totalPos),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: kPrimaryBrown,
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: kPrimaryBrown,
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 4,
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.skip_previous,
                          size: 24,
                          color: Colors.black54,
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
                      const SizedBox(width: 30),
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: 36,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            controller.pauseSalawat();
                          } else {
                            controller.playSalawat(currentSalawat);
                          }
                        },
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                          size: 24,
                          color: Colors.black54,
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
            const SizedBox(height: 25),

            // Action Buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: kPrimaryBrown.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ActionButton(
                    icon: Icons.headset,
                    label: "Listen",
                    isActive: true,
                    onTap: () {
                      // Call play logic if needed or just use current player
                    },
                  ),
                  _VerticalDivider(),
                  _ActionButton(
                    icon: Icons.auto_awesome,
                    label: "AI Explanation",
                    isActive: false,
                    onTap: () {
                      Get.to(() => const ChatScreen());
                    },
                  ),
                  _VerticalDivider(),
                  _ActionButton(
                    icon: Icons.share_outlined,
                    label: "Share",
                    isActive: false,
                    onTap: () => controller.shareSalawat(currentSalawat),
                  ),
                  _VerticalDivider(),
                  _ActionButton(
                    icon: Icons.download_outlined,
                    label: "Download",
                    isActive: false,
                    onTap: () => controller.downloadSalawat(currentSalawat),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Meaning Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Meaning:",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryBrown,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    currentSalawat.translation ??
                        currentSalawat.meaning ??
                        "MEANING NOT AVAILABLE",
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: kTextDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isActive ? kPrimaryBrown : Colors.black),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? kPrimaryBrown : Colors.black,
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
    return Container(height: 25, width: 1, color: Colors.grey.shade300);
  }
}

///////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
// AppBar _buildAppBar(BuildContext context) {
//   return AppBar(
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     leading: Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GestureDetector(
//         onTap: () {
//           if (Navigator.canPop(context)) Navigator.pop(context);
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
//         ),
//       ),
//     ),
//     centerTitle: true,
//     title: Text(
//       "Salawat",
//       style: GoogleFonts.playfairDisplay(
//         color: Colors.black,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//     ),
//   );
// }