import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../controller/meditation_controller.dart';
import '../model/meditation_model.dart';

class IslaahApp extends StatelessWidget {
  const IslaahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
        primaryColor: const Color(0xFF8D4B33),
      ),
      home: const MainMenuScreen(),
    );
  }
}

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
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Islaah & Meditation"),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.meditationList.isEmpty) {
                  return const Center(
                    child: Text("No meditation records found"),
                  );
                }

                return ListView.builder(
                  itemCount: controller.meditationList.length,
                  itemBuilder: (context, index) {
                    final med = controller.meditationList[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) =>
                              MeditationPlayerScreen(meditation: med),
                        ),
                      ),
                      child: CategoryCard(
                        title: med.title ?? "Untitled",
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
  final MeditationData meditation;

  const MeditationPlayerScreen({super.key, required this.meditation});

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen> {
  late AudioPlayer player;
  PlayerState playerState = PlayerState.stopped;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    // Set source
    if (widget.meditation.file != null) {
      player.setSourceUrl(widget.meditation.file!);
    }

    // Listen to player state
    player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          playerState = state;
        });
      }
    });

    // Listen to duration
    player.onDurationChanged.listen((d) {
      if (mounted) {
        setState(() {
          duration = d;
        });
      }
    });

    // Listen to position
    player.onPositionChanged.listen((p) {
      if (mounted) {
        setState(() {
          position = p;
        });
      }
    });
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
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _togglePlay() async {
    if (playerState == PlayerState.playing) {
      await player.pause();
    } else {
      if (widget.meditation.file != null) {
        await player.play(UrlSource(widget.meditation.file!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(title: widget.meditation.title ?? "Inner Peace"),
            const SizedBox(height: 20),
            Text(
              widget.meditation.subtitle ??
                  "Calm your heart, balance your\nmind",
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
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
              "Al Murshid",
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Take a deep breath and remember Allah.\nPause if needed. Focus on your heart",
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(
                fontSize: 15,
                color: Colors.black54,
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
                      const Icon(Icons.skip_previous_outlined, size: 30),
                      const SizedBox(width: 25),
                      GestureDetector(
                        onTap: _togglePlay,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 1),
                          ),
                          child: Icon(
                            playerState == PlayerState.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 35,
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      const Icon(Icons.skip_next_outlined, size: 30),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Bottom Action Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBottomBtn("Start Session", const Color(0xFF0D5D4E)),
                  const SizedBox(width: 8),
                  _buildBottomBtn("Keep Breathing", const Color(0xFF8D4B33)),
                  const SizedBox(width: 8),
                  _buildBottomBtn("End Session", const Color(0xFF1B2344)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBtn(String text, Color color) {
    return Container(
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
    );
  }
}
