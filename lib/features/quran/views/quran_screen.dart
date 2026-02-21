import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';

import '../../ai_murshid/views/ai_murshid_screen.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkBlack = Color(0xFF1E120D);
const Color kLightGrey = Color(0xFFA4AFC1);

// --- MAIN CONTAINER WITH BOTTOM NAV ---
class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _MainContainerState();
}

class _MainContainerState extends State<QuranScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const QuranTabsScreen(),
    );
  }
}

// --- SCREEN 1, 2, 3: QURAN TABS ---
class QuranTabsScreen extends StatefulWidget {
  const QuranTabsScreen({super.key});

  @override
  State<QuranTabsScreen> createState() => _QuranTabsScreenState();
}

class _QuranTabsScreenState extends State<QuranTabsScreen> {
  int _selectedTab = 0; // 0: Surah, 1: Juz, 2: Last Read

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 10),
          const HeaderDecoration(title: "Al Quran"),
          const SizedBox(height: 15),
          const SearchAndBookmark(),
          const SizedBox(height: 15),
          // Tab Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _tabButton("Surah", 0),
                const SizedBox(width: 8),
                _tabButton("Juz", 1),
                const SizedBox(width: 8),
                _tabButton("Last Read", 2, icon: Icons.access_time),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index, {IconData? icon}) {
    bool isSelected = _selectedTab == index;
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryBrown : isDark ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 16, color: isSelected ? Colors.white : isDark ? Colors.black : Colors.white), const SizedBox(width: 5)],
              Text(label, style: TextStyle(color: isSelected ? Colors.white : isDark ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 1: // Juz List
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 8,
          itemBuilder: (context, i) => _listTile("${i + 1}", "Para - ${i + 1}", "286 Ayah", null),
        );
      case 2: // Last Read
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 8,
          itemBuilder: (context, i) => _listTile("${i + 1}", "Alif Laam Meem", "The Beginning of the Qur'an", "10 minutes ago"),
        );
      default: // Surah List
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 8,
          itemBuilder: (context, i) => _listTile("${i + 1}", i == 0 ? "Al Baqarah" : "Al Imran", "The Family of Imran  | 286 Ayah  |  Makki Surah", null),
        );
    }
  }

  Widget _listTile(String num, String title, String sub, String? time) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuranDetailsScreen())),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                HexagonBadge(number: num),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(sub, style: const TextStyle(fontSize: 14, color: Color(0xFF6F8DA1), fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                if (time != null) Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF6F8DA1))),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.stroke),
        ],
      ),
    );
  }
}

// --- SCREEN 4 & 5: QURAN DETAILS ---
class QuranDetailsScreen extends StatefulWidget {
  const QuranDetailsScreen({super.key});

  @override
  State<QuranDetailsScreen> createState() => _QuranDetailsScreenState();
}

class _QuranDetailsScreenState extends State<QuranDetailsScreen> {
  int _activeDetailTab = 0; // 0: Surah, 1: Tafsir, 2: AI Explanation

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Header with back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                        visualDensity: VisualDensity.compact),
                  ),
                  const HeaderDecoration(title: "Al Baqarah"),
                  const Align(alignment: Alignment.centerRight, child: Text("1", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            Text(
              "Read  •  Listen  •  Understand",
              style: TextStyle(fontSize: 12, color: isDark ? AppColors.whiteColor : Colors.black87),
            ),
            const SizedBox(height: 15),
            // Detail Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _detailTab("Surah", 0),
                  const SizedBox(width: 10),
                  _detailTab("Tafsir", 1),
                  const SizedBox(width: 10),
                  _detailTab("AI Explanation", 2),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _activeDetailTab == 0 ? _buildSurahReader() : _buildTafsirReader(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _detailTab(String label, int index) {
    bool isSelected = _activeDetailTab == index;
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 2) {
            // 1. If AI Explanation is clicked, navigate to ChatScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          } else {
            // 2. Otherwise, just switch the local tab (Surah or Tafsir)
            setState(() => _activeDetailTab = index);
          }
        },
        child: Container(
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryBrown : isDark ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : isDark ? Colors.black : Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildSurahReader() {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Audio Player Simulation
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("02:25", style: TextStyle(fontSize: 12, color: isDark ? AppColors.whiteColor : Colors.black87)),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(value: 0.3, onChanged: (v) {}, activeColor: kPrimaryBrown, inactiveColor: Colors.grey.shade300),
                ),
                Text("10:25", style: TextStyle(fontSize: 12, color: isDark ? AppColors.whiteColor : Colors.black87)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.skip_previous, color: isDark ? AppColors.whiteColor : Colors.black87),
                SizedBox(width: 20),
                Icon(Icons.play_circle_filled, size: 40, color: isDark ? AppColors.whiteColor : Colors.black87),
                SizedBox(width: 20),
                Icon(Icons.skip_next, color: isDark ? AppColors.whiteColor : Colors.black87),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 10,
            itemBuilder: (context, i) => _verseItem(i + 1),
          ),
        ),
      ],
    );
  }

  Widget _buildTafsirReader() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 10,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [Icon(Icons.menu_book, size: 16, color: kPrimaryBrown), SizedBox(width: 8), Text("Verse 1:", style: TextStyle(fontWeight: FontWeight.bold))],
            ),
            const SizedBox(height: 10),
            const Text(
              "These are muqatta'at — disconnected letters. Scholars say their precise meaning is known only to Allah. They draw attention to the miraculous nature of the Qur'an, which is composed of familiar Arabic letters yet cannot be matched by human speech.",
              style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verseItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text("ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ",
                          textAlign: TextAlign.right, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.8)),
                    ),
                    const SizedBox(height: 10),
                    const Text("Zaalikal kitaabu laa raiba feeh, hudal lil-muttaqeen", style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: kLightGrey)),
                    const SizedBox(height: 8),
                    const Text("This is the Book about which there is no doubt, a guidance for the righteous.", style: TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  Text("$index", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  const Icon(Icons.share_outlined, size: 16, color: Colors.grey),
                  const SizedBox(height: 5),
                  const Icon(Icons.play_circle_outline, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1, color: Color(0xFFF1F1F1)),
        ],
      ),
    );
  }
}

// --- HELPER WIDGETS ---
class HeaderDecoration extends StatelessWidget {
  final String title;
  const HeaderDecoration({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 60, height: 1, color: Colors.grey.shade300),
        const SizedBox(width: 10),
        const Icon(Icons.circle, size: 4, color: kPrimaryBrown),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        const Icon(Icons.circle, size: 4, color: kPrimaryBrown),
        const SizedBox(width: 10),
        Container(width: 60, height: 1, color: Colors.grey.shade300),
      ],
    );
  }
}

class SearchAndBookmark extends StatelessWidget {
  const SearchAndBookmark({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: isDark ? kDarkBlack : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.stroke),
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
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: isDark ? kDarkBlack : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Icon(Icons.bookmark_outline, color: AppColors.stroke, size: 20),
          ),
        ],
      ),
    );
  }
}

class HexagonBadge extends StatelessWidget {
  final String number;
  const HexagonBadge({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: _HexagonClipper(),
          child: Container(width: 38, height: 38, color: kPrimaryBrown),
        ),
        Text(number, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(0, size.height * 0.75);
    path.lineTo(0, size.height * 0.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}