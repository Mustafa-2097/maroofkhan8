import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import '../controller/meditation_controller.dart';
import '../model/meditation_model.dart';
import '../../sufism/model/guided_meditation_model.dart';
import '../../sufism/controller/sufism_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

// --- Reusable Components ---

class CustomHeader extends StatelessWidget {
  final String title;
  const CustomHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: const Color(0xFF8D4B33),
              indent: sw * 0.1,
              endIndent: 10,
              thickness: 0.8,
            ),
          ),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.ebGaramond(
              fontSize: sw * 0.025,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8D4B33),
            ),
          ),
          Expanded(
            child: Divider(
              color: const Color(0xFF8D4B33),
              indent: 10,
              endIndent: sw * 0.1,
              thickness: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: sw * 0.06, vertical: sh * 0.01),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: sw * 0.07,
            color: isDark ? const Color(0xFF8D4B33) : Colors.black87,
          ),
          SizedBox(width: sw * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: sw * 0.04,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.ebGaramond(
                    fontSize: sw * 0.033,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF8D4B33),
            ),
            child: const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screens ---

// 1. Main Menu Screen
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MeditationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDFDFD),
      appBar: AppBar(
        title: HeaderSection(title: tr("islaah_meditation")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white70 : Colors.grey,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: sh * 0.025),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.meditationList.isEmpty) {
                  return Center(
                    child: Text(
                      tr("no_meditation_records"),
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.meditationList.length,
                  itemBuilder: (context, index) {
                    final med = controller.meditationList[index];
                    return GestureDetector(
                      onTap: () async {
                        if (med.id == null) return;

                        Get.dialog(
                          const Center(child: CircularProgressIndicator()),
                          barrierDismissible: false,
                        );

                        final fullMed = await controller.fetchMeditationById(
                          med.id!,
                        );

                        Get.back();

                        if (fullMed != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) =>
                                  MeditationPlayerScreen(meditation: fullMed),
                            ),
                          );
                        } else {
                          Get.snackbar(
                            tr("error_colon"),
                            tr("fetch_meditation_error"),
                          );
                        }
                      },
                      child: CategoryCard(
                        title:
                            tr(
                              "meditation_${med.id}_title",
                            ).contains("meditation_")
                            ? (med.title ?? tr("untitled"))
                            : tr("meditation_${med.id}_title"),
                        subtitle:
                            tr(
                              "meditation_${med.id}_sub",
                            ).contains("meditation_")
                            ? (med.subtitle ?? "")
                            : tr("meditation_${med.id}_sub"),
                        icon: Icons.self_improvement,
                      ),
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
}

// 2. Meditation Player Screen
class MeditationPlayerScreen extends StatefulWidget {
  final MeditationData? meditation;
  final GuidedMeditationData? guidedMeditation;

  /// Optional: pass the full list + starting index for next/prev navigation
  final List<GuidedMeditationData> allGuidedMeditations;
  final int initialIndex;

  const MeditationPlayerScreen({
    super.key,
    this.meditation,
    this.guidedMeditation,
    this.allGuidedMeditations = const [],
    this.initialIndex = 0,
  });

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen> {
  late AudioPlayer player;
  PlayerState playerState = PlayerState.stopped;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isTrackLoading = false;

  late GuidedMeditationData? _currentGuided;
  late int _currentIndex;

  String? get _audioUrl => _currentGuided?.file ?? widget.meditation?.file;

  @override
  void initState() {
    super.initState();
    _currentGuided = widget.guidedMeditation;
    _currentIndex = widget.initialIndex;
    player = AudioPlayer();

    final audioUrl = _audioUrl;
    if (audioUrl != null && audioUrl.isNotEmpty) {
      player.setSourceUrl(audioUrl);
    }

    player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => playerState = state);
    });
    player.onDurationChanged.listen((d) {
      if (mounted) setState(() => duration = d);
    });
    player.onPositionChanged.listen((p) {
      if (mounted) setState(() => position = p);
    });
    player.onPlayerComplete.listen((_) => _nextTrack());
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return localizeDigits("$twoDigitMinutes:$twoDigitSeconds", context);
  }

  void _togglePlay() async {
    if (playerState == PlayerState.playing) {
      await player.pause();
    } else {
      await _startSession();
    }
  }

  Future<void> _startSession() async {
    final audioUrl = _audioUrl;
    if (audioUrl == null || audioUrl.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr("no_audio_available"))));
      return;
    }
    await player.play(UrlSource(audioUrl));
  }

  Future<void> _keepBreathing() async {
    await player.pause();
  }

  Future<void> _endSession() async {
    await player.stop();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _loadTrackAt(int index) async {
    final list = widget.allGuidedMeditations;
    if (index < 0 || index >= list.length) return;

    setState(() {
      isTrackLoading = true;
      duration = Duration.zero;
      position = Duration.zero;
    });
    await player.stop();

    final fetched = await SufismController.instance.fetchGuidedMeditationById(
      list[index].id!,
    );
    if (!mounted) return;

    setState(() {
      _currentGuided = fetched ?? list[index];
      _currentIndex = index;
      isTrackLoading = false;
    });

    final url = _audioUrl;
    if (url != null && url.isNotEmpty) {
      await player.play(UrlSource(url));
    }
  }

  Future<void> _nextTrack() async {
    final list = widget.allGuidedMeditations;
    if (list.isEmpty) return;
    final nextIndex = (_currentIndex + 1) % list.length;
    await _loadTrackAt(nextIndex);
  }

  Future<void> _prevTrack() async {
    final list = widget.allGuidedMeditations;
    if (list.isEmpty) return;
    if (position.inSeconds > 3) {
      await player.seek(Duration.zero);
    } else {
      final prevIndex = (_currentIndex - 1 + list.length) % list.length;
      await _loadTrackAt(prevIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    final title = tr("inner_peace");
    final subtitle = tr("calm_heart_placeholder");
    final arabicTitle = _currentGuided?.name ?? widget.meditation?.title;
    final hasList = widget.allGuidedMeditations.length > 1;

    // Theme-aware colors
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFDFDFD);
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark
        ? Colors.grey[400]
        : Colors.grey.withOpacity(0.95);
    final iconColor = isDark ? Colors.white70 : Colors.black87;
    final disabledColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final sliderInactiveColor = isDark ? Colors.grey[700] : Colors.grey[300];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: HeaderSection(title: title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white70 : Colors.grey,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: sh * 0.025),
            // Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.ebGaramond(
                  fontSize: sw * 0.045,
                  fontStyle: FontStyle.italic,
                  color: subtitleColor,
                ),
              ),
            ),
            if (arabicTitle != null) ...[
              SizedBox(height: sh * 0.012),
              Text(
                arabicTitle,
                style: GoogleFonts.amiri(
                  fontSize: sw * 0.055,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8D4B33),
                ),
              ),
            ],
            const Spacer(),
            // Circular meditation image
            Center(
              child: Container(
                width: sw * 0.5,
                height: sw * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1519817650390-64a93db51149?q=80&w=400',
                    ),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF3D2B20)
                        : const Color(0xFFF0E6E1),
                    width: sw * 0.02,
                  ),
                ),
              ),
            ),
            SizedBox(height: sh * 0.035),
            // Teacher title
            Text(
              tr("al_murshid_title"),
              style: GoogleFonts.playfairDisplay(
                fontSize: sw * 0.055,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: sh * 0.012),
            // Instructions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.08),
              child: Text(
                tr("remember_allah_placeholder"),
                textAlign: TextAlign.center,
                style: GoogleFonts.ebGaramond(
                  fontSize: sw * 0.038,
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                ),
              ),
            ),
            const Spacer(),
            // Audio Controls
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.07),
              child: Column(
                children: [
                  // Seekbar row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatDuration(position),
                        style: GoogleFonts.ebGaramond(
                          fontSize: sw * 0.03,
                          color: isDark ? Colors.grey[400] : Colors.black87,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: (duration.inMilliseconds > 0)
                              ? position.inMilliseconds /
                                    duration.inMilliseconds
                              : 0.0,
                          onChanged: (v) {
                            final newPos = duration.inMilliseconds * v;
                            player.seek(Duration(milliseconds: newPos.round()));
                          },
                          activeColor: const Color(0xFF8D4B33),
                          inactiveColor: sliderInactiveColor,
                        ),
                      ),
                      Text(
                        formatDuration(duration),
                        style: GoogleFonts.ebGaramond(
                          fontSize: sw * 0.03,
                          color: isDark ? Colors.grey[400] : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // Play controls row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: hasList ? _prevTrack : null,
                        child: Icon(
                          Icons.skip_previous_outlined,
                          size: sw * 0.075,
                          color: hasList ? iconColor : disabledColor,
                        ),
                      ),
                      SizedBox(width: sw * 0.06),
                      GestureDetector(
                        onTap: isTrackLoading ? null : _togglePlay,
                        child: Container(
                          padding: EdgeInsets.all(sw * 0.01),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1.5,
                              color: isDark ? Colors.white38 : Colors.black87,
                            ),
                          ),
                          child: isTrackLoading
                              ? SizedBox(
                                  width: sw * 0.088,
                                  height: sw * 0.088,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF8D4B33),
                                  ),
                                )
                              : Icon(
                                  playerState == PlayerState.playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: sw * 0.088,
                                  color: textColor,
                                ),
                        ),
                      ),
                      SizedBox(width: sw * 0.06),
                      GestureDetector(
                        onTap: hasList ? _nextTrack : null,
                        child: Icon(
                          Icons.skip_next_outlined,
                          size: sw * 0.075,
                          color: hasList ? iconColor : disabledColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.045),
            // Bottom Action Buttons
            Padding(
              padding: EdgeInsets.only(bottom: sh * 0.06),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: sw * 0.02,
                runSpacing: sh * 0.012,
                children: [
                  _buildBottomBtn(
                    tr("start_session"),
                    const Color(0xFF0D5D4E),
                    sw: sw,
                    onTap: _startSession,
                  ),
                  _buildBottomBtn(
                    tr("keep_breathing"),
                    const Color(0xFF8D4B33),
                    sw: sw,
                    onTap: _keepBreathing,
                  ),
                  _buildBottomBtn(
                    tr("end_session"),
                    const Color(0xFF1B2344),
                    sw: sw,
                    onTap: _endSession,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBtn(
    String text,
    Color color, {
    required VoidCallback onTap,
    required double sw,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: sw * 0.035,
          vertical: sw * 0.02,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: sw * 0.03,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
