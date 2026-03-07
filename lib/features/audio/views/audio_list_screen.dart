import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/audio/views/audio_screen.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/audio/controller/audio_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

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
          controller.playAudio(selectedAudio);
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
    context.locale; // Trigger rebuild on locale change
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: HeaderSection(title: tr("audio_list_title")),
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
                String catKey = cat == "Sufi Lectures"
                    ? "cat_sufi_lectures"
                    : cat == "Malfuzat"
                    ? "cat_malfuzat"
                    : "cat_naats_manqabats";
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: cat != categories.last ? 8 : 0,
                    ),
                    child: _buildChip(tr(catKey), selectedCategory == cat, () {
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
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tr("no_audio_found_category"),
                        style: TextStyle(
                          fontSize: 18,
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
                            // Use the tracked featured audio from controller
                            final featuredAudio =
                                controller.featuredAudio.value;
                            if (featuredAudio == null) {
                              return SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(tr("no_featured_audio")),
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
                                                      tr('trust_in_allah'),
                                                  style: GoogleFonts.amiri(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.1,
                                                  ),
                                                ),
                                                Text(
                                                  featuredAudio.subtitle ??
                                                      tr('shaykh_lecture'),
                                                  style: const TextStyle(
                                                    fontSize: 16,
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
                                                    const Icon(
                                                      Icons.share,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(tr('share')),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            child: const Icon(
                                              Icons.more_horiz,
                                              size: 24,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Text(
                                            isCurrentlyPlaying
                                                ? localizeDigits(
                                                    _formatDuration(
                                                      controller
                                                          .currentDuration
                                                          .value,
                                                    ),
                                                    context,
                                                  )
                                                : localizeDigits(
                                                    '00:00',
                                                    context,
                                                  ),
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
                                                ? localizeDigits(
                                                    _formatDuration(
                                                      controller
                                                          .totalDuration
                                                          .value,
                                                    ),
                                                    context,
                                                  )
                                                : localizeDigits(
                                                    '00:00',
                                                    context,
                                                  ),
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
                                                ? tr('pause')
                                                : tr('listen'),
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
                                          ),
                                          const SizedBox(width: 16),
                                          _buildActionButton(
                                            icon: Icons.file_download_outlined,
                                            label: tr('download_premium'),
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
                  SliverPadding(
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
          isLoading ? tr("loading_dots") : label,
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
          disabledBackgroundColor: const Color(
            0xFF8D3C1F,
          ).withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
