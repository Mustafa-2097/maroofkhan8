import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import '../controller/sahaba_controller.dart';
import '../model/sahaba_model.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';
import 'package:share_plus/share_plus.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(
  0xFF1E120D,
); // Darker brown/black for inactive tabs
const Color kBackground = Color(0xFFFDFDFD);
const Color kTextGrey = Color(0xFF757575);

// ==========================================
// SCREEN 1: SAHABA LIST
// ==========================================
class SahabaListScreen extends StatefulWidget {
  final bool hideBack;
  const SahabaListScreen({super.key, this.hideBack = false});

  @override
  State<SahabaListScreen> createState() => _SahabaListScreenState();
}

class _SahabaListScreenState extends State<SahabaListScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SahabaController());

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: HeaderSection(title: "Sahaba"),
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
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text(
      //     "Sahaba",
      //     style: GoogleFonts.playfairDisplay(
      //       color: Colors.black,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   leading: GestureDetector(
      //     onTap: () => Get.back(),
      //     child: const Icon(Icons.chevron_left, color: Colors.black),
      //   ),
      //   actions: const [
      //     Icon(Icons.more_horiz, color: Colors.transparent),
      //   ], // Spacing
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
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
                if (controller.filteredSahabaList.isEmpty) {
                  return const Center(child: Text("No records found"));
                }
                return ListView.builder(
                  itemCount: controller.filteredSahabaList.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredSahabaList[index];
                    return _sahabaCard(context, item);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sahabaCard(BuildContext context, Sahaba item) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SahabaDetailScreen(sahaba: item));
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 11, color: kTextGrey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
// SCREEN 2, 3, 4: DETAIL TABS (Bio, Teachings, Quotes)
// ==========================================
class SahabaDetailScreen extends StatefulWidget {
  final Sahaba sahaba;
  const SahabaDetailScreen({super.key, required this.sahaba});

  @override
  State<SahabaDetailScreen> createState() => _SahabaDetailScreenState();
}

class _SahabaDetailScreenState extends State<SahabaDetailScreen> {
  final SahabaController controller = Get.find<SahabaController>();
  int _currentTab = 0; // 0: Bio, 1: Teachings, 2: Quotes

  @override
  void initState() {
    super.initState();
    controller.selectedSahaba.value = null;
    controller.fetchSahabaDetails(widget.sahaba.id);
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

          final sahaba = controller.selectedSahaba.value ?? widget.sahaba;

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
                  backgroundImage: sahaba.image.isNotEmpty
                      ? NetworkImage(sahaba.image)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                  child: sahaba.image.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 15),
                Text(
                  sahaba.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  sahaba.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // Custom Tab Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tabButton("Biography", 0),
                    const SizedBox(width: 10),
                    _tabButton("Teachings", 1),
                    const SizedBox(width: 10),
                    _tabButton("Quotes", 2),
                  ],
                ),
                const SizedBox(height: 20),

                // Dynamic Content
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _getTabTitle(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                _buildTabBody(sahaba),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getTabTitle() {
    switch (_currentTab) {
      case 1:
        return "His Teachings";
      case 2:
        return "His Quotes";
      default:
        return "Biography";
    }
  }

  Widget _buildTabBody(Sahaba sahaba) {
    switch (_currentTab) {
      case 1:
        return _contentListTab(sahaba.teachings, "Teachings");
      case 2:
        return _contentListTab(sahaba.quotes, "Quotes", isQuote: true);
      default:
        return _buildBiographyContent(sahaba);
    }
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

  // --- TAB 1: BIOGRAPHY ---
  Widget _buildBiographyContent(Sahaba sahaba) {
    return Container(
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
          _bioRow("Name :", sahaba.name),
          _bioRow("Born :", sahaba.dateOfBirth ?? "N/A"),
          _bioRow("Died :", sahaba.dateOfDeath ?? "N/A"),
          _bioRow("Position :", sahaba.position ?? "N/A"),
          _bioRow("Institution :", sahaba.institution ?? "N/A"),
          _bioRow("Works :", sahaba.works ?? "N/A"),
          _bioRow("Known For :", sahaba.knownFor ?? "N/A"),
        ],
      ),
    );
  }

  Widget _bioRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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

  Widget _contentListTab(
    List<SahabaContentItem>? items,
    String type, {
    bool isQuote = false,
  }) {
    if (items == null || items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Information about $type will be updated soon.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: items
          .map(
            (item) => _ExpandableContentCard(
              title: item.title,
              desc: item.description,
              isQuote: isQuote,
            ),
          )
          .toList(),
    );
  }
}

