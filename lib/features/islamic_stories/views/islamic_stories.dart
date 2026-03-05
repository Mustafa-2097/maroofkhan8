import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import '../controller/islamic_stories_controller.dart';
import '../models/islamic_story.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(0xFF1E120D);
const Color kBackground = Color(0xFFF9F9FB);
const Color kCardColor = Colors.white;
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class IslamicStoriesScreen extends StatelessWidget {
  final bool hideBack;
  const IslamicStoriesScreen({super.key, this.hideBack = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IslamicStoriesController());

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const HeaderSection(title: "Islamic Stories"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: hideBack
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Header Text
              // Text(
              //   "Islamic Stories",
              //   style: GoogleFonts.amiri(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  onChanged: (val) => controller.searchQuery.value = val,
                  decoration: const InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // List Items
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.filteredStories.isEmpty) {
                    return const Center(child: Text("No stories available."));
                  }
                  return ListView.builder(
                    itemCount: controller.filteredStories.length,
                    itemBuilder: (context, index) {
                      final story = controller.filteredStories[index];
                      return _ahleBaitCard(context, story);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ahleBaitCard(BuildContext context, IslamicStory story) {
    return GestureDetector(
      onTap: () {
        Get.to(() => IslamicStoriesDetailScreen(story: story));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(story.image),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    story.subtitle,
                    style: const TextStyle(fontSize: 11, color: kTextGrey),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: kPrimaryBrown,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16,
              ),
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
class IslamicStoriesDetailScreen extends StatefulWidget {
  final IslamicStory story;
  const IslamicStoriesDetailScreen({super.key, required this.story});

  @override
  State<IslamicStoriesDetailScreen> createState() =>
      _IslamicStoriesDetailScreenState();
}

class _IslamicStoriesDetailScreenState
    extends State<IslamicStoriesDetailScreen> {
  final controller = IslamicStoriesController.instance;

  @override
  void initState() {
    super.initState();
    controller.fetchStoryDetails(widget.story.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const HeaderSection(title: "Islamic Stories"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = controller.storyDetail.value;
        if (detail == null) {
          return const Center(child: Text("Failed to load story details."));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Title Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Text(
                  detail.title,
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
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      // child: Icon(
                      //   Icons.favorite_border,
                      //   size: 20,
                      //   color: Colors.grey,
                      // ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      detail.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: kTextDark,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Action Buttons
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: kPrimaryBrown.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ActionButton(
                      icon: Icons.headset,
                      label: "Listen",
                      isActive: true,
                      onTap: () {
                        // TODO: Implement listen functionality
                      },
                    ),
                    _ActionButton(
                      icon: Icons.auto_awesome,
                      label: "AI Explanation",
                      isActive: false,
                      onTap: () {
                        Get.to(() => const ChatScreen());
                      },
                    ),
                    _ActionButton(
                      icon: Icons.share_outlined,
                      label: "Share",
                      isActive: false,
                      onTap: () {
                        Share.share("${detail.title}\n\n${detail.description}");
                      },
                    ),
                    _ActionButton(
                      icon: Icons.copy,
                      label: "Copy",
                      isActive: false,
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: detail.description),
                        );
                        Get.snackbar(
                          "Copied",
                          "Story copied to clipboard",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color.fromARGB(
                            255,
                            65,
                            131,
                            2,
                          ),
                          colorText: Colors.white,
                        );
                      },
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
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Simple Explanation:",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryBrown,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "This story teaches us about faith and values in Islam.",
                      style: TextStyle(
                        fontSize: 14,
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
        );
      }),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    this.onTap,
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isActive ? kPrimaryBrown : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// AppBar _buildAppBar(BuildContext context) {
//   return AppBar(
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     leading: IconButton(
//       icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
//       onPressed: () {
//         if (Navigator.canPop(context)) Navigator.pop(context);
//       },
//     ),
//     centerTitle: true,
//     title: Text(
//       "Islamic Stories",
//       style: GoogleFonts.playfairDisplay(
//         color: Colors.black,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//     ),
//   );
// }
