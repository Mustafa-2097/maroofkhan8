import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/allah_names_controller.dart';
import '../models/allah_name_model.dart';
import 'saved_allah_names_screen.dart';

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
            const HeaderWithLines(title: "99 names of Allah"),
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
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 20,
                          ),
                          hintText: "search...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 8),
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
                _filterButton("All", 0),
                const SizedBox(width: 10),
                _filterButton("With Meaning", 1),
                const SizedBox(width: 10),
                _filterButton("With Audio", 2),
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
                  return const Center(child: Text("No names found"));
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
                        showDialog(
                          context: context,
                          builder: (_) => PlayerDialog(data: nameItem),
                        );
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
                _miniTab("All", false),
                const SizedBox(width: 5),
                _miniTab("With Meaning", false),
                const SizedBox(width: 5),
                _miniTab("With Audio", true),
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
                  children: const [
                    Text(
                      "1:00",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      "2:12",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
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
