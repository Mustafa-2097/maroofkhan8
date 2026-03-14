import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import '../controller/ahle_bait_controller.dart';
import '../model/ahle_bait_model.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';
import '../../profile/controller/profile_controller.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(0xFF1E120D); // Dark text/button color
const Color kBackground = Color(0xFFFDFDFD);
const Color kTextGrey = Color(0xFF757575);

// ==========================================
// SCREEN 1: AHLE BAIT LIST SCREEN
// ==========================================
class AhleBaitListScreen extends StatefulWidget {
  final bool hideBack;
  const AhleBaitListScreen({super.key, this.hideBack = false});

  @override
  State<AhleBaitListScreen> createState() => _AhleBaitListScreenState();
}

class _AhleBaitListScreenState extends State<AhleBaitListScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AhleBaitController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("ahle_bait_title")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.hideBack
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const SizedBox(height: 5),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  children: [TextSpan(text: tr("ahle_bait_desc"))],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  ),
                ),
                child: TextField(
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  onChanged: (val) => controller.searchQuery.value = val,
                  decoration: InputDecoration(
                    hintText: tr("search"),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // List Items
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryBrown),
                    );
                  }
                  if (controller.filteredAhlalbaytList.isEmpty) {
                    return Center(
                      child: Text(
                        tr("no_records_found"),
                        style: const TextStyle(color: kTextGrey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.filteredAhlalbaytList.length,
                    itemBuilder: (context, index) {
                      final item = controller.filteredAhlalbaytList[index];
                      return _ahleBaitCard(context, item, isDark);
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

  Widget _ahleBaitCard(BuildContext context, AhleBait item, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AhleBaitDetailScreen(item: item));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: item.image.isNotEmpty
                  ? NetworkImage(item.image)
                  : null,
              backgroundColor: isDark
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
              child: item.image.isEmpty
                  ? Icon(
                      Icons.person,
                      color: isDark ? Colors.grey.shade400 : Colors.grey,
                    )
                  : null,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.relation,
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
// SCREEN 2 & 3: DETAIL SCREEN (Tabs)
// ==========================================
class AhleBaitDetailScreen extends StatefulWidget {
  final AhleBait item;
  const AhleBaitDetailScreen({super.key, required this.item});

  @override
  State<AhleBaitDetailScreen> createState() => _AhleBaitDetailScreenState();
}

class _AhleBaitDetailScreenState extends State<AhleBaitDetailScreen> {
  int _currentTab = 0; // 0: Bio, 1: Story, 2: Quotes/Translation
  final AhleBaitController controller = Get.find<AhleBaitController>();

  @override
  void initState() {
    super.initState();
    controller.selectedMember.value = null;
    controller.fetchMemberDetails(widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryBrown),
            );
          }

          final member = controller.selectedMember.value ?? widget.item;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),

                // Profile Header
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 85,
                  backgroundImage: member.image.isNotEmpty
                      ? NetworkImage(member.image)
                      : null,
                  backgroundColor: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  child: member.image.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                        )
                      : null,
                ),
                const SizedBox(height: 15),
                Text(
                  member.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Custom Tab Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tabButton(tr("biography"), 0, isDark),
                    const SizedBox(width: 10),
                    _tabButton(tr("story"), 1, isDark),
                    const SizedBox(width: 10),
                    _tabButton(tr("quotes"), 2, isDark),
                  ],
                ),
                const SizedBox(height: 20),

                // Content Handling
                if (_currentTab == 0) _buildBiographySection(member, isDark),
                if (_currentTab == 1) _buildStoryPlayerSection(member, isDark),
                if (_currentTab == 2) _buildQuotesSection(member, isDark),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _tabButton(String text, int index, bool isDark) {
    bool isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? kPrimaryBrown
              : (isDark ? Colors.grey.shade800 : kDarkButton),
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
  }

  // --- TAB CONTENT 1: BIOGRAPHY ---
  Widget _buildBiographySection(AhleBait member, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr("biography"),
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              _bioRow(tr("label_name"), member.name, isDark),
              _bioRow(tr("label_relation"), member.relation, isDark),
              _bioRow(
                tr("label_born"),
                localizeDigits(
                  member.dateOfBirth ?? tr("not_available"),
                  context,
                ),
                isDark,
              ),
              _bioRow(
                tr("label_died"),
                localizeDigits(
                  member.dateOfDeath ?? tr("not_available"),
                  context,
                ),
                isDark,
              ),
              _bioRow(
                tr("label_position"),
                member.position ?? tr("not_available"),
                isDark,
              ),
              _bioRow(
                tr("label_institution"),
                member.institution ?? tr("not_available"),
                isDark,
              ),
              _bioRow(
                tr("label_works"),
                member.work ?? tr("not_available"),
                isDark,
              ),
              _bioRow(
                tr("label_known_for"),
                member.knownFor ?? tr("not_available"),
                isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bioRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB CONTENT 2: STORY / PLAYER ---
  Widget _buildStoryPlayerSection(AhleBait member, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr("story"),
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        // Text Content Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.bookmark_border,
                  size: 20,
                  color: isDark ? Colors.white54 : Colors.grey,
                ),
              ),
              Text(
                (member.story != null && member.story!.trim().isNotEmpty)
                    ? member.story!
                    : tr("story_placeholder", args: [member.name]),
                textAlign: TextAlign.left,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Audio Player
        // Column(
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           localizeDigits("00:00", context),
        //           style: const TextStyle(
        //             fontSize: 10,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         Text(
        //           localizeDigits("00:00", context),
        //           style: const TextStyle(
        //             fontSize: 10,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //     SliderTheme(
        //       data: SliderTheme.of(context).copyWith(
        //         activeTrackColor: kPrimaryBrown,
        //         inactiveTrackColor: Colors.grey.shade300,
        //         thumbColor: kPrimaryBrown,
        //         trackHeight: 2,
        //         thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
        //         overlayShape: SliderComponentShape.noOverlay,
        //       ),
        //       child: Slider(value: 0.0, onChanged: (v) {}),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 20),

        // Controls
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: const [
        //     Icon(Icons.skip_previous, size: 24, color: Colors.black),
        //     SizedBox(width: 30),
        //     Icon(Icons.play_circle_outline, size: 35, color: Colors.black),
        //     SizedBox(width: 30),
        //     Icon(Icons.skip_next, size: 24, color: Colors.black),
        //   ],
        // ),
        // const SizedBox(height: 30),

        // Bottom Actions Pill
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: kPrimaryBrown.withValues(alpha: 0.5)),
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // _bottomAction(Icons.headset, tr("listen"), true, isDark),
              // Container(height: 30, width: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
              _bottomAction(
                Icons.auto_awesome,
                tr("ai_explanation"),
                false,
                isDark,
                onTap: () {
                  Get.to(() => const ChatScreen());
                },
              ),
              Container(
                height: 30,
                width: 1,
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
              _bottomAction(
                Icons.share_outlined,
                tr("share"),
                false,
                isDark,
                onTap: () {
                  final shareText =
                      "${member.name}\n\n"
                      "Relation: ${member.relation}\n"
                      "Born: ${member.dateOfBirth ?? 'N/A'}\n"
                      "Died: ${member.dateOfDeath ?? 'N/A'}\n\n"
                      "${tr("shared_via")}";
                  Share.share(shareText);
                },
              ),
              Container(
                height: 30,
                width: 1,
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
              _bottomAction(
                Icons.download_outlined,
                tr("download"),
                false,
                isDark,
                onTap: () {
                  ProfileController.instance.handleDownloadAction(() {
                    // Actual download logic or success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${tr("download_complete")} - ${member.name}"),
                        backgroundColor: kPrimaryBrown,
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildQuotesSection(AhleBait member, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr("quotes"),
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        if (member.quotes == null || member.quotes!.isEmpty)
          Center(
            child: Text(
              tr("quotes_coming_soon"),
              style: const TextStyle(color: kTextGrey),
            ),
          )
        else
          ...member.quotes!.map((quote) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quote.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black54,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _bottomAction(
    IconData icon,
    String label,
    bool isActive,
    bool isDark, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive
                ? kPrimaryBrown
                : (isDark ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isActive
                  ? kPrimaryBrown
                  : (isDark ? Colors.white : Colors.black),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
