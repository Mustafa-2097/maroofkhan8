import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';
import 'package:get/get.dart';
import '../controller/quran_controller.dart';
import '../model/surah_model.dart';
import '../model/verse_model.dart' as vm;
import 'package:share_plus/share_plus.dart';

import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';
import '../../ai_murshid/views/ai_murshid_screen.dart';
import 'saved_suras_screen.dart';
import 'package:easy_localization/easy_localization.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkBlack = Color(0xFF1E120D);
const Color kLightGrey = Color(0xFFA4AFC1);

// --- MAIN CONTAINER WITH BOTTOM NAV ---
class QuranScreen extends StatefulWidget {
  final bool hideBack;
  const QuranScreen({super.key, this.hideBack = false});

  @override
  State<QuranScreen> createState() => _MainContainerState();
}

class _MainContainerState extends State<QuranScreen> {
  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      appBar: AppBar(
        title: HeaderSection(title: tr("al_quran")),
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
      body: const QuranTabsScreen(),
    );
  }
}

// --- SCREEN 1, 2, 3: QURAN TABS ---
class QuranTabsScreen extends StatefulWidget {
  const QuranTabsScreen({super.key});

  @override
  State<QuranTabsScreen> createState() => _QuranTabsScreenState();
}

class _QuranTabsScreenState extends State<QuranTabsScreen> {
  final QuranController controller = Get.put(QuranController());
  int _selectedTab = 0; // 0: Surah, 1: Juz, 2: Last Read

