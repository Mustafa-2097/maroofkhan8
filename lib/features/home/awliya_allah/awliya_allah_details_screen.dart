import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/awliya_allah_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';
import 'controllers/awliya_allah_controller.dart';

class AwliyaAllahDetailsScreen extends StatefulWidget {
  final AwliyaAllah awliya;
  const AwliyaAllahDetailsScreen({super.key, required this.awliya});

  @override
  State<AwliyaAllahDetailsScreen> createState() =>
      _AwliyaAllahDetailsScreenState();
}

class _AwliyaAllahDetailsScreenState extends State<AwliyaAllahDetailsScreen> {
  final Color primaryBrown = const Color(0xFF8D3C1F);
  final AwliyaAllahController controller = Get.find<AwliyaAllahController>();

  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.selectedAwliya.value = null;
    controller.fetchAwliyaDetails(widget.awliya.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF8D3C1F)),
            );
          }

          final awliya = controller.selectedAwliya.value ?? widget.awliya;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // 2. Back Button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),

                // 3. Profile Image
                const SizedBox(height: 10),
                Center(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: awliya.image.isNotEmpty
                        ? NetworkImage(awliya.image)
                        : null,
                    backgroundColor: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
                    child: awliya.image.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 90,
                            color: isDark ? Colors.grey.shade400 : Colors.grey,
                          )
                        : null,
                  ),
                ),

                // 4. Names
                const SizedBox(height: 20),
                Text(
                  awliya.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF2E2E2E),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  awliya.title,
                  style: GoogleFonts.amiri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),

                // 5. Tabs Row
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _tabButton(tr("biography"), 0, isDark),
                      _tabButton(tr("teachings"), 1, isDark),
                      _tabButton(tr("karamat"), 2, isDark),
                      _tabButton(tr("quotes"), 3, isDark),
                    ],
                  ),
                ),

                // 6. Section Title
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _getTabTitle(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      color: isDark ? Colors.white : const Color(0xFF2E2E2E),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                _buildTabBody(awliya, isDark),

                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getTabTitle() {
    switch (selectedTabIndex) {
      case 1:
        return tr("his_teachings");
      case 2:
        return tr("verified_karamat");
      case 3:
        return tr("his_quotes");
      default:
        return tr("biography");
    }
  }

  Widget _buildTabBody(AwliyaAllah awliya, bool isDark) {
    switch (selectedTabIndex) {
      case 1:
        return _contentListTab(
          awliya.teachings,
          tr("teachings"),
          isDark: isDark,
        );
      case 2:
        return _contentListTab(awliya.karamats, tr("karamat"), isDark: isDark);
      case 3:
        return _contentListTab(
          awliya.quotes,
          tr("quotes"),
          isQuote: true,
          isDark: isDark,
        );
      default:
        return _biographyTab(awliya, isDark);
    }
  }

  Widget _biographyTab(AwliyaAllah awliya, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow(tr("label_name"), awliya.name, isDark),
          _infoRow(
            tr("label_born"),
            localizeDigits(awliya.dateOfBirth ?? tr("not_available"), context),
            isDark,
          ),
          _infoRow(
            tr("label_passed_away"),
            localizeDigits(awliya.dateOfDeath ?? tr("not_available"), context),
            isDark,
          ),
          _infoRow(
            tr("label_position"),
            awliya.position ?? tr("not_available"),
            isDark,
          ),
          _infoRow(
            tr("label_institution"),
            awliya.institution ?? tr("not_available"),
            isDark,
          ),
          _infoRow(
            tr("label_works"),
            awliya.works ?? tr("not_available"),
            isDark,
          ),
          _infoRow(
            tr("label_known_for"),
            awliya.knownFor ?? tr("not_available"),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _contentListTab(
    List<AwliyaContentItem>? items,
    String type, {
    bool isQuote = false,
    bool isDark = false,
  }) {
    if (items == null || items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            tr("info_updated_soon", args: [type]),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: items
          .map(
            (item) => _actionCard(
              item.title,
              item.description,
              isDark,
              isQuote: isQuote,
            ),
          )
          .toList(),
    );
  }

  Widget _actionCard(
    String title,
    String body,
    bool isDark, {
    bool isQuote = false,
  }) {
    return _ActionCardWidget(
      title: title,
      body: body,
      isQuote: isQuote,
      primaryBrown: primaryBrown,
      isDark: isDark,
    );
  }

  Widget _tabButton(String label, int index, bool isDark) {
    final bool isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryBrown
              : (isDark ? Colors.grey.shade800 : Colors.white),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 5,
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.grey.shade600),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCardWidget extends StatefulWidget {
  final String title;
  final String body;
  final bool isQuote;
  final Color primaryBrown;
  final bool isDark;

  const _ActionCardWidget({
    required this.title,
    required this.body,
    this.isQuote = false,
    required this.primaryBrown,
    this.isDark = false,
  });

  @override
  State<_ActionCardWidget> createState() => _ActionCardWidgetState();
}

class _ActionCardWidgetState extends State<_ActionCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border.all(
          width: 1,
          color: widget.isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.isDark ? 0.2 : 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final span = TextSpan(
            text: widget.body,
            style: GoogleFonts.playfairDisplay(
              fontSize: 13,
              color: widget.isDark ? Colors.white70 : Colors.black54,
              height: 1.4,
              fontStyle: widget.isQuote ? FontStyle.italic : FontStyle.normal,
            ),
          );

          final tp = TextPainter(
            text: span,
            maxLines: 5,
            textDirection: Directionality.of(context),
          );

          tp.layout(maxWidth: constraints.maxWidth);
          final bool hasOverflow = tp.didExceedMaxLines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.body,
                maxLines: isExpanded ? null : 5,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  color: widget.isDark ? Colors.white70 : Colors.black54,
                  height: 1.4,
                  fontStyle: widget.isQuote
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),
              if (hasOverflow) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.primaryBrown,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        isExpanded ? tr("show_less") : tr("see_more"),
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
    );
  }
}
