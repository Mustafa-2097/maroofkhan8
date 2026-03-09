import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';
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
    context.locale;
    final controller = Get.put(IslamicStoriesController());
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("islamic_stories")),
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
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
          child: Column(
            children: [
              // const SizedBox(height: 10),
              SizedBox(height: sh * 0.012),

              // Header Text
              // Text(
              //   "Islamic Stories",
              //   style: GoogleFonts.amiri(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
              // const SizedBox(height: 20),
              SizedBox(height: sh * 0.025),

              // Search Bar
              Container(
                // height: 45,
                height: sh * 0.055,
                // padding: const EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: sw * 0.025),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  onChanged: (val) => controller.searchQuery.value = val,
                  decoration: InputDecoration(
                    hintText: tr("search_stories"),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    // contentPadding: EdgeInsets.only(bottom: 8),
                    contentPadding: EdgeInsets.only(bottom: sh * 0.01),
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              SizedBox(height: sh * 0.025),

              // List Items
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.filteredStories.isEmpty) {
                    return Center(child: Text(tr("no_stories_available")));
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
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Get.to(() => IslamicStoriesDetailScreen(story: story));
      },
      child: Container(
        // margin: const EdgeInsets.only(bottom: 15),
        // padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: sh * 0.018),
        padding: EdgeInsets.all(sw * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(15),
          borderRadius: BorderRadius.circular(sw * 0.04),
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
              // radius: 28,
              radius: sw * 0.07,
              backgroundImage: NetworkImage(story.image),
              backgroundColor: Colors.grey.shade200,
            ),
            // const SizedBox(width: 15),
            SizedBox(width: sw * 0.035),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: GoogleFonts.playfairDisplay(
                      // fontSize: 16,
                      fontSize: sw * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  SizedBox(height: sh * 0.005),
                  Text(
                    story.subtitle,
                    // style: const TextStyle(fontSize: 11, color: kTextGrey),
                    style: TextStyle(fontSize: sw * 0.03, color: kTextGrey),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Container(
              // height: 30,
              // width: 30,
              height: sw * 0.08,
              width: sw * 0.08,
              decoration: BoxDecoration(
                color: kPrimaryBrown,
                // borderRadius: BorderRadius.circular(8),
                borderRadius: BorderRadius.circular(sw * 0.02),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                // size: 16,
                size: sw * 0.04,
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
    context.locale;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("islamic_stories")),
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
          return Center(child: Text(tr("failed_load_story")));
        }

        return SingleChildScrollView(
          // padding: const EdgeInsets.all(20),
          padding: EdgeInsets.all(sw * 0.05),
          child: Column(
            children: [
              // const SizedBox(height: 20),
              SizedBox(height: sh * 0.025),

              // Title Banner
              Container(
                width: double.infinity,
                // padding: const EdgeInsets.symmetric(
                //   vertical: 15,
                //   horizontal: 10,
                // ),
                padding: EdgeInsets.symmetric(
                  vertical: sh * 0.018,
                  horizontal: sw * 0.025,
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
                    // fontSize: 14,
                    fontSize: sw * 0.038,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              SizedBox(height: sh * 0.025),

              // Main Content Card
              Container(
                // padding: const EdgeInsets.all(20),
                padding: EdgeInsets.all(sw * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(15),
                  borderRadius: BorderRadius.circular(sw * 0.04),
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
                      style: TextStyle(
                        // fontSize: 14,
                        fontSize: sw * 0.035,
                        color: kTextDark,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 25),
              SizedBox(height: sh * 0.03),

              // Action Buttons
              Container(
                // padding: const EdgeInsets.symmetric(
                //   vertical: 12,
                //   horizontal: 10,
                // ),
                padding: EdgeInsets.symmetric(
                  vertical: sh * 0.015,
                  horizontal: sw * 0.025,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(30),
                  borderRadius: BorderRadius.circular(sw * 0.08),
                  border: Border.all(color: kPrimaryBrown.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // _ActionButton(
                    //   icon: Icons.headset,
                    //   label: tr("listen"),
                    //   isActive: true,
                    //   onTap: () {
                    //     // TODO: Implement listen functionality
                    //   },
                    // ),
                    _ActionButton(
                      icon: Icons.auto_awesome,
                      label: tr("ai_explanation"),
                      isActive: false,
                      onTap: () {
                        Get.to(() => const ChatScreen());
                      },
                    ),
                    _ActionButton(
                      icon: Icons.share_outlined,
                      label: tr("share"),
                      isActive: false,
                      onTap: () {
                        Share.share("${detail.title}\n\n${detail.description}");
                      },
                    ),
                    _ActionButton(
                      icon: Icons.copy,
                      label: tr("copy"),
                      isActive: false,
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: detail.description),
                        );
                        Get.snackbar(
                          tr("copied"),
                          tr("story_copied"),
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
              // const SizedBox(height: 20),
              SizedBox(height: sh * 0.025),

              // Meaning Card
              Container(
                width: double.infinity,
                // padding: const EdgeInsets.all(20),
                padding: EdgeInsets.all(sw * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(15),
                  borderRadius: BorderRadius.circular(sw * 0.04),
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
                      tr("simple_explanation_colon"),
                      style: GoogleFonts.playfairDisplay(
                        // fontSize: 14,
                        fontSize: sw * 0.035,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryBrown,
                      ),
                    ),
                    // const SizedBox(height: 5),
                    SizedBox(height: sh * 0.006),
                    Text(
                      tr("story_teachings_placeholder"),
                      style: TextStyle(
                        // fontSize: 14,
                        fontSize: sw * 0.035,
                        height: 1.4,
                        color: kTextDark,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 30),
              SizedBox(height: sh * 0.035),
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
    final sw = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(icon, size: 18, color: isActive ? kPrimaryBrown : Colors.black),
          Icon(
            icon,
            size: sw * 0.045,
            color: isActive ? kPrimaryBrown : Colors.black,
          ),
          // const SizedBox(height: 4),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          Text(
            label,
            style: TextStyle(
              // fontSize: 14,
              fontSize: sw * 0.032,
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
