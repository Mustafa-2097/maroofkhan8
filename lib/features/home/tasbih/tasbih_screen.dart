import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- DATA MODEL ---
class TasbihData {
  final String arabic;
  final String transliteration;
  final String meaning;

  TasbihData(this.arabic, this.transliteration, this.meaning);
}

final List<TasbihData> tasbihs = [
  TasbihData("لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ", "La hawla wa la quwwata illa billah", "My Lord increase me in knowledge"),
  TasbihData("رَّبِّ زِدْنِي عِلْمًا", "Rabbi zidni ilma", "My Lord increase me in knowledge"),
  TasbihData("اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ", "Allahumma salli 'ala Muhammad", "O Allah, send blessings upon Muhammad"),
  TasbihData("سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", "Subhan Allah wa bihamdihi", "Glory be to Allah and Praise"),
  TasbihData("اللَّهُ أَكْبَرُ", "Allahu Akbar", "Allah is the Greatest"),
  TasbihData("حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ", "Hasbiyallahu la ilaha illa Huwa", "Sufficient for me is Allah"),
];

const Color primaryBrown = Color(0xFF8D3C1F);

// --- SCREEN 1: TASBIH LIST ---
class TasbihListScreen extends StatelessWidget {
  const TasbihListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Tasbih", style: GoogleFonts.playfairDisplay(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tasbihs.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TasbihCounterScreen(data: tasbihs[index]))),
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
                      Text(tasbihs[index].arabic, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(tasbihs[index].transliteration, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.play_circle_outline, color: primaryBrown, size: 20),
                  )
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
class TasbihCounterScreen extends StatefulWidget {
  final TasbihData data;
  const TasbihCounterScreen({super.key, required this.data});

  @override
  State<TasbihCounterScreen> createState() => _TasbihCounterScreenState();
}

class _TasbihCounterScreenState extends State<TasbihCounterScreen> {
  int count = 0;
  final int target = 33;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.chevron_left, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Text("Tasbih", style: GoogleFonts.playfairDisplay(color: Colors.black87, fontWeight: FontWeight.bold)),
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
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_left, color: primaryBrown),
                  Expanded(
                    child: Column(
                      children: [
                        Text(widget.data.arabic, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(widget.data.transliteration, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("Meaning : ${widget.data.meaning}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_right, color: primaryBrown),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Counter Section
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _pillButton("Reset Counter", Icons.refresh),
                        const SizedBox(width: 15),
                        _pillButton("Listen", Icons.volume_up_outlined),
                      ],
                    ),
                    const Spacer(),
                    // Circular Counter
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
                            valueColor: const AlwaysStoppedAnimation<Color>(primaryBrown),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("$count", style: GoogleFonts.playfairDisplay(fontSize: 70, fontWeight: FontWeight.bold)),
                            const Text("of", style: TextStyle(color: primaryBrown, fontWeight: FontWeight.bold, fontSize: 18)),
                            Text("$target", style: const TextStyle(fontSize: 22, color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    // Tap Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBrown,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => setState(() { if(count < target) count++; }),
                        child: const Text("Tap to Count", style: TextStyle(color: Colors.white, fontSize: 18)),
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

  Widget _pillButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87)),
          const SizedBox(width: 5),
          Icon(icon, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}