class _ExpandableContentCard extends StatefulWidget {
  final String title;
  final String desc;
  final bool isQuote;

  const _ExpandableContentCard({
    required this.title,
    required this.desc,
    this.isQuote = false,
  });

  @override
  State<_ExpandableContentCard> createState() => _ExpandableContentCardState();
}

class _ExpandableContentCardState extends State<_ExpandableContentCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final textStyle = TextStyle(
                fontSize: 11,
                color: kTextGrey,
                height: 1.5,
                fontStyle: widget.isQuote ? FontStyle.italic : FontStyle.normal,
              );

              // Use TextPainter to check if it exceeds 5 lines
              final span = TextSpan(text: widget.desc, style: textStyle);
              final tp = TextPainter(
                text: span,
                maxLines: 5,
                textDirection: TextDirection.ltr,
              );
              tp.layout(maxWidth: constraints.maxWidth);

              final bool hasMoreThanFiveLines = tp.didExceedMaxLines;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.desc,
                    maxLines: isExpanded ? null : 5,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                  if (hasMoreThanFiveLines) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryBrown,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isExpanded ? "Read Less" : "Read More",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 5: AUDIO PLAYER / LESSON DETAILS
// ==========================================
class SahabaAudioScreen extends StatelessWidget {
  final Sahaba sahaba;
  const SahabaAudioScreen({super.key, required this.sahaba});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Profile Header
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 50,
                backgroundImage: sahaba.image.isNotEmpty
                    ? NetworkImage(sahaba.image)
                    : null,
                backgroundColor: Colors.grey.shade200,
                child: sahaba.image.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 15),
              Text(
                sahaba.name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                sahaba.title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),

              // Filter Tabs (Darker theme here per image)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _actionTab("His Teaches", true),
                  const SizedBox(width: 8),
                  _actionTab("Translation", false),
                  const SizedBox(width: 8),
                  _actionTab("Tafsir", false),
                ],
              ),
              const SizedBox(height: 25),

              // White Content Card
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
                      "Lessons and Contributions",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryBrown,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      sahaba.works ?? "Contributions information coming soon.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      sahaba.knownFor ?? "Known for information coming soon.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: kTextGrey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        "00:00",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "00:00",
                        style: TextStyle(
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
                      trackHeight: 2,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 4,
                      ),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(value: 0.0, onChanged: (v) {}),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Play Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.skip_previous, size: 24, color: Colors.black),
                  SizedBox(width: 30),
                  Icon(
                    Icons.play_circle_outline,
                    size: 35,
                    color: Colors.black,
                  ),
                  SizedBox(width: 30),
                  Icon(Icons.skip_next, size: 24, color: Colors.black),
                ],
              ),
              const SizedBox(height: 30),

              // Bottom Action Buttons
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: kPrimaryBrown.withValues(alpha: 0.5),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomAction(Icons.headset, "Listen", true),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _bottomAction(
                      Icons.auto_awesome,
                      "AI Explanation",
                      false,
                      onTap: () {
                        Get.to(() => const ChatScreen());
                      },
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _bottomAction(
                      Icons.share_outlined,
                      "Share",
                      false,
                      onTap: () {
                        final shareText =
                            "${sahaba.name}\n\n"
                            "Biography: ${sahaba.name}\n"
                            "Born: ${sahaba.dateOfBirth ?? 'N/A'}\n"
                            "Died: ${sahaba.dateOfDeath ?? 'N/A'}\n\n"
                            "Shared via Maroof Khan App";
                        Share.share(shareText);
                      },
                    ),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    _bottomAction(Icons.download_outlined, "Download", false),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionTab(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? kPrimaryBrown : kDarkButton,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
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
              fontSize: 8,
              color: isActive ? kPrimaryBrown : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
