import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DuaApp extends StatelessWidget {
  const DuaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        primaryColor: const Color(0xFF8D4B33), // The specific brown
      ),
      home: const DuaListScreen(),
    );
  }
}

// --- Common UI Constants ---
const Color kBrown = Color(0xFF8D4B33);
const Color kBlack = Color(0xFF1E1E1E);

// --- Reusable Widgets ---

class FilterChipRow extends StatelessWidget {
  final int activeIndex;
  const FilterChipRow({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    List<String> labels = ["All Duas", "Special Days", "Before & After"];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(labels.length, (index) {
          bool isActive = index == activeIndex;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? kBrown : kBlack,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              labels[index],
              style: GoogleFonts.ebGaramond(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class DuaCard extends StatelessWidget {
  final String arabic;
  final String title;

  const DuaCard({super.key, required this.arabic, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: kBrown,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
          )
        ],
      ),
    );
  }
}

// --- Screens ---

class DuaListScreen extends StatelessWidget {
  const DuaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Duas",
          style: GoogleFonts.ebGaramond(color: Colors.black87, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const FilterChipRow(activeIndex: 0),
          Expanded(
            child: ListView(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const DuaDetailScreen())),
                  child: const DuaCard(
                    arabic: "اَللّٰهُمَّ بِكَ اَصْبَحْنَا وَبِكَ اَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوْتُ",
                    title: "Morning Dua",
                  ),
                ),
                const DuaCard(
                  arabic: "اَللّٰهُمَّ بِكَ اَصْبَحْنَا وَبِكَ اَمْسَيْنَا وَبِكَ نَحْيَا وَبِكَ نَمُوْتُ",
                  title: "Evening Dua",
                ),
                const DuaCard(
                  arabic: "بِسْمِ اللّٰهِ",
                  title: "Before Eating",
                ),
                const DuaCard(
                  arabic: "اَلْحَمْدُ لِلّٰهِ الَّذِيْ اَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِيْنَ",
                  title: "After Eating",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DuaDetailScreen extends StatelessWidget {
  const DuaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Duas", style: GoogleFonts.ebGaramond(color: Colors.black, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top Pills for Detail
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSmallPill("Dua", true),
                _buildSmallPill("Translation", false),
                _buildSmallPill("Tafsir", false),
              ],
            ),
            const SizedBox(height: 25),
            // Dua Content Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.favorite_border, color: Colors.grey, size: 20),
                  ),
                  Text(
                    "اَلْحَمْدُ لِلّٰهِ الَّذِيْ اَطْعَمَنِيْ هٰذَا وَرَزَقَنِيْهِ مِنْ غَيْرِ حَوْلٍ مِّنِّيْ وَلَا قُوَّةٍ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Al-hamdu lillāhil-ladhī at'amanī hādhā wa razaqanīhi min ghayri hawlin minnī wa lā quwwah.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ebGaramond(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Actions Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: kBrown.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _actionIcon(Icons.headset_outlined, "Listen"),
                  _actionIcon(Icons.auto_awesome_outlined, "AI Explanation"),
                  _actionIcon(Icons.share_outlined, "Share"),
                  _actionIcon(Icons.download_outlined, "Download"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Meaning Card
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
                  Text("Meaning:", style: GoogleFonts.ebGaramond(color: kBrown, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    "O Allah, send blessings upon Muhammad and the family of Muhammad as You sent blessings upon Ibrahim and his family. Indeed, You are Praiseworthy and Glorious.",
                    style: GoogleFonts.ebGaramond(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSmallPill(String text, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: active ? kBrown : kBlack,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: GoogleFonts.ebGaramond(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _actionIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: kBrown, size: 22),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.ebGaramond(fontSize: 10, color: kBrown)),
      ],
    );
  }
}