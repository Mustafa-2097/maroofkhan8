import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import '../controller/sahaba_controller.dart';
import '../model/sahaba_model.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(0xFF1E120D);

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
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: HeaderSection(title: tr("sahaba_title")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.hideBack
            ? null
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? Colors.white70 : Colors.grey,
                  size: sw * 0.05,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
        child: Column(
          children: [
            // Search Bar
            Container(
              height: sh * 0.055,
              padding: EdgeInsets.symmetric(horizontal: sw * 0.025),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                ),
              ),
              child: TextField(
                onChanged: (val) => controller.searchQuery.value = val,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  hintText: tr("search"),
                  hintStyle: TextStyle(
                    fontSize: sw * 0.035,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: sh * 0.012),
                ),
              ),
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
                if (controller.filteredSahabaList.isEmpty) {
                  return Center(
                    child: Text(
                      tr("no_records_found"),
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.black,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: sh * 0.02),
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
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Get.to(() => SahabaDetailScreen(sahaba: item));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: sh * 0.018),
        padding: EdgeInsets.all(sw * 0.03),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: sw * 0.07,
              backgroundImage: item.image.isNotEmpty
                  ? NetworkImage(item.image)
                  : null,
              backgroundColor: isDark
                  ? Colors.grey.shade900
                  : Colors.grey.shade200,
              child: item.image.isEmpty
                  ? Icon(
                      Icons.person,
                      color: isDark ? Colors.white38 : Colors.grey,
                      size: sw * 0.07,
                    )
                  : null,
            ),
            SizedBox(width: sw * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: sw * 0.038,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: sw * 0.028,
                      color: isDark
                          ? Colors.grey[400]
                          : const Color(0xFF757575),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              height: sw * 0.075,
              width: sw * 0.075,
              decoration: BoxDecoration(
                color: kPrimaryBrown,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
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
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryBrown),
            );
          }

          final sahaba = controller.selectedSahaba.value ?? widget.sahaba;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: 10),
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: isDark ? Colors.white70 : Colors.grey,
                      size: sw * 0.05,
                    ),
                  ),
                ),

                // Profile Header
                SizedBox(height: sh * 0.012),
                CircleAvatar(
                  radius: sw * 0.125,
                  backgroundImage: sahaba.image.isNotEmpty
                      ? NetworkImage(sahaba.image)
                      : null,
                  backgroundColor: isDark
                      ? Colors.grey.shade900
                      : Colors.grey.shade200,
                  child: sahaba.image.isEmpty
                      ? Icon(
                          Icons.person,
                          size: sw * 0.125,
                          color: isDark ? Colors.white38 : Colors.grey,
                        )
                      : null,
                ),
                SizedBox(height: sh * 0.018),
                Text(
                  sahaba.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: sw * 0.05,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  sahaba.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: sw * 0.04,
                    color: isDark ? Colors.grey[400] : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: sh * 0.025),

                // Custom Tab Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tabButton(tr("biography"), 0),
                    SizedBox(width: sw * 0.025),
                    _tabButton(tr("teachings"), 1),
                    SizedBox(width: sw * 0.025),
                    _tabButton(tr("quotes"), 2),
                  ],
                ),
                SizedBox(height: sh * 0.025),

                // Dynamic Content
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _getTabTitle(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: sw * 0.045,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.018),

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
        return tr("his_teachings");
      case 2:
        return tr("his_quotes");
      default:
        return tr("biography");
    }
  }

  Widget _buildTabBody(Sahaba sahaba) {
    switch (_currentTab) {
      case 1:
        return _contentListTab(sahaba.teachings, tr("teachings"));
      case 2:
        return _contentListTab(sahaba.quotes, tr("quotes"), isQuote: true);
      default:
        return _buildBiographyContent(sahaba);
    }
  }

  Widget _tabButton(String text, int index) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sw * 0.04,
          vertical: sh * 0.01,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? kPrimaryBrown
              : (isDark ? const Color(0xFF1E1E1E) : kDarkButton),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.grey.shade900 : Colors.transparent,
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
  }

  // --- TAB 1: BIOGRAPHY ---
  Widget _buildBiographyContent(Sahaba sahaba) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(sw * 0.05),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _bioRow(tr("label_name"), sahaba.name),
          _bioRow(
            tr("label_born"),
            localizeDigits(sahaba.dateOfBirth ?? tr("not_available"), context),
          ),
          _bioRow(
            tr("label_died"),
            localizeDigits(sahaba.dateOfDeath ?? tr("not_available"), context),
          ),
          _bioRow(tr("label_position"), sahaba.position ?? tr("not_available")),
          _bioRow(
            tr("label_institution"),
            sahaba.institution ?? tr("not_available"),
          ),
          _bioRow(tr("label_works"), sahaba.works ?? tr("not_available")),
          _bioRow(
            tr("label_known_for"),
            sahaba.knownFor ?? tr("not_available"),
          ),
        ],
      ),
    );
  }

  Widget _bioRow(String label, String value) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: sw * 0.2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: sw * 0.03,
                color: isDark ? Colors.white70 : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: sw * 0.03,
                color: isDark ? Colors.grey[400] : Colors.black87,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (items == null || items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            tr("info_updated_soon", args: [type]),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
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
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: sh * 0.018),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              fontSize: sw * 0.035,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: sh * 0.01),
          LayoutBuilder(
            builder: (context, constraints) {
              final textStyle = TextStyle(
                fontSize: sw * 0.028,
                color: isDark ? Colors.grey[400] : const Color(0xFF757575),
                height: 1.5,
                fontStyle: widget.isQuote ? FontStyle.italic : FontStyle.normal,
              );

              // Use TextPainter to check if it exceeds 5 lines
              final span = TextSpan(text: widget.desc, style: textStyle);
              final tp = TextPainter(
                text: span,
                maxLines: 5,
                textDirection: Directionality.of(context),
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
                    SizedBox(height: sh * 0.012),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: sw * 0.03,
                            vertical: sh * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryBrown,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isExpanded ? tr("read_less") : tr("read_more"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: sw * 0.025,
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
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDFDFD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: 10),
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
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade900
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: isDark ? Colors.white70 : Colors.grey,
                      size: sw * 0.05,
                    ),
                  ),
                ),
              ),

              // Profile Header
              SizedBox(height: sh * 0.012),
              CircleAvatar(
                radius: sw * 0.125,
                backgroundImage: sahaba.image.isNotEmpty
                    ? NetworkImage(sahaba.image)
                    : null,
                backgroundColor: isDark
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
                child: sahaba.image.isEmpty
                    ? Icon(
                        Icons.person,
                        size: sw * 0.125,
                        color: isDark ? Colors.white38 : Colors.grey,
                      )
                    : null,
              ),
              SizedBox(height: sh * 0.018),
              Text(
                sahaba.name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: sw * 0.05,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                sahaba.title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: sw * 0.04,
                  color: isDark ? Colors.grey[400] : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: sh * 0.025),

              // Filter Tabs (Darker theme here per image)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _actionTab(context, tr("his_teaches"), true),
                  SizedBox(width: sw * 0.02),
                  _actionTab(context, tr("translation"), false),
                  SizedBox(width: sw * 0.02),
                  _actionTab(context, tr("tafsir"), false),
                ],
              ),
              SizedBox(height: sh * 0.03),

              // White Content Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(sw * 0.05),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
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
                        size: sw * 0.05,
                        color: isDark ? Colors.white38 : Colors.grey,
                      ),
                    ),
                    Text(
                      tr("lessons_contributions"),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: sw * 0.04,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryBrown,
                      ),
                    ),
                    SizedBox(height: sh * 0.012),
                    Text(
                      sahaba.works ?? tr("contributions_placeholder"),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: sw * 0.035,
                        color: isDark ? Colors.white70 : Colors.black,
                      ),
                    ),
                    SizedBox(height: sh * 0.018),
                    Text(
                      sahaba.knownFor ?? tr("known_for_placeholder"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: sw * 0.03,
                        color: isDark
                            ? Colors.grey[400]
                            : const Color(0xFF757575),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: sh * 0.035),

              // Slider
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizeDigits("00:00", context),
                        style: TextStyle(
                          fontSize: sw * 0.025,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black,
                        ),
                      ),
                      Text(
                        localizeDigits("00:00", context),
                        style: TextStyle(
                          fontSize: sw * 0.025,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black,
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
                      trackHeight: 2,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: sw * 0.01,
                      ),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: Slider(value: 0.0, onChanged: (v) {}),
                  ),
                ],
              ),
              SizedBox(height: sh * 0.025),

              // Play Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.skip_previous,
                    size: sw * 0.06,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: sw * 0.075),
                  Icon(
                    Icons.play_circle_outline,
                    size: sw * 0.088,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: sw * 0.075),
                  Icon(
                    Icons.skip_next,
                    size: sw * 0.06,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ],
              ),
              SizedBox(height: sh * 0.035),

              // Bottom Action Buttons
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: sh * 0.015,
                  horizontal: sw * 0.04,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: kPrimaryBrown.withOpacity(0.5)),
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomAction(context, Icons.headset, tr("listen"), true),
                    Container(
                      height: sh * 0.035,
                      width: 1,
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                    ),
                    _bottomAction(
                      context,
                      Icons.auto_awesome,
                      tr("ai_explanation"),
                      false,
                      onTap: () {
                        Get.to(() => const ChatScreen());
                      },
                    ),
                    Container(
                      height: sh * 0.035,
                      width: 1,
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                    ),
                    _bottomAction(
                      context,
                      Icons.share_outlined,
                      tr("share"),
                      false,
                      onTap: () {
                        final shareText =
                            "${sahaba.name}\n\n"
                            "Biography: ${sahaba.name}\n"
                            "Born: ${sahaba.dateOfBirth ?? 'N/A'}\n"
                            "Died: ${sahaba.dateOfDeath ?? 'N/A'}\n\n"
                            "${tr("shared_via")}";
                        Share.share(shareText);
                      },
                    ),
                    Container(
                      height: sh * 0.035,
                      width: 1,
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade300,
                    ),
                    _bottomAction(
                      context,
                      Icons.download_outlined,
                      tr("download"),
                      false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: sh * 0.025),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionTab(BuildContext context, String text, bool isActive) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? kPrimaryBrown
            : (isDark ? const Color(0xFF1E1E1E) : kDarkButton),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade900 : Colors.transparent,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: sw * 0.028,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _bottomAction(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive, {
    VoidCallback? onTap,
  }) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: sw * 0.05,
            color: isActive
                ? kPrimaryBrown
                : (isDark ? Colors.white38 : Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: sw * 0.02,
              color: isActive
                  ? kPrimaryBrown
                  : (isDark ? Colors.white38 : Colors.black),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
