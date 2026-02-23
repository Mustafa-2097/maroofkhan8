import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(0xFF1E120D);
const Color kBackground = Color(0xFFF9F9FB);
const Color kCardColor = Colors.white;
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class IslamicStoriesScreen extends StatelessWidget {
  const IslamicStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // The image shows no app bar title, but system status bar.
        // We leave this empty or handle safe area.
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Header Text
              Text("Islamic Stories", style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),

              const SizedBox(height: 20),

              // Search Bar
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // List Items
              Expanded(
                child: ListView(
                  children: [
                    _ahleBaitCard(
                      context,
                      "Ali ibn Abi Talib",
                      "Cousin & son-in-law of Prophet\nFourth Caliph",
                      "https://i.pinimg.com/564x/cf/f3/f1/cff3f15c7e39a0468945325793086381.jpg",
                    ),
                    _ahleBaitCard(
                      context,
                      "Hasan ibn Ali",
                      "Grandson of Prophet peace\nadvocate",
                      "https://i.pinimg.com/564x/24/c9/22/24c92250106634710156d95958288593.jpg",
                    ),
                    _ahleBaitCard(
                      context,
                      "Husayn ibn Ali",
                      "Grandson of Prophet martyr of\nKarbala",
                      "https://i.pinimg.com/564x/d9/15/84/d9158498877569752943391740924976.jpg",
                    ),
                    _ahleBaitCard(
                      context,
                      "Muhsin ibn Ali",
                      "Son of Ali & Fatimah (in some\nnarrations",
                      "https://i.pinimg.com/564x/78/33/c4/7833c46114a873832349072973167909.jpg",
                    ),
                    _ahleBaitCard(
                      context,
                      "Fatimah bint Muhammad",
                      "Daughter of Prophet mother of\nHasan & Husayn",
                      "https://i.pinimg.com/564x/72/06/00/720600a943890288863266943632204c.jpg",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ahleBaitCard(BuildContext context, String name, String desc, String img) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicStoriesDetailScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundImage: NetworkImage(img)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 11, color: kTextGrey), maxLines: 2),
                ],
              ),
            ),
            Container(
              height: 30, width: 30,
              decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2: SALAWAT DETAIL / PLAYER
// ==========================================
class IslamicStoriesDetailScreen extends StatelessWidget {
  const IslamicStoriesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Title Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
              ),
              child: Text(
                "Durood Ibrahim (The Most Well-Known Salawat)",
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Main Content Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Allah created Adam and taught him the names of all things. He then commanded the angels to prostrate to Adam as a sign of honor. All obeyed except Iblis, who refused out of arrogance."
                      "Adam and his wife were placed in Jannah, with one command: not to approach a specific tree. Iblis deceived them, and they ate from it. Realizing their mistake, Adam and his wife repented sincerely."
                        "Allah forgave them and sent them to the earth, promising guidance for those who follow His commands.",
                    style: TextStyle(
                      fontSize: 14,
                      color: kTextDark,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Action Buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: kPrimaryBrown.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ActionButton(icon: Icons.headset, label: "Listen", isActive: true),

                  _ActionButton(icon: Icons.auto_awesome, label: "AI Explanation", isActive: false),

                  _ActionButton(icon: Icons.share_outlined, label: "Share", isActive: false),

                  _ActionButton(icon: Icons.copy, label: "Copy", isActive: false),
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
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Simple Explanation:", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryBrown)),
                  const SizedBox(height: 5),
                  const Text(
                    "This Hadith teaches that intention is the foundation of all actions in Islam.",
                    style: TextStyle(fontSize: 14, height: 1.4, color: kTextDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _ActionButton({required this.icon, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: isActive ? kPrimaryBrown : Colors.black),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isActive ? kPrimaryBrown : Colors.black,
          ),
        ),
      ],
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
        ),
      ),
    ),
    centerTitle: true,
    title: Text(
      "Islamic Stories",
      style: GoogleFonts.playfairDisplay(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );
}