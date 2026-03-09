import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/allah_names_controller.dart';
import 'allah_names.dart';
import 'package:easy_localization/easy_localization.dart';

class SavedAllahNamesScreen extends StatelessWidget {
  const SavedAllahNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AllahNamesController>();
    const Color kBackground = Color(0xFFF9F9FC);

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Container(
          width: double.infinity,
          height: 45,
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            tr("saved"),
            style: GoogleFonts.playfairDisplay(
              color: const Color(0xFF2E2E2E),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isSavedLoading.value &&
            controller.savedNamesList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final savedNames = controller.savedNamesList;

        if (savedNames.isEmpty) {
          return Center(child: Text(tr("no_saved_names_yet")));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: savedNames.length,
          itemBuilder: (context, index) {
            final nameItem = savedNames[index];
            return NameCard(
              data: nameItem,
              onTap: () {
                controller.isPlayingFromSaved.value = true;
                controller.currentAudioIndex.value = index;
                showDialog(
                  context: context,
                  builder: (_) => const PlayerDialog(),
                );
              },
            );
          },
        );
      }),
    );
  }
}
