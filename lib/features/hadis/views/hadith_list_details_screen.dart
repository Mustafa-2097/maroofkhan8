import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'hadish_tafsir_details_screen.dart';

class HadithListDetailsScreen extends StatelessWidget {
  const HadithListDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBrown = Color(0xFF8D3C1F);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // 1. Header with custom title and lines
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _backButton(),
                  const Expanded(child: Divider(indent: 10, endIndent: 10, color: Colors.grey, thickness: 0.5)),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      children: const [
                        TextSpan(text: "Sahih al-Bukhari-"),
                        TextSpan(text: "(Volume-1)", style: TextStyle(color: primaryBrown)),
                      ],
                    ),
                  ),
                  const Expanded(child: Divider(indent: 10, endIndent: 10, color: Colors.grey, thickness: 0.5)),
                  const SizedBox(width: 40), // Placeholder for balance
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 2. Search Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _iconContainer(Icons.bookmark_outline),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 3. Scrollable Hadith List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  HadithCard(
                    arabic: "إنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ",
                    english: "“Actions are judged by intentions...”",
                    hadithNumber: 1,
                  ),
                  HadithCard(
                    arabic: "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ",
                    english: "“Whoever believes in Allah and the Last Day should speak good or remain silent.”",
                    hadithNumber: 2,
                  ),
                  HadithCard(
                    arabic: "الرَّاحِمُونَ يَرْحَمُهُمُ الرَّحْمَنُ، ارْحَمُوا مَنْ فِي الْأَرْضِ يَرْحَمْكُمْ مَنْ فِي السَّمَاءِ",
                    english: "“The merciful are shown mercy by the Most Merciful. Be merciful to those on earth, and the One above the heavens will have mercy upon you.”",
                    hadithNumber: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
    );
  }

  Widget _iconContainer(IconData icon) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Icon(icon, color: Colors.grey.shade300),
    );
  }
}

class HadithCard extends StatelessWidget {
  final String arabic;
  final String english;
  final int hadithNumber;

  const HadithCard({
    super.key,
    required this.arabic,
    required this.english,
    required this.hadithNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            arabic,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.5,
              color: Color(0xFF2E2E2E),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            english,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Sahih al-Bukhari -  Volume 1 • Hadith $hadithNumber",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const Divider(height: 30, color: Color(0xFFEEEEEE)),
          Row(
            children: [
              const Icon(Icons.favorite_border, size: 18, color: Colors.grey),
              const SizedBox(width: 15),
              const Icon(Icons.share_outlined, size: 18, color: Colors.grey),
              const Spacer(),
              _footerAction(Icons.volume_up_outlined, "Listen"),
              const SizedBox(width: 15),
              GestureDetector(
                  onTap: (){
                    Get.to(HadishTafsirDetailsScreen());
                  },
                  child: _footerAction(Icons.visibility_outlined, "Full View")),
            ],
          )
        ],
      ),
    );
  }

  Widget _footerAction(IconData icon, String label) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 5),
        Icon(icon, size: 16, color: const Color(0xFF8D3C1F)),
      ],
    );
  }
}