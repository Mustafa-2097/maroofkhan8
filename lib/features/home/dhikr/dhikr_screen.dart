import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'controllers/dhikr_controller.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

const Color primaryBrown = Color(0xFF8D3C1F);

// --- SCREEN 1: TASBIH LIST ---
class DhikrListScreen extends StatefulWidget {
  final bool hideBack;
  const DhikrListScreen({super.key, this.hideBack = false});

  @override
  State<DhikrListScreen> createState() => _DhikrListScreenState();
}

class _DhikrListScreenState extends State<DhikrListScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DhikrController());
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: HeaderSection(title: tr("dhikr")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.hideBack
            ? null
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? Colors.white70 : Colors.grey,
                  size: sw * 0.05,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryBrown),
          );
        }
        if (controller.tasbihList.isEmpty) {
          return Center(
            child: Text(
              tr("no_dhikr_found"),
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.black87,
              ),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(sw * 0.05),
          itemCount: controller.tasbihList.length,
          itemBuilder: (context, index) {
            final dhikr = controller.tasbihList[index];
            return GestureDetector(
              onTap: () =>
                  Get.to(() => DhikrCounterScreen(initialIndex: index)),
              child: Container(
                margin: EdgeInsets.only(bottom: sh * 0.018),
                padding: EdgeInsets.all(sw * 0.05),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dhikr.arabic,
                          style: TextStyle(
                            fontSize: sw * 0.045,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: sh * 0.01),
                        Text(
                          dhikr.pronunciation,
                          style: TextStyle(
                            fontSize: sw * 0.033,
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: primaryBrown,
                        size: sw * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// --- SCREEN 2: TASBIH COUNTER ---
class DhikrCounterScreen extends StatefulWidget {
  final int initialIndex;
  final bool hideBack;
  const DhikrCounterScreen({
    super.key,
    required this.initialIndex,
    this.hideBack = false,
  });

  @override
  State<DhikrCounterScreen> createState() => _DhikrCounterScreenState();
}

class _DhikrCounterScreenState extends State<DhikrCounterScreen> {
  final DhikrController controller = Get.find<DhikrController>();
  int count = 0;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _nextDhikr() {
    controller.stopTasbihAudio();
    setState(() {
      currentIndex = (currentIndex + 1) % controller.tasbihList.length;
      count = 0;
    });
  }

  void _previousDhikr() {
    controller.stopTasbihAudio();
    setState(() {
      currentIndex =
          (currentIndex - 1 + controller.tasbihList.length) %
          controller.tasbihList.length;
      count = 0;
    });
  }

  @override
  void dispose() {
    controller.stopTasbihAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.tasbihList.isEmpty) {
      return Scaffold(body: Center(child: Text(tr("empty_list"))));
    }
    final dhikr = controller.tasbihList[currentIndex];
    final int target = dhikr.count;
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: HeaderSection(title: tr("dhikr")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.hideBack
            ? null
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? Colors.white70 : Colors.grey,
                  size: sw * 0.05,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: Padding(
        padding: EdgeInsets.all(sw * 0.06),
        child: Column(
          children: [
            // Top Card
            Container(
              padding: EdgeInsets.all(sw * 0.05),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _previousDhikr,
                    icon: Icon(
                      Icons.arrow_drop_up,
                      color: primaryBrown,
                      size: sw * 0.075,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          dhikr.arabic,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: sw * 0.04,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: sh * 0.005),
                        Text(
                          dhikr.pronunciation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: sw * 0.03,
                            color: isDark ? Colors.grey[400] : Colors.grey,
                          ),
                        ),
                        SizedBox(height: sh * 0.005),
                        Text(
                          "${tr("meaning_colon")} ${dhikr.meaning}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: sw * 0.03,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey[300] : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _nextDhikr,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: primaryBrown,
                      size: sw * 0.075,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sh * 0.035),
            // Counter Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(sw * 0.07),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _pillButton(
                        tr("reset_counter"),
                        Icons.refresh,
                        () => setState(() => count = 0),
                      ),
                      SizedBox(width: sw * 0.04),
                      Obx(() {
                        final bool isLoading = controller.isAudioLoading.value &&
                            controller.currentPlayingId.value == dhikr.id;
                        final bool isPlaying =
                            controller.currentPlayingId.value == dhikr.id &&
                                controller.isPlaying.value;

                        return _pillButton(
                          isLoading
                              ? tr("loading_dots")
                              : (isPlaying ? tr("pause") : tr("listen")),
                          isLoading
                              ? Icons.hourglass_empty
                              : (isPlaying
                                  ? Icons.pause_circle_outline
                                  : Icons.volume_up_outlined),
                          () => controller.playTasbihAudio(dhikr),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: sh * 0.06),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: sw * 0.55,
                        width: sw * 0.55,
                        child: CircularProgressIndicator(
                          value: target > 0 ? count / target : 0,
                          strokeWidth: sw * 0.03,
                          backgroundColor: isDark
                              ? Colors.grey.shade900
                              : Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            primaryBrown,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            localizeDigits("$count", context),
                            style: GoogleFonts.playfairDisplay(
                              fontSize: sw * 0.17,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            tr("of"),
                            style: TextStyle(
                              color: primaryBrown,
                              fontWeight: FontWeight.bold,
                              fontSize: sw * 0.045,
                            ),
                          ),
                          Text(
                            localizeDigits("$target", context),
                            style: TextStyle(
                              fontSize: sw * 0.055,
                              color: isDark ? Colors.grey[500] : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.06),
                  // Tap Button
                  SizedBox(
                    width: double.infinity,
                    height: sh * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBrown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => setState(() {
                        if (count < target) count++;
                      }),
                      child: Text(
                        tr("tap_to_count"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: sw * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pillButton(String label, IconData icon, [VoidCallback? onTap]) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sw * 0.3,
        padding: EdgeInsets.symmetric(horizontal: sw * 0.03, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252525) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: sw * 0.028,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            SizedBox(width: sw * 0.01),
            Icon(
              icon,
              size: sw * 0.035,
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
