import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/audio/views/audio_list_screen.dart';
import 'package:maroofkhan8/features/audio/controller/audio_controller.dart';
import 'package:maroofkhan8/features/audio/model/audio_model.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioController());
    return Scaffold(
      appBar: AppBar(
        title: HeaderSection(title: "Audio"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.audioList.isEmpty) {
                  return const Center(child: Text("No audio found"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.audioList.length,
                  itemBuilder: (context, index) {
                    final audio = controller.audioList[index];
                    return AudioCard(
                      audio: audio,
                      onTap: () => Get.to(
                        () => AudioListScreen(
                          category: audio.category ?? "Sufi Lectures",
                        ),
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

class AudioCard extends StatelessWidget {
  final AudioData audio;
  final VoidCallback? onTap;
  const AudioCard({super.key, required this.audio, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 95,
        width: 392,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFA6A6A6), width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                radius: 28,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=3",
                ),
                backgroundColor: Colors.transparent,
              ),
            ),

            const SizedBox(width: 12),

            /// Title + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    audio.title ?? "Untitled",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    audio.subtitle ?? "Shaykh’s Lecture",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFA6A6A6),
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
                const Text(
                  "00:00", // Dynamic duration if available in model, else placeholder
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.more_horiz,
                  size: 18,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
