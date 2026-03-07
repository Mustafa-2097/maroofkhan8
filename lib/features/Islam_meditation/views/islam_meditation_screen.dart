import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import '../controller/meditation_controller.dart';
import '../model/meditation_model.dart';
import '../../sufism/model/guided_meditation_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

// --- Reusable Components ---

class CustomHeader extends StatelessWidget {
  final String title;
  const CustomHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Color(0xFF8D4B33),
              indent: 40,
              endIndent: 10,
              thickness: 0.8,
            ),
          ),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.ebGaramond(
              fontSize: 10,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8D4B33),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Color(0xFF8D4B33),
              indent: 10,
              endIndent: 40,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          const SizedBox(width: 16),
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
                Text(
                  subtitle,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 13,
                    color: Colors.grey[600],
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

    return Scaffold(
      appBar: AppBar(
        title: HeaderSection(title: tr("islaah_meditation_title")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.meditationList.isEmpty) {
                  return Center(child: Text(tr("no_meditation_records")));
                }

                return ListView.builder(
                  itemCount: controller.meditationList.length,
                  itemBuilder: (context, index) {
                    final med = controller.meditationList[index];
                    return GestureDetector(
                      onTap: () async {
                        if (med.id == null) return;

                        // Show loading
                        Get.dialog(
                          const Center(child: CircularProgressIndicator()),
                          barrierDismissible: false,
                        );

                        final fullMed = await controller.fetchMeditationById(
                          med.id!,
                        );

                        // Close loading
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
                            tr("error"),
                            tr("fetch_meditation_error"),
                          );
                        }
                      },
                      child: CategoryCard(
                        title: med.title ?? tr("untitled"),
                        subtitle: med.subtitle ?? "",
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

// 2. Meditation Player Screen (Matches Screen 5, 6, 7)
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

  // Tracks the current guided meditation being played
  late GuidedMeditationData? _currentGuided;
  late int _currentIndex;

  String? get _audioUrl => _currentGuided?.file ?? widget.meditation?.file;

  @override
  void initState() {
    super.initState();
    _currentGuided = widget.guidedMeditation;
    _currentIndex = widget.initialIndex;
    player = AudioPlayer();

    // Set source
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
    // Auto-advance to next when track completes
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No audio available for this session")),
      );
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

    // Fetch the full record (with audio file) from the API
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
    // If more than 3 seconds in, restart; otherwise go to previous
    if (position.inSeconds > 3) {
      await player.seek(Duration.zero);
    } else {
      final prevIndex = (_currentIndex - 1 + list.length) % list.length;
      await _loadTrackAt(prevIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.meditation?.title ??
        widget.guidedMeditation?.name ??
        tr("inner_peace");
    final subtitle =
        widget.meditation?.subtitle ??
        widget.guidedMeditation?.meaning ??
        tr("calm_heart_placeholder");
    final arabicTitle = widget.guidedMeditation?.nameArabic;

    return Scaffold(
      appBar: AppBar(
        title: HeaderSection(title: title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
            if (arabicTitle != null) ...[
              const SizedBox(height: 10),
              Text(
                arabicTitle,
                style: GoogleFonts.amiri(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8D4B33),
                ),
              ),
            ],
            const Spacer(),
            // The Circular Image
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1519817650390-64a93db51149?q=80&w=400',
                    ),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: const Color(0xFFF0E6E1), width: 8),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              tr("al_murshid"),
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              tr("remember_allah_placeholder"),
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.withOpacity(0.95),
              ),
            ),
            const Spacer(),
            // Audio Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatDuration(position),
                        style: GoogleFonts.ebGaramond(fontSize: 12),
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
                          inactiveColor: Colors.grey[300],
                        ),
                      ),
                      Text(
                        formatDuration(duration),
                        style: GoogleFonts.ebGaramond(fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: hasList ? _prevTrack : null,
                        child: Icon(
                          Icons.skip_previous_outlined,
                          size: 30,
                          color: hasList ? Colors.black87 : Colors.grey[300],
                        ),
                      ),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: isTrackLoading ? null : _togglePlay,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1),
                          ),
                          child: isTrackLoading
                              ? const SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF8D4B33),
                                  ),
                                )
                              : Icon(
                                  playerState == PlayerState.playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 35,
                                ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: hasList ? _nextTrack : null,
                        child: Icon(
                          Icons.skip_next_outlined,
                          size: 30,
                          color: hasList ? Colors.black87 : Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Bottom Action Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBottomBtn(tr("start_session"), const Color(0xFF0D5D4E)),
                  const SizedBox(width: 8),
                  _buildBottomBtn(
                    tr("keep_breathing"),
                    const Color(0xFF8D4B33),
                  ),
                  const SizedBox(width: 8),
                  _buildBottomBtn(tr("end_session"), const Color(0xFF1B2344)),
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: GoogleFonts.ebGaramond(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
