import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import '../controller/ahle_bait_controller.dart';
import '../model/ahle_bait_model.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';
import 'package:share_plus/share_plus.dart';

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

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const HeaderSection(title: "Ahle Bait  أهل البيت"),
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
                    color: Colors.black87,
                  ),
                  children: [
                    const TextSpan(
                      text: "refers to the household and family members of ",
                    ),
                    // TextSpan(
                    //   text: "أهل البيت",
                    //   style: GoogleFonts.amiri(fontWeight: FontWeight.bold),
                    // ),
                    const TextSpan(text: "\nProphet Muhammad"),
                  ],
                ),
              ),
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
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryBrown),
                    );
                  }
                  if (controller.filteredAhlalbaytList.isEmpty) {
                    return const Center(
                      child: Text(
                        "No records found",
                        style: TextStyle(color: kTextGrey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.filteredAhlalbaytList.length,
                    itemBuilder: (context, index) {
                      final item = controller.filteredAhlalbaytList[index];
                      return _ahleBaitCard(context, item);
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

  Widget _ahleBaitCard(BuildContext context, AhleBait item) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AhleBaitDetailScreen(item: item));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
              backgroundColor: Colors.grey.shade200,
              child: item.image.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
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
    return Scaffold(
      backgroundColor: kBackground,
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
                  radius: 50,
                  backgroundImage: member.image.isNotEmpty
                      ? NetworkImage(member.image)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                  child: member.image.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 15),
                Text(
                  member.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Custom Tab Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tabButton("Biography", 0),
                    const SizedBox(width: 10),
                    _tabButton("Story", 1),
                    const SizedBox(width: 10),
                    _tabButton("Quotes", 2),
                  ],
                ),
                const SizedBox(height: 20),

                // Content Handling
                if (_currentTab == 0) _buildBiographySection(member),
                if (_currentTab == 1) _buildStoryPlayerSection(member),
                if (_currentTab == 2) _buildQuotesSection(member),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _tabButton(String text, int index) {
    bool isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
  }

  // --- TAB CONTENT 1: BIOGRAPHY ---
  Widget _buildBiographySection(AhleBait member) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Biography",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              _bioRow("Name :", member.name),
              _bioRow("Relation :", member.relation),
              _bioRow("Born :", member.dateOfBirth ?? "N/A"),
              _bioRow("Died :", member.dateOfDeath ?? "N/A"),
              _bioRow("Position :", member.position ?? "N/A"),
              _bioRow("Institution :", member.institution ?? "N/A"),
              _bioRow("Works :", member.work ?? "N/A"),
              _bioRow("Known For :", member.knownFor ?? "N/A"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bioRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB CONTENT 2: STORY / PLAYER ---
  Widget _buildStoryPlayerSection(AhleBait member) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Story",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        // Text Content Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.bookmark_border,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
              Text(
                (member.story != null && member.story!.trim().isNotEmpty)
                    ? member.story!
                    : "The full story for ${member.name} will be added here once it is available in the database.",
                textAlign: TextAlign.left,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Audio Player
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "00:00",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  "00:00",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: kPrimaryBrown,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: kPrimaryBrown,
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(value: 0.0, onChanged: (v) {}),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.skip_previous, size: 24, color: Colors.black),
            SizedBox(width: 30),
            Icon(Icons.play_circle_outline, size: 35, color: Colors.black),
            SizedBox(width: 30),
            Icon(Icons.skip_next, size: 24, color: Colors.black),
          ],
        ),
        const SizedBox(height: 30),

        // Bottom Actions Pill
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: kPrimaryBrown.withValues(alpha: 0.5)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomAction(Icons.headset, "Listen", true),
              Container(height: 30, width: 1, color: Colors.grey.shade300),
              _bottomAction(
                Icons.auto_awesome,
                "AI Explanation",
                false,
                onTap: () {
                  Get.to(() => const ChatScreen());
                },
              ),
              Container(height: 30, width: 1, color: Colors.grey.shade300),
              _bottomAction(
                Icons.share_outlined,
                "Share",
                false,
                onTap: () {
                  final shareText =
                      "${member.name}\n\n"
                      "Relation: ${member.relation}\n"
                      "Born: ${member.dateOfBirth ?? 'N/A'}\n"
                      "Died: ${member.dateOfDeath ?? 'N/A'}\n\n"
                      "Shared via Maroof Khan App";
                  Share.share(shareText);
                },
              ),
              Container(height: 30, width: 1, color: Colors.grey.shade300),
              _bottomAction(Icons.download_outlined, "Download", false),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildQuotesSection(AhleBait member) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quotes",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        if (member.quotes == null || member.quotes!.isEmpty)
          const Center(
            child: Text(
              "Quotes coming soon...",
              style: TextStyle(color: kTextGrey),
            ),
          )
        else
          ...member.quotes!.map((quote) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quote.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
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
    bool isActive, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: isActive ? kPrimaryBrown : Colors.black),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isActive ? kPrimaryBrown : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
