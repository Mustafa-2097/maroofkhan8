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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF9F9FC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Container(
          width: double.infinity,
          height: sh * 0.055,
          margin: EdgeInsets.only(right: sw * 0.05),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            tr("saved"),
            style: GoogleFonts.playfairDisplay(
              color: isDark ? Colors.white : const Color(0xFF2E2E2E),
              fontWeight: FontWeight.w500,
              fontSize: sw * 0.045,
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
          return Center(
            child: Text(
              tr("no_saved_names_yet"),
              style: TextStyle(color: isDark ? Colors.grey[400] : Colors.black),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: sw * 0.04,
            mainAxisSpacing: sh * 0.018,
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
