import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/audio/views/audio_screen.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/audio/controller/audio_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../profile/controller/profile_controller.dart';

class AudioListScreen extends StatefulWidget {
  final String category;
  final String? initialAudioId;
  const AudioListScreen({
    super.key,
    this.category = "Sufi Lectures",
    this.initialAudioId,
  });

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  final controller = Get.put(AudioController());
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    // Ensure selectedCategory matches the UI label if an enum was passed
    selectedCategory =
        controller.reverseCategoryMapping[widget.category] ?? widget.category;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchAudios(category: selectedCategory);

      // If we navigated with a specific audio ID, make it featured and play it
      if (widget.initialAudioId != null && controller.audioList.isNotEmpty) {
        int index = controller.audioList.indexWhere(
          (a) => a.id == widget.initialAudioId,
        );
        if (index != -1) {
          final selectedAudio = controller.audioList.removeAt(index);
          controller.audioList.insert(0, selectedAudio);
          // controller.playAudio(selectedAudio);
          controller.featuredAudio.value = selectedAudio;
        }
      } else if (controller.audioList.isNotEmpty) {
        // Just play the first one if no specific one was requested
        // (Optional: remove this if you want it to wait for user to click play)
        // controller.playAudio(controller.audioList.first);
      }
    });
  }

  @override
  void dispose() {
    controller.stopAudio();
    super.dispose();
  }

  final List<String> categories = [
    "Sufi Lectures",
    "Malfuzat",
    "Naats & Manqabats",
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF9F9F9),
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
            // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: EdgeInsets.symmetric(
              horizontal: sw * 0.04,
              vertical: sh * 0.012,
            ),
            child: Row(
              children: categories.map((cat) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      // right: cat != categories.last ? 8 : 0,
                      right: cat != categories.last ? sw * 0.02 : 0,
                    ),
                    child: _buildChip(
                      cat,
                      selectedCategory == cat,
                      () {
                        setState(() {
                          selectedCategory = cat;
                        });
                        controller.fetchAudios(category: selectedCategory);
                      },
                      sw,
                      sh,
                      isDark,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.audioList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.audio_file_outlined,
                        // size: 64,
                        size: sw * 0.15,
                        color: Colors.grey.shade400,
                      ),
                      // const SizedBox(height: 16),
                      SizedBox(height: sh * 0.02),
                      Text(
                        "No audio found in this category",
                        style: TextStyle(
                          // fontSize: 18,
                          fontSize: sw * 0.045,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      // padding: const EdgeInsets.all(16.0),
                      padding: EdgeInsets.all(sw * 0.04),
                      child: Card(
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(16),
                          borderRadius: BorderRadius.circular(sw * 0.04),
                          side: BorderSide(
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E1E1E)
                                : Colors.white,
                            // borderRadius: BorderRadius.circular(16),
                            borderRadius: BorderRadius.circular(sw * 0.04),
                          ),
                          child: Obx(() {
                            // Use the tracked featured audio from controller
                            final featuredAudio =
                                controller.featuredAudio.value;
                            if (featuredAudio == null) {
                              return SizedBox(
                                // height: 100,
                                height: sh * 0.12,
                                child: Center(
                                  child: Text(
                                    "No featured audio",
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  featuredAudio.title ??
                                                      'Trust in Allah',
                                                  style: GoogleFonts.amiri(
                                                    // fontSize: 26,
                                                    fontSize: sw * 0.06,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.1,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  featuredAudio.subtitle ??
                                                      'Shaykh’s Lecture',
                                                  style: TextStyle(
                                                    // fontSize: 16,
                                                    fontSize: sw * 0.038,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'share') {
                                                controller.shareAudio(
                                                  featuredAudio,
                                                );
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 'share',
                                                child: Row(
                                                  children: [
                                                    // Icon(Icons.share, size: 20),
                                                    Icon(
                                                      Icons.share,
                                                      size: sw * 0.05,
                                                      color: Colors.black,
                                                    ),
                                                    // SizedBox(width: 8),
                                                    SizedBox(width: sw * 0.02),
                                                    const Text(
                                                      'Share',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            child: Icon(
                                              Icons.more_horiz,
                                              // size: 24,
                                              size: sw * 0.06,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 16),
                                      SizedBox(height: sh * 0.02),
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
                                            style: TextStyle(
                                              // fontSize: 14,
                                              fontSize: sw * 0.035,
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          Expanded(
                                            child: SliderTheme(
                                              data: SliderThemeData(
                                                trackHeight: 3,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                      enabledThumbRadius:
                                                          sw * 0.015,
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
                                                ).withValues(alpha: 0.1),
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
                                                : (controller
                                                          .cachedDurations[featuredAudio
                                                              .id ??
                                                          ''] ??
                                                      '00:00'),
                                            style: TextStyle(
                                              // fontSize: 14,
                                              fontSize: sw * 0.035,
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 24),
                                      SizedBox(height: sh * 0.03),
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
                                                  controller
                                                          .playerState
                                                          .value ==
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
                                            sw: sw,
                                            sh: sh,
                                          ),
                                          // const SizedBox(width: 16),
                                          SizedBox(width: sw * 0.04),
                                          _buildActionButton(
                                            icon: Icons.file_download_outlined,
                                            label: 'Download',
                                            // label: 'Download (Premium)',
                                            onPressed: () {
                                              ProfileController.instance
                                                  .handleDownloadAction(() {
                                                    controller.downloadAudio(
                                                      featuredAudio,
                                                    );
                                                  });
                                            },
                                            sw: sw,
                                            sh: sh,
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
                  SliverPadding(
                    // padding: const EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final audio = controller.audioList[index];
                        return AudioCard(
                          audio: audio,
                          onTap: () {
                            // controller.playAudio(audio);
                            controller.featuredAudio.value = audio;
                          },
                        );
                      }, childCount: controller.audioList.length),
                    ),
                  ),
                ],
              );
            }),
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

  Widget _buildChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    double sw,
    double sh,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: EdgeInsets.symmetric(
          horizontal: sw * 0.01,
          vertical: sh * 0.01,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8D3C1F)
              : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFF1A1A1A)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                // fontSize: 13,
                fontSize: sw * 0.03,
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
    required double sw,
    required double sh,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                // width: 16,
                // height: 16,
                width: sw * 0.04,
                height: sw * 0.04,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            // : Icon(icon, color: Colors.white, size: 16),
            : Icon(icon, color: Colors.white, size: sw * 0.04),
        label: Text(
          isLoading ? "Loading..." : label,
          style: TextStyle(
            color: Colors.white,
            // fontSize: 14,
            fontSize: sw * 0.035,
            fontWeight: FontWeight.w400,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8D3C1F),
          foregroundColor: Colors.white,
          // padding: const EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(vertical: sh * 0.012),
          shape: const StadiumBorder(),
          disabledBackgroundColor: const Color(
            0xFF8D3C1F,
          ).withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
