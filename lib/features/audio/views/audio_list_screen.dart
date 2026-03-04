import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/audio/views/audio_screen.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/audio/controller/audio_controller.dart';
import 'package:maroofkhan8/features/audio/model/audio_model.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioListScreen extends StatefulWidget {
  final String category;
  const AudioListScreen({super.key, this.category = "Sufi Lectures"});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  final controller = Get.put(AudioController());
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.category;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAudios(category: selectedCategory);
    });
  }

  final List<String> categories = [
    "Sufi Lectures",
    "Malfuzat",
    "Naats & Manqabats",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: HeaderSection(title: "Audio List"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          /// 1. Category Filter Chips (Fixed & Non-Scrollable)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: categories.map((cat) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: cat != categories.last ? 8 : 0,
                    ),
                    child: _buildChip(cat, selectedCategory == cat, () {
                      setState(() {
                        selectedCategory = cat;
                      });
                      controller.fetchAudios(category: selectedCategory);
                    }),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                /// 2. Featured Main Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (controller.audioList.isEmpty) {
                            return const SizedBox(
                              height: 100,
                              child: Center(child: Text("No audio found")),
                            );
                          }

                          // Use the first item as featured if available
                          final featuredAudio = controller.audioList.first;
                          final isCurrentlyPlaying =
                              controller.currentAudioId.value ==
                              featuredAudio.id;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.asset(
                                  'assets/images/sheikh_image.png',
                                  width: double.infinity,
                                  height: 215,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      featuredAudio.title ?? 'Trust in Allah',
                                      style: GoogleFonts.amiri(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        height: 1.1,
                                      ),
                                    ),
                                    Text(
                                      featuredAudio.subtitle ??
                                          'Shaykh’s Lecture',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(
                                          isCurrentlyPlaying
                                              ? _formatDuration(
                                                  controller
                                                      .currentDuration
                                                      .value,
                                                )
                                              : '00:00',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Expanded(
                                          child: SliderTheme(
                                            data: SliderThemeData(
                                              trackHeight: 3,
                                              thumbShape:
                                                  const RoundSliderThumbShape(
                                                    enabledThumbRadius: 6,
                                                  ),
                                              activeTrackColor: const Color(
                                                0xFF8D3C1F,
                                              ),
                                              inactiveTrackColor:
                                                  Colors.grey.shade300,
                                              thumbColor: const Color(
                                                0xFF8D3C1F,
                                              ),
                                              overlayColor: const Color(
                                                0xFF8D3C1F,
                                              ).withOpacity(0.1),
                                            ),
                                            child: Slider(
                                              value:
                                                  isCurrentlyPlaying &&
                                                      controller
                                                              .totalDuration
                                                              .value
                                                              .inSeconds >
                                                          0
                                                  ? controller
                                                            .currentDuration
                                                            .value
                                                            .inSeconds /
                                                        controller
                                                            .totalDuration
                                                            .value
                                                            .inSeconds
                                                  : 0.0,
                                              onChanged: (val) {
                                                if (isCurrentlyPlaying) {
                                                  controller.seekAudio(
                                                    Duration(
                                                      seconds:
                                                          (val *
                                                                  controller
                                                                      .totalDuration
                                                                      .value
                                                                      .inSeconds)
                                                              .toInt(),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        Text(
                                          isCurrentlyPlaying
                                              ? _formatDuration(
                                                  controller
                                                      .totalDuration
                                                      .value,
                                                )
                                              : '00:00',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _buildActionButton(
                                          icon:
                                              isCurrentlyPlaying &&
                                                  controller
                                                          .playerState
                                                          .value ==
                                                      PlayerState.playing
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                          label:
                                              isCurrentlyPlaying &&
                                                  controller
                                                          .playerState
                                                          .value ==
                                                      PlayerState.playing
                                              ? 'Pause'
                                              : 'Listen',
                                          onPressed: () {
                                            if (isCurrentlyPlaying &&
                                                controller.playerState.value ==
                                                    PlayerState.playing) {
                                              controller.pauseAudio();
                                            } else {
                                              controller.playAudio(
                                                featuredAudio,
                                              );
                                            }
                                          },
                                          isLoading:
                                              isCurrentlyPlaying &&
                                              controller.isAudioLoading.value,
                                        ),
                                        const SizedBox(width: 16),
                                        _buildActionButton(
                                          icon: Icons.file_download_outlined,
                                          label: 'Download (Premium)',
                                          onPressed: () {
                                            controller.downloadAudio(
                                              featuredAudio,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),

                /// 3. Recent Lectures List
                Obx(
                  () => SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final audio = controller.audioList[index];
                        return AudioCard(
                          audio: audio,
                          onTap: () {
                            controller.playAudio(audio);
                          },
                        );
                      }, childCount: controller.audioList.length),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8D3C1F) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(icon, color: Colors.white, size: 16),
        label: Text(
          isLoading ? "Loading..." : label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8D3C1F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: const StadiumBorder(),
          disabledBackgroundColor: const Color(0xFF8D3C1F).withOpacity(0.7),
        ),
      ),
    );
  }
}
