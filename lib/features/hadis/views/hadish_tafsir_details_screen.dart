import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HadishTafsirDetailsScreen extends StatelessWidget {
  const HadishTafsirDetailsScreen({super.key});

  final Color primaryBrown = const Color(0xFF8D3C1F);
  final Color darkBlack = const Color(0xFF1E120D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
                  ),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E2E2E),
                      ),
                      children: [
                        const TextSpan(text: "Sahih al-Bukhari-"),
                        TextSpan(text: "(Volume-1)", style: TextStyle(color: primaryBrown)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40), // Balance back button
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Volume 1 > Book 1 > Hadith 1", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(width: 80),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Icon(Icons.bookmark_outline, size: 18, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // --- TABS ---
              Row(
                children: [
                  _tabButton("Tafsir", darkBlack, Colors.white),
                ],
              ),

              const SizedBox(height: 25),

              // --- MAIN HADITH CARD ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.bookmark, color: Color(0xFF2E2E2E), size: 20),
                    ),
                    const Text(
                      "الرَّاحِمُونَ يَرْحَمُهُمُ الرَّحْمَنُ، ارْحَمُوا مَنْ فِي الْأَرْضِ يَرْحَمْكُمْ مَنْ فِي السَّمَاءِ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.6),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Ar-rahi-moo-na yar-ha-mu-hu-mur Rah-maan, ir-ha-moo\nman fee al-ard, yar-ham-kum man fee as-sa-maa.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF2E2E2E)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Sahih al-Bukhari -  Volume 1 • Hadith 1",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --- ACTION BAR ---
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryBrown.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionIcon(Icons.headphones_outlined, "Listen"),
                    _actionIcon(Icons.auto_awesome_outlined, "AI Explanation"),
                    _actionIcon(Icons.share_outlined, "Share"),
                    _actionIcon(Icons.download_outlined, "Download"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --- EXPLANATION SECTION ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Simple Explanation", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Text(
                      "This Hadith teaches that intention is the foundation of all actions in Islam.",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                    ),
                    const SizedBox(height: 150), // For scroll room
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String text, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: primaryBrown, size: 22),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: primaryBrown, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}