  @override
  Widget build(BuildContext context) {
    context.locale;
    return SafeArea(
      child: Column(
        children: [
          // const SizedBox(height: 10),
          // const HeaderSection(title: "Al Quran"),
          const SizedBox(height: 15),
          const SearchAndBookmark(),
          const SizedBox(height: 15),
          // Tab Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _tabButton(tr("surah"), 0),
                const SizedBox(width: 8),
                _tabButton(tr("juz"), 1),
                const SizedBox(width: 8),
                _tabButton(tr("last_read"), 2, icon: Icons.access_time),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index, {IconData? icon}) {
    bool isSelected = _selectedTab == index;
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected
                ? kPrimaryBrown
                : isDark
                ? Colors.white
                : Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? Colors.white
                      : isDark
                      ? Colors.black
                      : Colors.white,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isDark
                      ? Colors.black
                      : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 1: // Juz List
        return Obx(() {
          if (controller.isJuzLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.filteredJuzList.isEmpty) {
            return Center(child: Text(tr("no_juz_found")));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.filteredJuzList.length,
            itemBuilder: (context, i) {
              final juz = controller.filteredJuzList[i];
              String subtitle = "";
              if (juz.verses != null && juz.verses!.isNotEmpty) {
                subtitle = juz.verses!
                    .map(
                      (v) =>
                          "${tr('chapter')} ${localizeDigits(v.chapter.toString(), context)}",
                    )
                    .toSet()
                    .join(", ");
              } else {
                subtitle =
                    "${tr('juz')} ${localizeDigits((juz.number ?? 0).toString(), context)}";
              }
              return _listTile(
                num: localizeDigits((juz.number ?? 0).toString(), context),
                title:
                    "${tr('juz')} ${localizeDigits((juz.number ?? 0).toString(), context)}",
                sub: subtitle,
                surah: null,
              );
            },
          );
        });
      case 2: // Last Read
        return Obx(() {
          if (controller.isLastReadLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.filteredLastReadList.isEmpty) {
            return Center(child: Text(tr("no_items_found")));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.filteredLastReadList.length,
            itemBuilder: (context, i) {
              final lastRead = controller.filteredLastReadList[i];
              final chapter = lastRead.chapter;
              final nameKey = "surah_${chapter?.chapterNumber}_name";
              final localizedTitle = tr(nameKey) == nameKey
                  ? (chapter?.name ?? tr("unknown"))
                  : tr(nameKey);
              return _listTile(
                num: localizeDigits(
                  (chapter?.chapterNumber ?? i + 1).toString(),
                  context,
                ),
                title: localizedTitle,
                sub:
                    "${tr('verse')} ${localizeDigits((lastRead.verse ?? 1).toString(), context)}",
                surah: chapter != null
                    ? SurahModel(
                        id: chapter.id ?? 0,
                        name: chapter.name ?? "",
                        translatedName: chapter.nameTranslated ?? "",
                        versesCount: chapter.versesCount ?? 0,
                        revelationPlace: chapter.revelationPlace ?? "",
                      )
                    : null,
                isLastRead: true,
              );
            },
          );
        });
      default: // Surah List
        return Obx(() {
          // We show a small indicator if loading, but still show current data (which could be dummy data)
          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.filteredSurahList.length,
                itemBuilder: (context, i) {
                  final surah = controller.filteredSurahList[i];
                  final revelationKey =
                      surah.revelationPlace.toLowerCase() == 'makkah'
                      ? 'revelation_makkah'
                      : 'revelation_madinah';

                  // Use localized names if keys exist, otherwise fallback to surah model values
                  final nameKey = "surah_${surah.id}_name";
                  final transKey = "surah_${surah.id}_trans";

                  final localizedName = tr(nameKey) == nameKey
                      ? surah.name
                      : tr(nameKey);
                  final localizedTrans = tr(transKey) == transKey
                      ? surah.translatedName
                      : tr(transKey);

                  return _listTile(
                    num: localizeDigits(surah.id.toString(), context),
                    title: localizedName,
                    sub:
                        "$localizedTrans  | ${localizeDigits(surah.versesCount.toString(), context)} ${tr('ayah')}  |  ${tr(revelationKey)} ${tr('surah')}",
                    surah: surah,
                  );
                },
              ),
              if (controller.isLoading.value)
                const Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
            ],
          );
        });
    }
  }

  Widget _listTile({
    required String num,
    required String title,
    required String sub,
    String? time,
    SurahModel? surah,
    VoidCallback? onDelete,
    bool isLastRead = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (surah != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => QuranDetailsScreen(surah: surah)),
          );
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                HexagonBadge(number: num),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sub,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6F8DA1),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (time != null)
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6F8DA1),
                    ),
                  ),
                if (surah != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => controller.downloadSurahAudio(surah),
                        icon: const Icon(
                          Icons.file_download_outlined,
                          color: kPrimaryBrown,
                          size: 24,
                        ),
                      ),
                      if (!isLastRead)
                        Obx(() {
                          final isSaved = controller.surahBookmarkIds
                              .containsKey(surah.id);
                          return IconButton(
                            onPressed: () => controller.toggleSaveSurah(surah),
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: kPrimaryBrown,
                              size: 24,
                            ),
                          );
                        }),
                    ],
                  ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFE53935),
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.stroke),
        ],
      ),
    );
  }
}

// --- SCREEN 4 & 5: QURAN DETAILS ---
class QuranDetailsScreen extends StatefulWidget {
  final SurahModel surah;
  const QuranDetailsScreen({super.key, required this.surah});

  @override
  State<QuranDetailsScreen> createState() => _QuranDetailsScreenState();
}

class _QuranDetailsScreenState extends State<QuranDetailsScreen> {
  final QuranController controller = Get.find<QuranController>();
  int _activeDetailTab = 0; // 0: Surah, 1: Tafsir, 2: AI Explanation

  // AI Explanation state
  final _aiScrollController = ScrollController();
  final _aiTextController = TextEditingController();
  final List<Map<String, dynamic>> _aiMessages = [];
  bool _aiIsTyping = false;
  late final _quranAiService = _QuranAiService();

