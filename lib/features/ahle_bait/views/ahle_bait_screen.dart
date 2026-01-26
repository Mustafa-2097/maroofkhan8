import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(0xFF1E120D); // Dark text/button color
const Color kBackground = Color(0xFFFDFDFD);
const Color kTextGrey = Color(0xFF757575);

// ==========================================
// SCREEN 1: AHLE BAIT LIST SCREEN
// ==========================================
class AhleBaitListScreen extends StatelessWidget {
  const AhleBaitListScreen({super.key});

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
              Text("أهل البيت (Ahle Bait)", style: GoogleFonts.amiri(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 5),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.playfairDisplay(fontSize: 14, color: Colors.black87),
                  children: [
                    const TextSpan(text: "refers to the household and family members of "),
                    TextSpan(text: "أهل البيت", style: GoogleFonts.amiri(fontWeight: FontWeight.bold)),
                    const TextSpan(text: "\nProphet Muhammad"),
                  ],
                ),
              ),
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
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AhleBaitDetailScreen()));
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
// SCREEN 2 & 3: DETAIL SCREEN (Tabs)
// ==========================================
class AhleBaitDetailScreen extends StatefulWidget {
  const AhleBaitDetailScreen({super.key});

  @override
  State<AhleBaitDetailScreen> createState() => _AhleBaitDetailScreenState();
}

class _AhleBaitDetailScreenState extends State<AhleBaitDetailScreen> {
  int _currentTab = 0; // 0: Bio, 1: Story, 2: Quotes/Translation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
                  ),
                ),
              ),

              // Profile Header
              const SizedBox(height: 10),
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage("https://i.pinimg.com/564x/cf/f3/f1/cff3f15c7e39a0468945325793086381.jpg"),
              ),
              const SizedBox(height: 15),
              Text("Ali ibn Abi Talib", style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("علي بن أبي طالب", style: GoogleFonts.amiri(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Custom Tab Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tabButton("Biography", 0),
                  const SizedBox(width: 10),
                  _tabButton("Story", 1),
                  const SizedBox(width: 10),
                  _tabButton(_currentTab == 1 ? "Translation" : "Quotes", 2),
                ],
              ),
              const SizedBox(height: 20),

              // Content Handling
              if (_currentTab == 0) _buildBiographySection(),
              if (_currentTab == 1) _buildStoryPlayerSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String text, int index) {
    bool isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? kPrimaryBrown : kDarkButton,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- TAB CONTENT 1: BIOGRAPHY ---
  Widget _buildBiographySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Biography", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            children: [
              _bioRow("Name :", "Abdullah ibn Abi Quhafah."),
              _bioRow("Born :", "Born in 573 CE in\nMecca, Arabia."),
              _bioRow("Died :", "Died in 634 CE in Medina, aged 63"),
              _bioRow("Position :", "First Caliph of Islam (632–634 CE)"),
              _bioRow("Institution :", "Islamic Leadership"),
              _bioRow("Works :", "Leadership as First Caliph"),
              _bioRow("Known For :", "Closest Companion of Prophet ﷺ –\nunwavering\nsupport throughout Prophet's mission"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bioRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4)),
          ),
        ],
      ),
    );
  }

  // --- TAB CONTENT 2: STORY / PLAYER ---
  Widget _buildStoryPlayerSection() {
    return Column(
      children: [
        // Text Content Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            children: [
              const Align(alignment: Alignment.topRight, child: Icon(Icons.bookmark_border, size: 20, color: Colors.grey)),
              Text(
                "Ali ibn Abi Talib (رضي الله عنه) was born in 600 CE in Makkah. He was the cousin of Prophet Muhammad ﷺ and was raised in the Prophet's household from a young age. Ali grew up witnessing the Prophet's honesty, character, and worship.",
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(fontSize: 14, color: Colors.black87, height: 1.6),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Audio Player
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("02:25", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text("10:25", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: kPrimaryBrown,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: kPrimaryBrown,
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(value: 0.25, onChanged: (v) {}),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.skip_previous, size: 24, color: Colors.black),
            SizedBox(width: 30),
            Icon(Icons.play_circle_outline, size: 35, color: Colors.black),
            SizedBox(width: 30),
            Icon(Icons.skip_next, size: 24, color: Colors.black),
          ],
        ),
        const SizedBox(height: 30),

        // Bottom Actions Pill
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: kPrimaryBrown.withOpacity(0.5)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomAction(Icons.headset, "Listen", true),
              Container(height: 30, width: 1, color: Colors.grey.shade300),
              _bottomAction(Icons.auto_awesome, "AI Explanation", false),
              Container(height: 30, width: 1, color: Colors.grey.shade300),
              _bottomAction(Icons.share_outlined, "Share", false),
              Container(height: 30, width: 1, color: Colors.grey.shade300),
              _bottomAction(Icons.download_outlined, "Download", false),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _bottomAction(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: isActive ? kPrimaryBrown : Colors.black),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 9, color: isActive ? kPrimaryBrown : Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }
}