import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/allah_names_controller.dart';
import '../models/allah_name_model.dart';
import 'saved_allah_names_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(0xFF2E1C15);
const Color kBackground = Color(0xFFF9F9FC);
const Color kTextGrey = Color(0xFF757575);

class NamesOfAllahScreen extends StatefulWidget {
  const NamesOfAllahScreen({super.key});

  @override
  State<NamesOfAllahScreen> createState() => _NamesOfAllahScreenState();
}

class _NamesOfAllahScreenState extends State<NamesOfAllahScreen> {
  final controller = Get.put(AllahNamesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 1. Header
            HeaderWithLines(title: tr("names_99")),
            const SizedBox(height: 20),

            // 2. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        onChanged: controller.updateSearchQuery,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 20,
                          ),
                          hintText: "${tr("search")}...",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(top: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.to(() => const SavedAllahNamesScreen()),
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
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
            ),
            const SizedBox(height: 20),

            // 3. Filter Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _filterButton(tr("all"), 0),
                const SizedBox(width: 10),
                // _filterButton("With Meaning", 1),
                // const SizedBox(width: 10),
                _filterButton(tr("with_audio"), 2),
              ],
            ),
            const SizedBox(height: 20),

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
                  return Center(child: Text(tr("no_names_found")));
                }

                if (controller.selectedFilterIndex.value == 2) {
                  final audioIdx = controller.currentAudioIndex.value;
                  // Guard against index out of bounds
                  final safeIdx = audioIdx < displayedNames.length
                      ? audioIdx
                      : 0;
                  return AudioPlayerSection(
                    controller: controller,
                    data: displayedNames[safeIdx],
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: displayedNames.length,
                  itemBuilder: (context, index) {
                    final nameItem = displayedNames[index];
                    return NameCard(
                      data: nameItem,
                      onTap: () {
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
      bool isActive = controller.selectedFilterIndex.value == index;
      return GestureDetector(
        onTap: () {
          controller.updateFilterIndex(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? kPrimaryBrown : kDarkButton,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Large White Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.volume_up_outlined,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
                ),
                Text(
                  data.arabic,
                  style: GoogleFonts.amiri(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  data.pronunciation,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
                Text(
                  data.meaning,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () => controller.toggleSaveName(data),
                    child: Icon(
                      data.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      size: 26,
                      color: data.isSaved ? kPrimaryBrown : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // Slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizeDigits("1:00", context),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      localizeDigits("2:12", context),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: kPrimaryBrown,
                    inactiveTrackColor: Colors.grey.shade300,
                    thumbColor: kPrimaryBrown,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    trackHeight: 3,
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(value: 0.45, onChanged: (v) {}),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: controller.previousAudio,
                icon: const Icon(Icons.skip_previous_outlined, size: 35),
                color: Colors.black87,
              ),
              const SizedBox(width: 30),
              const Icon(
                Icons
                    .play_circle_filled, // Filled for play look consistent with screenshot
                size: 55,
                color: Color(0xFF2E2E2E),
              ),
              const SizedBox(width: 30),
              IconButton(
                onPressed: controller.nextAudio,
                icon: const Icon(Icons.skip_next_outlined, size: 35),
                color: Colors.black87,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                    size: 20,
                    color: data.isSaved ? kPrimaryBrown : Colors.black87,
                  ),
                ),
                Expanded(
                  child: Text(
                    data.arabic,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: const Icon(
                    Icons.volume_up_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            // Middle & Bottom: Pronunciation & Meaning
            // Padding(
            //    padding: const EdgeInsets.only(top: 10),
            //   child:
            Column(
              children: [
                Text(
                  data.pronunciation,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
                Text(
                  data.meaning,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    height: 1.2,
                  ),
                ),
              ],
            ),

            // ),
            //const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

// --- PLAYER DIALOG (SCREEN 3) ---
class PlayerDialog extends StatelessWidget {
  final AllahName data;

  const PlayerDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _miniTab(tr("all"), false),
                const SizedBox(width: 5),
                _miniTab(tr("with_meaning"), false),
                const SizedBox(width: 5),
                _miniTab(tr("with_audio"), true),
              ],
            ),
            const SizedBox(height: 30),

            // Large White Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.volume_up_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  Text(
                    data.arabic,
                    style: GoogleFonts.amiri(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data.pronunciation,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data.meaning,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: kTextGrey),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      data.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      size: 22,
                      color: data.isSaved ? kPrimaryBrown : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Slider
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localizeDigits("1:00", context),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      localizeDigits("2:12", context),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: kPrimaryBrown,
                    inactiveTrackColor: Colors.grey.shade300,
                    thumbColor: kPrimaryBrown,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                    trackHeight: 2,
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(value: 0.45, onChanged: (v) {}),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.skip_previous_outlined,
                  size: 28,
                  color: Colors.black87,
                ),
                SizedBox(width: 30),
                Icon(Icons.play_circle_outline, size: 40, color: Colors.black),
                SizedBox(width: 30),
                Icon(Icons.skip_next_outlined, size: 28, color: Colors.black87),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _miniTab(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? kPrimaryBrown : kDarkButton,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}

// --- SHARED HEADER ---
class HeaderWithLines extends StatelessWidget {
  final String title;
  const HeaderWithLines({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 40, height: 1, color: Colors.grey.shade300),
              const SizedBox(width: 5),
              const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E2E2E),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
              const SizedBox(width: 5),
              Container(width: 40, height: 1, color: Colors.grey.shade300),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
