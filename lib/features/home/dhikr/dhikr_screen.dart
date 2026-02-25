import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- DATA MODEL ---
class DhikrData {
  final String arabic;
  final String transliteration;
  final String meaning;

  DhikrData(this.arabic, this.transliteration, this.meaning);
}

final List<DhikrData> tasbihs = [
  DhikrData(
    "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
    "La hawla wa la quwwata illa billah",
    "My Lord increase me in knowledge",
  ),
  DhikrData(
    "رَّبِّ زِدْنِي عِلْمًا",
    "Rabbi zidni ilma",
    "My Lord increase me in knowledge",
  ),
  DhikrData(
    "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ",
    "Allahumma salli 'ala Muhammad",
    "O Allah, send blessings upon Muhammad",
  ),
  DhikrData(
    "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
    "Subhan Allah wa bihamdihi",
    "Glory be to Allah and Praise",
  ),
  DhikrData("اللَّهُ أَكْبَرُ", "Allahu Akbar", "Allah is the Greatest"),
  DhikrData(
    "حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ",
    "Hasbiyallahu la ilaha illa Huwa",
    "Sufficient for me is Allah",
  ),
];

const Color primaryBrown = Color(0xFF8D3C1F);

// --- SCREEN 1: TASBIH LIST ---
class DhikrListScreen extends StatelessWidget {
  const DhikrListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Text(
          "Dhikr",
          style: GoogleFonts.playfairDisplay(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tasbihs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DhikrCounterScreen(initialIndex: index),
              ),
            ),
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
                        tasbihs[index].arabic,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tasbihs[index].transliteration,
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
      ),
    );
  }
}

// --- SCREEN 2: TASBIH COUNTER ---
class DhikrCounterScreen extends StatefulWidget {
  final int initialIndex;
  const DhikrCounterScreen({super.key, required this.initialIndex});

  @override
  State<DhikrCounterScreen> createState() => _DhikrCounterScreenState();
}

class _DhikrCounterScreenState extends State<DhikrCounterScreen> {
  int count = 0;
  late int currentIndex;
  final int target = 33;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _nextDhikr() {
    setState(() {
      currentIndex = (currentIndex + 1) % tasbihs.length;
      count = 0;
    });
  }

  void _previousDhikr() {
    setState(() {
      currentIndex = (currentIndex - 1 + tasbihs.length) % tasbihs.length;
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = tasbihs[currentIndex];

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Dhikr",
          style: GoogleFonts.playfairDisplay(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                    color: Colors.black.withOpacity(0.03),
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
                          data.arabic,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          data.transliteration,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Meaning : ${data.meaning}",
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
              child: Container(
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
                    SizedBox(height: 50),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 220,
                          width: 220,
                          child: CircularProgressIndicator(
                            value: count / target,
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
                    SizedBox(height: 50),
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
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
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
