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

import 'package:maroofkhan8/core/utils/localization_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constant/widgets/header.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../core/network/api_endpoints.dart';
import 'saved_suras_screen.dart';
import '../../profile/controller/profile_controller.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: HeaderSection(title: tr("al_quran")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 30,
        leading: widget.hideBack
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 12),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
        actions: [if (!widget.hideBack) const SizedBox(width: 40)],
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
    return SafeArea(
      child: Column(
        children: [
          // const SizedBox(height: 10),
          // const SizedBox(height: 15),
          SizedBox(height: MediaQuery.of(context).size.height * 0.018),
          const SearchAndBookmark(),
          // const SizedBox(height: 15),
          SizedBox(height: MediaQuery.of(context).size.height * 0.018),
          // Tab Row
          Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
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
          // const SizedBox(height: 15),
          SizedBox(height: MediaQuery.of(context).size.height * 0.018),
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
          // height: 38,
          height: MediaQuery.of(context).size.height * 0.045,
          decoration: BoxDecoration(
            color: isSelected
                ? kPrimaryBrown
                : isDark
                ? Colors.white
                : Colors.black,
            // borderRadius: BorderRadius.circular(20),
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.05,
            ),
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
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isDark
                        ? Colors.black
                        : Colors.white,
                    // fontSize: 16,
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                    fontWeight: FontWeight.w500,
                  ),
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
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            itemCount: controller.filteredJuzList.length,
            itemBuilder: (context, i) {
              final juz = controller.filteredJuzList[i];
              String subtitle = "";
              if (juz.verses != null && juz.verses!.isNotEmpty) {
                subtitle = juz.verses!
                    .map(
                      (v) =>
                          "${tr("chapter")} ${localizeDigits(v.chapter.toString(), context)}",
                    )
                    .toSet()
                    .join(", ");
              } else {
                subtitle =
                    "${tr("juz")} ${localizeDigits((juz.number ?? 0).toString(), context)}";
              }
              return _listTile(
                num: localizeDigits((juz.number ?? 0).toString(), context),
                title:
                    "${tr("juz")} ${localizeDigits((juz.number ?? 0).toString(), context)}",
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
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            itemCount: controller.filteredLastReadList.length,
            itemBuilder: (context, i) {
              final lastRead = controller.filteredLastReadList[i];
              final chapter = lastRead.chapter;
              return _listTile(
                num: localizeDigits(
                  "${chapter?.chapterNumber ?? i + 1}",
                  context,
                ),
                // title: chapter?.name ?? tr("unknown"),
                title: chapter != null
                    ? tr("surah_${chapter.id}_name")
                    : tr("unknown"),
                sub:
                    "${tr("verse")} ${localizeDigits("${lastRead.verse ?? 1}", context)}",
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
                onDelete: lastRead.id != null
                    ? () {
                        controller.deleteLastReadRecord(lastRead.id!);
                      }
                    : null,
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
                // padding: const EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                itemCount: controller.filteredSurahList.length,
                itemBuilder: (context, i) {
                  final surah = controller.filteredSurahList[i];
                  return _listTile(
                    num: localizeDigits("${surah.id}", context),
                    // title: surah.name,
                    title: tr("surah_${surah.id}_name"),
                    // sub:
                    //     "${surah.translatedName}  | ${localizeDigits("${surah.versesCount}", context)} ${tr("ayah")}  |  ${tr("revelation_${surah.revelationPlace.toLowerCase()}")} ${tr("surah")}",
                    sub:
                        "${tr("surah_${surah.id}_trans")}  | ${localizeDigits("${surah.versesCount}", context)} ${tr("ayah")}  |  ${tr("revelation_${surah.revelationPlace.toLowerCase()}")} ${tr("surah")}",
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
    var isDark = Theme.of(context).brightness == Brightness.dark;
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
                          // fontSize: 16,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      // const SizedBox(height: 2),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.003,
                      ),
                      Text(
                        sub,
                        style: TextStyle(
                          // fontSize: 14,
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: const Color(0xFF6F8DA1),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (time != null)
                  Text(
                    time,
                    style: TextStyle(
                      // fontSize: 12,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: const Color(0xFF6F8DA1),
                    ),
                  ),
                if (surah != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() {
                        final isDownloaded = controller.downloadedSurahs
                            .containsKey(surah.id);
                        final isLoading =
                            controller.isDownloading[surah.id] ?? false;

                        if (isLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kPrimaryBrown,
                              ),
                            ),
                          );
                        }

                        if (isDownloaded) {
                          return IconButton(
                            onPressed: () =>
                                controller.deleteDownloadedSurah(surah.id),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 24,
                            ),
                          );
                        }

                        return IconButton(
                          onPressed: () {
                            ProfileController.instance.handleDownloadAction(() {
                              controller.downloadSurahAudio(surah);
                            });
                          },
                          icon: const Icon(
                            Icons.file_download_outlined,
                            color: kPrimaryBrown,
                            size: 24,
                          ),
                        );
                      }),
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
      final langCode = context.locale.languageCode;
      controller.fetchSurahVerses(widget.surah.id, langCode: langCode);
      controller.fetchSurahTafsir(widget.surah.id, langCode: langCode);
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
            // const SizedBox(height: 10),
            SizedBox(height: MediaQuery.of(context).size.height * 0.012),
            // Header with back button
            Padding(
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
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
                  // HeaderSection(title: widget.surah.name),
                  HeaderSection(title: tr("surah_${widget.surah.id}_name")),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      localizeDigits("${widget.surah.id}", context),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              tr("read_listen_understand"),
              style: TextStyle(
                // fontSize: 14,
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.whiteColor : Colors.black87,
              ),
            ),
            // const SizedBox(height: 15),
            SizedBox(height: MediaQuery.of(context).size.height * 0.018),
            // Detail Tabs
            Padding(
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
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
            // const SizedBox(height: 20),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
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
          setState(() => _activeDetailTab = index);
          if (index == 1) {
            controller.fetchSurahTafsir(
              widget.surah.id,
              langCode: context.locale.languageCode,
            );
          }
          if (index != 0) {
            controller.stopAudio();
          }
        },
        child: Container(
          // height: 35,
          height: MediaQuery.of(context).size.height * 0.045,
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
              // fontSize: 14,
              fontSize: MediaQuery.of(context).size.width * 0.038,
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
                      // fontSize: 12,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
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
                      // fontSize: 12,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.whiteColor : Colors.black87,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => controller.resetAudio(),
                    icon: Icon(
                      Icons.restart_alt,
                      // size: 30,
                      size: MediaQuery.of(context).size.width * 0.075,
                      color: isDark ? AppColors.whiteColor : Colors.black87,
                    ),
                  ),
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

                  // const SizedBox(width: 10),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.025),
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
                      // size: 40,
                      size: MediaQuery.of(context).size.width * 0.1,
                      color: isDark ? AppColors.whiteColor : Colors.black87,
                    ),
                  ),

                  // const SizedBox(width: 10),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.025),
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
        // const SizedBox(height: 10),
        SizedBox(height: MediaQuery.of(context).size.height * 0.012),
        Expanded(
          child: Obx(() {
            if (controller.isVerseLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.verseList.isEmpty) {
              return Center(child: Text(tr("no_verses_found")));
            }
            return ListView.builder(
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
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
                      "${tr("verse")} ${localizeDigits(tafsir.startKey ?? '', context)}:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  plainContent,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _verseItem(vm.Data verse) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
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
                        style: TextStyle(
                          // fontSize: 22,
                          fontSize: MediaQuery.of(context).size.width * 0.055,
                          fontWeight: FontWeight.bold,
                          height: 1.8,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.012,
                    ),
                    Text(
                      verse.transliteration ?? '',
                      style: TextStyle(
                        // fontSize: 13,
                        fontSize: MediaQuery.of(context).size.width * 0.032,
                        fontStyle: FontStyle.italic,
                        color: kLightGrey,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      verse.translation ?? '',
                      style: TextStyle(
                        // fontSize: 14,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        color: isDark ? AppColors.whiteColor : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  Text(
                    localizeDigits("${verse.number ?? ''}", context),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  IconButton(
                    onPressed: () {
                      final shareText =
                          "${verse.ayah ?? ''}\n\n"
                          "${verse.translation ?? ''}\n\n"
                          // "(${widget.surah.name}, ${tr("verse")} ${localizeDigits("${verse.number ?? ''}", context)})";
                          "(${tr("surah_${widget.surah.id}_name")}, ${tr("verse")} ${localizeDigits("${verse.number ?? ''}", context)})";
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

  // ── AI Explanation inline chat (Matches Ai Murshid Design) ────────────────
  Widget _buildAiExplanation() {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    var isDark = Theme.of(context).brightness == Brightness.dark;

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
                        size: sw * 0.1,
                        color: kPrimaryBrown.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${tr("ask_anything_about")}\n${tr("surah_${widget.surah.id}_name")}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: sw * 0.045,
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _aiScrollController,
                  padding: EdgeInsets.all(sw * 0.05),
                  itemCount: _aiMessages.length + (_aiIsTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _aiMessages.length && _aiIsTyping) {
                      // Typing indicator
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(bottom: sh * 0.015),
                          padding: EdgeInsets.symmetric(
                            horizontal: sw * 0.04,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const _ThreeDotTyping(),
                        ),
                      );
                    }
                    final msg = _aiMessages[index];
                    final isUser = msg['isUser'] as bool;
                    final text = msg['text'] as String;

                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: sh * 0.015, top: 8),
                            padding: EdgeInsets.symmetric(
                              horizontal: sw * 0.04,
                              vertical: 10,
                            ),
                            constraints: BoxConstraints(maxWidth: sw * 0.75),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? const Color(0xFF80381C) // rustBrown
                                  : (isDark
                                        ? const Color(0xFF1E1E1E)
                                        : Colors.white),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15),
                                topRight: const Radius.circular(15),
                                bottomLeft: Radius.circular(isUser ? 15 : 0),
                                bottomRight: Radius.circular(isUser ? 0 : 15),
                              ),
                              boxShadow: isUser
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          isDark ? 0.3 : 0.05,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: isUser ? 0 : 8),
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: isUser
                                      ? Colors.white
                                      : (isDark
                                            ? Colors.white.withOpacity(0.9)
                                            : Colors.black87),
                                  fontSize: sw * 0.035,
                                ),
                              ),
                            ),
                          ),
                          // Copy button for AI messages
                          if (!isUser)
                            Positioned(
                              right: 4,
                              top: 12,
                              child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: text));

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(tr("copied_to_clipboard")),
                                      duration: const Duration(
                                        milliseconds: 800,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey.shade900
                                        : Colors.grey.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.copy,
                                    size: sw * 0.03,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        // Input bar (Matches VoiceInputBar Design)
        Padding(
          padding: EdgeInsets.only(
            left: sw * 0.05,
            right: sw * 0.05,
            bottom: sh * 0.02,
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: sh * 0.08,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(width: sw * 0.06),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _aiIsListening
                            ? Container(
                                key: const ValueKey('speakNow'),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF252525)
                                      : const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tr("speak_now"),
                                  style: TextStyle(
                                    fontSize: sw * 0.03,
                                    color: isDark
                                        ? Colors.white70
                                        : const Color(0xFF4A4A4A),
                                  ),
                                ),
                              )
                            : TextField(
                                key: const ValueKey('textField'),
                                controller: _aiTextController,
                                enabled: !_aiIsTyping,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      "${tr("ask_about")} ${tr("surah_${widget.surah.id}_name")}...",
                                  hintStyle: TextStyle(
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    right: sw * 0.25,
                                  ),
                                ),
                                onChanged: (_) => setState(() {}),
                                onSubmitted: (val) {
                                  if (!_aiIsTyping && val.trim().isNotEmpty) {
                                    _sendAiMessage();
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              // Mic + Send Buttons
              Positioned(
                right: 5,
                child: Row(
                  children: [
                    // Mic Button
                    GestureDetector(
                      onTap: () async {
                        controller.stopAudio();
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
                        height: _aiIsListening ? sw * 0.12 : sw * 0.1,
                        width: _aiIsListening ? sw * 0.12 : sw * 0.1,
                        decoration: BoxDecoration(
                          color: _aiIsListening
                              ? const Color(0xFF80381C)
                              : (isDark ? Colors.grey[800] : Colors.grey),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black26 : Colors.grey,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _aiIsListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                          size: _aiIsListening ? sw * 0.065 : sw * 0.055,
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
                        height: sw * 0.105,
                        width: sw * 0.105,
                        decoration: BoxDecoration(
                          color:
                              _aiTextController.text.trim().isEmpty ||
                                  _aiIsTyping
                              ? (isDark ? Colors.white10 : Colors.grey.shade300)
                              : Colors.blueAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black12
                                  : Colors.grey.shade300,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.send,
                          color:
                              _aiTextController.text.trim().isEmpty ||
                                  _aiIsTyping
                              ? (isDark ? Colors.white24 : Colors.grey)
                              : Colors.white,
                          size: sw * 0.05,
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
        // surahName: widget.surah.name,
        surahName: tr("surah_${widget.surah.id}_name"),
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
              "${tr("ai_error_colon")} ${e.toString().replaceAll('Exception: ', '')}",
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
      // 'context': surahName, // Missing field causing 422
      'context': surahName,
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
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? Colors.white70 : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

// Typing indicator mimicking the AI Murshid screen
class _ThreeDotTyping extends StatefulWidget {
  const _ThreeDotTyping();
  @override
  State<_ThreeDotTyping> createState() => _ThreeDotTypingState();
}

class _ThreeDotTypingState extends State<_ThreeDotTyping>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotOneAnim;
  late Animation<double> _dotTwoAnim;
  late Animation<double> _dotThreeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _dotOneAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );
    _dotTwoAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeInOut),
      ),
    );
    _dotThreeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FadeTransition(opacity: _dotOneAnim, child: _Dot()),
          FadeTransition(opacity: _dotTwoAnim, child: _Dot()),
          FadeTransition(opacity: _dotThreeAnim, child: _Dot()),
        ],
      ),
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
                  hintText: tr("search"),
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