  // Voice input state
  late final stt.SpeechToText _speech = stt.SpeechToText();
  bool _aiIsListening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSurahVerses(widget.surah.id);
      controller.fetchSurahAudio(widget.surah.id);
      controller.updateLastRead(widget.surah.id, 1);
      controller.postChapters(widget.surah.id);
    });
  }

  @override
  void dispose() {
    controller.stopAudio();
    _aiScrollController.dispose();
    _aiTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Header with back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  HeaderSection(
                    title:
                        tr("surah_${widget.surah.id}_name") ==
                            "surah_${widget.surah.id}_name"
                        ? widget.surah.name
                        : tr("surah_${widget.surah.id}_name"),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      localizeDigits(widget.surah.id.toString(), context),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              tr("read_listen_understand"),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.whiteColor : Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            // Detail Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _detailTab(tr("surah"), 0),
                  const SizedBox(width: 10),
                  _detailTab(tr("tafsir"), 1),
                  const SizedBox(width: 10),
                  _detailTab(tr("ai_explanation"), 2),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _activeDetailTab == 0
                  ? _buildSurahReader()
                  : _activeDetailTab == 1
                  ? _buildTafsirReader()
                  : _buildAiExplanation(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailTab(String label, int index) {
    bool isSelected = _activeDetailTab == index;
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 1) {
            controller.fetchSurahTafsir(widget.surah.id);
          }
          setState(() => _activeDetailTab = index);
        },
        child: Container(
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? kPrimaryBrown
                : isDark
                ? Colors.white
                : Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : isDark
                  ? Colors.black
                  : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahReader() {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Audio Player
        Obx(() {
          final current = controller.currentDuration.value;
          final total = controller.totalDuration.value;
          final isPlaying = controller.playerState.value == PlayerState.playing;

          String formatDuration(Duration d) {
            final minutes = d.inMinutes
                .remainder(60)
                .toString()
                .padLeft(2, '0');
            final seconds = d.inSeconds
                .remainder(60)
                .toString()
                .padLeft(2, '0');
            return localizeDigits("$minutes:$seconds", context);
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatDuration(current),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.whiteColor : Colors.black87,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 4,
                        ),
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Slider(
                        value: total.inMilliseconds > 0
                            ? (current.inMilliseconds / total.inMilliseconds)
                                  .clamp(0.0, 1.0)
                            : 0.0,
                        onChanged: (v) {
                          if (total.inMilliseconds > 0) {
                            final seekTo = Duration(
                              milliseconds: (v * total.inMilliseconds).toInt(),
                            );
                            controller.seekAudio(seekTo);
                          }
                        },
                        activeColor: kPrimaryBrown,
                        inactiveColor: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  Text(
                    formatDuration(total),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.whiteColor : Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onLongPress: () =>
                        controller.seekRelative(const Duration(seconds: -5)),
                    child: IconButton(
                      onPressed: () =>
                          controller.seekRelative(const Duration(seconds: -5)),
                      icon: Icon(
                        Icons.skip_previous,
                        color: isDark ? AppColors.whiteColor : Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.resetAudio(),
                    icon: Icon(
                      size: 30,
                      Icons.restart_alt,
                      color: isDark ? AppColors.whiteColor : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      if (isPlaying) {
                        controller.pauseAudio();
                      } else {
                        controller.playAudio();
                      }
                    },
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 40,
                      color: isDark ? AppColors.whiteColor : Colors.black87,
                    ),
                  ),

                  const SizedBox(width: 10),
                  GestureDetector(
                    onLongPress: () =>
                        controller.seekRelative(const Duration(seconds: 5)),
                    child: IconButton(
                      onPressed: () =>
                          controller.seekRelative(const Duration(seconds: 5)),
                      icon: Icon(
                        Icons.skip_next,
                        color: isDark ? AppColors.whiteColor : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
        const SizedBox(height: 10),
        Expanded(
          child: Obx(() {
            if (controller.isVerseLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.verseList.isEmpty) {
              return Center(child: Text(tr("no_verses_found")));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.verseList.length,
              itemBuilder: (context, i) => _verseItem(controller.verseList[i]),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTafsirReader() {
    return Obx(() {
      if (controller.isTafsirLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.tafsirList.isEmpty) {
        return Center(child: Text(tr("no_tafsir_found")));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: controller.tafsirList.length,
        itemBuilder: (context, i) {
          final tafsir = controller.tafsirList[i];
          // Simple regex to strip HTML tags if present
          final plainContent =
              tafsir.content?.replaceAll(RegExp(r'<[^>]*>'), '') ?? '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_book, size: 16, color: kPrimaryBrown),
                    const SizedBox(width: 8),
                    Text(
                      "${tr('verse')} ${localizeDigits(tafsir.startKey ?? '', context)}:",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  plainContent,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _verseItem(vm.Data verse) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        verse.ayah ?? '',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      verse.transliteration ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: kLightGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      verse.translation ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  Text(
                    localizeDigits((verse.number ?? '').toString(), context),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  IconButton(
                    onPressed: () {
                      final shareText =
                          "${verse.ayah ?? ''}\n\n"
                          "${verse.translation ?? ''}\n\n"
                          "(${widget.surah.name}, ${tr('verse')} ${localizeDigits((verse.number ?? '').toString(), context)})";
                      Share.share(shareText);
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 5),
                  IconButton(
                    onPressed: () => controller.playVerse(verse.verseKey),
                    icon: const Icon(
                      Icons.play_circle_outline,
                      size: 20,
                      color: kPrimaryBrown,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1, color: Color(0xFFF1F1F1)),
        ],
      ),
    );
  }

  // ── AI Explanation inline chat ──────────────────────────────────────────
  Widget _buildAiExplanation() {
    return Column(
      children: [
        // Chat messages
        Expanded(
          child: _aiMessages.isEmpty && !_aiIsTyping
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 40,
                        color: kPrimaryBrown.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Ask anything about\n${widget.surah.name}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _aiScrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _aiMessages.length + (_aiIsTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _aiMessages.length && _aiIsTyping) {
                      // Typing indicator
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const _TypingIndicator(),
                        ),
                      );
                    }
                    final msg = _aiMessages[index];
                    final isUser = msg['isUser'] as bool;
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.78,
                        ),
                        decoration: BoxDecoration(
                          color: isUser ? kPrimaryBrown : Colors.grey.shade100,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(14),
                            topRight: const Radius.circular(14),
                            bottomLeft: Radius.circular(isUser ? 14 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 14),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: SelectableText(
                          msg['text'] as String,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        // Input bar with mic (Ai Murshid Design)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Stack(
            alignment: Alignment.centerRight,
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _aiIsListening
                            ? Container(
                                key: const ValueKey('listening'),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Speak now...",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4A4A4A),
                                  ),
                                ),
                              )
                            : TextField(
                                key: const ValueKey('textField'),
                                controller: _aiTextController,
                                enabled: !_aiIsTyping,
                                maxLines:
                                    1, // Keep single line for Enter-to-send
                                textInputAction: TextInputAction.send,
                                onSubmitted: (val) {
                                  if (!_aiIsTyping && val.trim().isNotEmpty) {
                                    _sendAiMessage();
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Ask about ${widget.surah.name}...",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(
                                    right: 100, // Room for buttons
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              // Mic + Send Buttons
              Positioned(
                right: 6,
                child: Row(
                  children: [
                    // Mic Button
                    GestureDetector(
                      onTap: () async {
                        if (_aiIsListening) {
                          _speech.stop();
                          setState(() => _aiIsListening = false);
                        } else {
                          final available = await _speech.initialize(
                            onStatus: (status) {
                              if (status == 'notListening' ||
                                  status == 'done') {
                                if (mounted)
                                  setState(() => _aiIsListening = false);
                              }
                            },
                            onError: (_) {
                              if (mounted)
                                setState(() => _aiIsListening = false);
                            },
                          );
                          if (available) {
                            setState(() => _aiIsListening = true);
                            _speech.listen(
                              pauseFor: const Duration(seconds: 8),
                              listenFor: const Duration(seconds: 30),
                              partialResults: true,
                              cancelOnError: false,
                              onResult: (result) {
                                setState(() {
                                  _aiTextController.text =
                                      result.recognizedWords;
                                });
                              },
                            );
                          }
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: _aiIsListening ? 48 : 40,
                        width: _aiIsListening ? 48 : 40,
                        decoration: BoxDecoration(
                          color: _aiIsListening ? kPrimaryBrown : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _aiIsListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                          size: _aiIsListening ? 26 : 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Send Button
                    GestureDetector(
                      onTap:
                          _aiTextController.text.trim().isEmpty || _aiIsTyping
                          ? null
                          : _sendAiMessage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color:
                              _aiTextController.text.trim().isEmpty ||
                                  _aiIsTyping
                              ? Colors.grey.shade300
                              : kPrimaryBrown,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send_rounded,
                          color:
                              _aiTextController.text.trim().isEmpty ||
                                  _aiIsTyping
                              ? Colors.grey
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _sendAiMessage() async {
    final text = _aiTextController.text.trim();
    if (text.isEmpty) return;
    _aiTextController.clear();
    setState(() {
      _aiMessages.add({'text': text, 'isUser': true});
      _aiIsTyping = true;
    });
    _scrollAiToBottom();
    try {
      final reply = await _quranAiService.sendMessage(
        surahName: widget.surah.name,
        question: text,
      );
      if (mounted) {
        setState(() {
          _aiIsTyping = false;
          _aiMessages.add({'text': reply, 'isUser': false});
        });
        _scrollAiToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _aiIsTyping = false);
        debugPrint("AI error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "AI Error: ${e.toString().replaceAll('Exception: ', '')}",
            ),
          ),
        );
      }
    }
  }

  void _scrollAiToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_aiScrollController.hasClients) {
        _aiScrollController.animateTo(
          _aiScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

// ── Quran-specific AI service ───────────────────────────────────────────────
class _QuranAiService {
  String? _sessionId;

  Future<String> sendMessage({
    required String surahName,
    required String question,
  }) async {
    final body = jsonEncode({
      if (_sessionId != null) 'session_id': _sessionId,
      'user_id': 'quran_user',
      'context': surahName, // Missing field causing 422
      'text': question,
    });

    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoints.quranExplanationMeditation),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          _sessionId = data['session_id'] as String?;
          return (data['explanation'] as String?) ??
              (data['message'] as String?) ??
              "No response";
        }
        return "Unexpected response format";
      } else {
        // Include body for debugging 422
        throw Exception(
          'Server Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Small animated dot used in typing indicator
class _Dot extends StatelessWidget {
  final double offset;
  const _Dot({this.offset = 0});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offset),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: kPrimaryBrown.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// Sine-wave animated typing indicator
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Create a staggered sine wave offset
            final double t = _controller.value;
            // Phase shift for each dot (0.4 radians ≈ 23 degrees)
            final double shift = (index * 0.4);
            // Calculate sine value and scale to pixels
            final double verticalOffset =
                4 * math.sin((t * 2 * math.pi) - shift);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _Dot(offset: verticalOffset),
            );
          }),
        );
      },
    );
  }
}

// --- HELPER WIDGETS ---
class SearchAndBookmark extends StatelessWidget {
  const SearchAndBookmark({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isDark ? kDarkBlack : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.stroke),
              ),
              child: TextField(
                onChanged: (val) {
                  final QuranController controller =
                      Get.find<QuranController>();
                  controller.searchQuery.value = val;
                },
                decoration: InputDecoration(
                  hintText: tr('search'),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Get.to(() => const SavedSurasScreen()),
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: isDark ? kDarkBlack : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.stroke),
              ),
              child: Icon(
                Icons.bookmark_outline,
                color: AppColors.stroke,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HexagonBadge extends StatelessWidget {
  final String number;
  const HexagonBadge({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: _HexagonClipper(),
          child: Container(width: 38, height: 38, color: kPrimaryBrown),
        ),
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(0, size.height * 0.75);
    path.lineTo(0, size.height * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
