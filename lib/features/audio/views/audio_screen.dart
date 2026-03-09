import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/audio/views/audio_list_screen.dart';
import 'package:maroofkhan8/features/audio/controller/audio_controller.dart';
import 'package:maroofkhan8/features/audio/model/audio_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final controller = Get.put(AudioController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAudios(category: "All");
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: HeaderSection(title: tr("audio_title")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchAudios(category: "All"),
          child: Column(
            children: [
              // const SizedBox(height: 8),
              SizedBox(height: sh * 0.01),

              /// List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.audioList.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: Text(
                              tr("no_audio_found"),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    // padding: const EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.04),
                    itemCount: controller.audioList.length,
                    itemBuilder: (context, index) {
                      final audio = controller.audioList[index];
                      return AudioCard(
                        audio: audio,
                        onTap: () {
                          // Correctly map backend category to UI label for AudioListScreen
                          String categoryToPass =
                              controller.reverseCategoryMapping[audio
                                  .category] ??
                              audio.category ??
                              "Sufi Lectures";
                          Get.to(
                            () => AudioListScreen(
                              category: categoryToPass,
                              initialAudioId: audio.id,
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioCard extends StatelessWidget {
  final AudioData audio;
  final VoidCallback? onTap;
  const AudioCard({super.key, required this.audio, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = AudioController.instance;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 95,
        // width: 392,
        height: sh * 0.11,
        width: double.infinity,
        // margin: const EdgeInsets.only(bottom: 16),
        // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: EdgeInsets.only(bottom: sh * 0.018),
        padding: EdgeInsets.symmetric(
          horizontal: sw * 0.03,
          vertical: sh * 0.012,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : const Color(0xFFA6A6A6),
            width: 1,
          ),
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          // borderRadius: BorderRadius.circular(16),
          borderRadius: BorderRadius.circular(sw * 0.04),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                color: Color(0xFF24255B),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                // radius: 28,
                radius: sw * 0.07,
                backgroundImage: const NetworkImage(
                  "https://i.pravatar.cc/150?img=3",
                ),
                backgroundColor: Colors.transparent,
              ),
            ),

            // const SizedBox(width: 12),
            SizedBox(width: sw * 0.03),

            /// Title + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    audio.title ?? tr("untitled"),
                    style: TextStyle(
                      // fontSize: 20,
                      fontSize: sw * 0.045,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const SizedBox(height: 4),
                  SizedBox(height: sh * 0.005),
                  Text(
                    audio.subtitle ?? tr("shaykh_lecture"),
                    style: TextStyle(
                      // fontSize: 16,
                      fontSize: sw * 0.035,
                      color: const Color(0xFFA6A6A6),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            /// Duration + Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  final duration = controller.cachedDurations[audio.id ?? ''];
                  return Text(
                    localizeDigits(duration ?? "00:00", context),
                    style: TextStyle(
                      // fontSize: 12,
                      fontSize: sw * 0.03,
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }),
                // const SizedBox(width: 8),
                SizedBox(width: sw * 0.02),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'share') {
                      controller.shareAudio(audio);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          const Icon(Icons.share, size: 20),
                          const SizedBox(width: 8),
                          Text(tr('share')),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_horiz,
                    // size: 18,
                    size: sw * 0.045,
                    color: isDark
                        ? Colors.grey[400]
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
