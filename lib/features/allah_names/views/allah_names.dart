import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import '../controllers/allah_names_controller.dart';
import '../models/allah_name_model.dart';
import 'saved_allah_names_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(0xFF2E1C15);

class NamesOfAllahScreen extends StatefulWidget {
  const NamesOfAllahScreen({super.key});

  @override
  State<NamesOfAllahScreen> createState() => _NamesOfAllahScreenState();
}

class _NamesOfAllahScreenState extends State<NamesOfAllahScreen> {
  final controller = Get.put(AllahNamesController());

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF9F9FC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: HeaderSection(title: tr("names_99")),
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: sh * 0.012),

            // 1. Header
            //HeaderWithLines(title: tr("names_99")),
            SizedBox(height: sh * 0.025),

            // 2. Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: sh * 0.055,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: TextField(
                        onChanged: controller.updateSearchQuery,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: sw * 0.05,
                          ),
                          hintText: "${tr("search")}...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: sw * 0.035,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(top: 8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: sw * 0.025),
                  GestureDetector(
                    onTap: () => Get.to(() => const SavedAllahNamesScreen()),
                    child: Container(
                      height: sh * 0.055,
                      width: sh * 0.055,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
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
            ),
            SizedBox(height: sh * 0.025),

            // 3. Filter Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _filterButton(tr("all"), 0),
                SizedBox(width: sw * 0.025),
                _filterButton(tr("with_audio"), 2),
              ],
            ),
            SizedBox(height: sh * 0.025),

            // 4. Grid of Names
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryBrown),
                  );
                }

                final displayedNames = controller.filteredNamesList;

                if (displayedNames.isEmpty) {
                  return Center(
                    child: Text(
                      tr("no_names_found"),
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.black,
                      ),
                    ),
                  );
                }

                if (controller.selectedFilterIndex.value == 2) {
                  final audioIdx = controller.currentAudioIndex.value;
                  final safeIdx = audioIdx < displayedNames.length
                      ? audioIdx
                      : 0;
                  return AudioPlayerSection(
                    controller: controller,
                    data: displayedNames[safeIdx],
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: sw * 0.05,
                    vertical: 10,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: sw * 0.04,
                    mainAxisSpacing: sh * 0.018,
                  ),
                  itemCount: displayedNames.length,
                  itemBuilder: (context, index) {
                    final nameItem = displayedNames[index];
                    return NameCard(
                      data: nameItem,
                      onTap: () {
                        controller.isPlayingFromSaved.value = false;
                        controller.currentAudioIndex.value = index;
                        controller.selectedFilterIndex.value = 2;
                      },
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

  Widget _filterButton(String text, int index) {
    return Obx(() {
      final sw = MediaQuery.of(context).size.width;
      final sh = MediaQuery.of(context).size.height;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      bool isActive = controller.selectedFilterIndex.value == index;
      return GestureDetector(
        onTap: () {
          controller.isPlayingFromSaved.value = false;
          controller.updateFilterIndex(index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: sw * 0.05,
            vertical: sh * 0.01,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? kPrimaryBrown
                : (isDark ? const Color(0xFF1E1E1E) : kDarkButton),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.transparent,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: sw * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }
}

// --- AUDIO PLAYER SECTION ---
class AudioPlayerSection extends StatelessWidget {
  final AllahNamesController controller;
  final AllahName data;

  const AudioPlayerSection({
    super.key,
    required this.controller,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(sw * 0.05),
      child: Column(
        children: [
          SizedBox(height: sh * 0.012),
          // Large White Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(sw * 0.05),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Align(
                //   alignment: Alignment.topRight,
                //   child: Icon(
                //     Icons.volume_up_outlined,
                //     color: isDark ? Colors.white38 : Colors.grey.shade400,
                //     size: sw * 0.06,
                //   ),
                // ),
                SizedBox(height: sh * 0.012),
                Text(
                  data.arabic,
                  style: GoogleFonts.amiri(
                    fontSize: sw * 0.12,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: sh * 0.018),
                Text(
                  data.pronunciation,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: sw * 0.065,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2E2E2E),
                  ),
                ),
                Text(
                  data.meaning,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: sw * 0.045,
                    color: isDark ? Colors.grey[400] : Colors.grey.shade400,
                  ),
                ),
                SizedBox(height: sh * 0.035),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () => controller.toggleSaveName(data),
                    child: Icon(
                      data.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      size: sw * 0.065,
                      color: data.isSaved
                          ? kPrimaryBrown
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: sh * 0.06),

          // Slider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.025),
            child: Obx(() {
              bool isCurrent = controller.currentPlayingId.value == data.id;
              double currentPos = isCurrent
                  ? controller.position.value.inSeconds.toDouble()
                  : 0.0;
              double totalDuration = isCurrent
                  ? controller.duration.value.inSeconds.toDouble()
                  : 0.0;
              if (totalDuration < currentPos) totalDuration = currentPos;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizeDigits(
                          controller.formatDuration(
                            isCurrent
                                ? controller.position.value
                                : Duration.zero,
                          ),
                          context,
                        ),
                        style: TextStyle(
                          fontSize: sw * 0.03,
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                      Text(
                        localizeDigits(
                          controller.formatDuration(
                            isCurrent
                                ? controller.duration.value
                                : Duration.zero,
                          ),
                          context,
                        ),
                        style: TextStyle(
                          fontSize: sw * 0.03,
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.006),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: kPrimaryBrown,
                      inactiveTrackColor: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                      thumbColor: kPrimaryBrown,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: sw * 0.015,
                      ),
                      trackHeight: 3,
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(
                      value: currentPos,
                      max: totalDuration > 0 ? totalDuration : 1.0,
                      onChanged: (v) {
                        if (isCurrent) {
                          controller.seekAudio(v);
                        }
                      },
                    ),
                  ),
                ],
              );
            }),
          ),

          SizedBox(height: sh * 0.045),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: controller.previousAudio,
                icon: Icon(Icons.skip_previous_outlined, size: sw * 0.088),
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              SizedBox(width: sw * 0.075),
              Obx(() {
                bool isCurrentPlaying =
                    controller.currentPlayingId.value == data.id &&
                    controller.isPlaying.value;
                return GestureDetector(
                  onTap: () => controller.playNameAudio(data),
                  child: Icon(
                    isCurrentPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: sw * 0.138,
                    color: isDark ? Colors.white : const Color(0xFF2E2E2E),
                  ),
                );
              }),
              SizedBox(width: sw * 0.075),
              IconButton(
                onPressed: controller.nextAudio,
                icon: Icon(Icons.skip_next_outlined, size: sw * 0.088),
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- NAME CARD WIDGET ---
class NameCard extends StatelessWidget {
  final AllahName data;
  final VoidCallback onTap;

  const NameCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(sw * 0.03),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Top Row: Bookmark, Arabic Name, Speaker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.find<AllahNamesController>().toggleSaveName(data);
                  },
                  child: Icon(
                    data.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    size: sw * 0.05,
                    color: data.isSaved
                        ? kPrimaryBrown
                        : (isDark ? Colors.white70 : Colors.black87),
                  ),
                ),
                Expanded(
                  child: Text(
                    data.arabic,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      fontSize: sw * 0.045,
                      fontWeight: FontWeight.bold,
                      height: 1,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Obx(() {
                  final controller = Get.find<AllahNamesController>();
                  bool isCurrentPlaying =
                      controller.currentPlayingId.value == data.id &&
                      controller.isPlaying.value;
                  return GestureDetector(
                    onTap: () => controller.playNameAudio(data),
                    child: Icon(
                      isCurrentPlaying
                          ? Icons.pause_circle_outline
                          : Icons.volume_up_outlined,
                      size: sw * 0.05,
                      color: isCurrentPlaying ? kPrimaryBrown : Colors.grey,
                    ),
                  );
                }),
              ],
            ),

            // Middle & Bottom: Pronunciation & Meaning
            Column(
              children: [
                Text(
                  data.pronunciation,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: sw * 0.05,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF2E2E2E),
                  ),
                ),
                Text(
                  data.meaning,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: sw * 0.035,
                    color: isDark ? Colors.grey[400] : Colors.grey.shade400,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- PLAYER DIALOG (SCREEN 3) ---
class PlayerDialog extends StatelessWidget {
  const PlayerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AllahNamesController>();
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final list = controller.activeList;
      if (list.isEmpty) return const SizedBox();
      final index = controller.currentAudioIndex.value;
      final safeIdx = index < list.length ? index : 0;
      final data = list[safeIdx];

      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.all(sw * 0.05),
        child: Container(
          padding: EdgeInsets.all(sw * 0.05),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9FC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: sh * 0.035),

              // Large White Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: sh * 0.035,
                  horizontal: sw * 0.05,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF252525) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.volume_up_outlined,
                        color: Colors.grey,
                        size: sw * 0.05,
                      ),
                    ),
                    Text(
                      data.arabic,
                      style: GoogleFonts.amiri(
                        fontSize: sw * 0.08,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: sh * 0.012),
                    Text(
                      data.pronunciation,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: sw * 0.055,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      data.meaning,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: sw * 0.035,
                        color: isDark
                            ? Colors.grey[400]
                            : const Color(0xFF757575),
                      ),
                    ),
                    SizedBox(height: sh * 0.025),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () => controller.toggleSaveName(data),
                        child: Icon(
                          data.isSaved ? Icons.bookmark : Icons.bookmark_border,
                          size: sw * 0.055,
                          color: data.isSaved
                              ? kPrimaryBrown
                              : (isDark ? Colors.white70 : Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sh * 0.035),

              // Slider
              Obx(() {
                bool isCurrent = controller.currentPlayingId.value == data.id;
                double currentPos = isCurrent
                    ? controller.position.value.inSeconds.toDouble()
                    : 0.0;
                double totalDuration = isCurrent
                    ? controller.duration.value.inSeconds.toDouble()
                    : 0.0;
                if (totalDuration < currentPos) totalDuration = currentPos;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizeDigits(
                            controller.formatDuration(
                              isCurrent
                                  ? controller.position.value
                                  : Duration.zero,
                            ),
                            context,
                          ),
                          style: TextStyle(
                            fontSize: sw * 0.025,
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                        ),
                        Text(
                          localizeDigits(
                            controller.formatDuration(
                              isCurrent
                                  ? controller.duration.value
                                  : Duration.zero,
                            ),
                            context,
                          ),
                          style: TextStyle(
                            fontSize: sw * 0.025,
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: kPrimaryBrown,
                        inactiveTrackColor: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                        thumbColor: kPrimaryBrown,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: sw * 0.012,
                        ),
                        trackHeight: 2,
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Slider(
                        value: currentPos,
                        max: totalDuration > 0 ? totalDuration : 1.0,
                        onChanged: (v) {
                          if (isCurrent) {
                            controller.seekAudio(v);
                          }
                        },
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: sh * 0.025),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.previousAudio();
                    },
                    icon: Icon(Icons.skip_previous_outlined, size: sw * 0.07),
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  SizedBox(width: sw * 0.075),
                  Obx(() {
                    bool isCurrentPlaying =
                        controller.currentPlayingId.value == data.id &&
                        controller.isPlaying.value;
                    return GestureDetector(
                      onTap: () => controller.playNameAudio(data),
                      child: Icon(
                        isCurrentPlaying
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        size: sw * 0.1,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    );
                  }),
                  SizedBox(width: sw * 0.075),
                  IconButton(
                    onPressed: () {
                      controller.nextAudio();
                    },
                    icon: Icon(Icons.skip_next_outlined, size: sw * 0.07),
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ],
              ),
              SizedBox(height: sh * 0.012),
            ],
          ),
        ),
      );
    });
  }
}

// --- SHARED HEADER ---
// class HeaderWithLines extends StatelessWidget {
//   final String title;
//   const HeaderWithLines({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     final sw = MediaQuery.of(context).size.width;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: sw * 0.1,
//                 height: 1,
//                 color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//               ),
//               const SizedBox(width: 5),
//               const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: GoogleFonts.playfairDisplay(
//                   fontSize: sw * 0.045,
//                   fontWeight: FontWeight.w600,
//                   color: isDark ? Colors.white : const Color(0xFF2E2E2E),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
//               const SizedBox(width: 5),
//               Container(
//                 width: sw * 0.1,
//                 height: 1,
//                 color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
//               ),
//             ],
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: isDark ? Colors.white70 : Colors.grey,
//                 size: sw * 0.05,
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
