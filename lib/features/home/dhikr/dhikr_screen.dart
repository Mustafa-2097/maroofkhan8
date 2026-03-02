import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'controllers/dhikr_controller.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: HeaderSection(title: "Dhikr"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.hideBack
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 20,
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
          return const Center(child: Text("No Dhikr found"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.tasbihList.length,
          itemBuilder: (context, index) {
            final dhikr = controller.tasbihList[index];
            return GestureDetector(
              onTap: () =>
                  Get.to(() => DhikrCounterScreen(initialIndex: index)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dhikr.arabic,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dhikr.pronunciation,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.arrow_circle_right_outlined,
                        color: primaryBrown,
                        size: 20,
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
    setState(() {
      currentIndex = (currentIndex + 1) % controller.tasbihList.length;
      count = 0;
    });
  }

  void _previousDhikr() {
    setState(() {
      currentIndex =
          (currentIndex - 1 + controller.tasbihList.length) %
          controller.tasbihList.length;
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.tasbihList.isEmpty) {
      return const Scaffold(body: Center(child: Text("Empty list")));
    }
    final dhikr = controller.tasbihList[currentIndex];
    final int target = dhikr.count;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: HeaderSection(title: "Dhikr"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.hideBack
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // Top Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _previousDhikr,
                    icon: const Icon(Icons.arrow_drop_up, color: primaryBrown),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          dhikr.arabic,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          dhikr.pronunciation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Meaning : ${dhikr.meaning}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _nextDhikr,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: primaryBrown,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Counter Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _pillButton(
                        "Reset Counter",
                        Icons.refresh,
                        () => setState(() => count = 0),
                      ),
                      const SizedBox(width: 15),
                      _pillButton("Listen", Icons.volume_up_outlined),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 220,
                        width: 220,
                        child: CircularProgressIndicator(
                          value: target > 0 ? count / target : 0,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            primaryBrown,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$count",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "of",
                            style: TextStyle(
                              color: primaryBrown,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "$target",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // Tap Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBrown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => setState(() {
                        if (count < target) count++;
                      }),
                      child: const Text(
                        "Tap to Count",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color.fromARGB(221, 0, 0, 0),
              ),
            ),
            const SizedBox(width: 5),
            Icon(icon, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
