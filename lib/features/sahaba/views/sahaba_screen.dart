import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkButton = Color(0xFF1E120D); // Darker brown/black for inactive tabs
const Color kBackground = Color(0xFFFDFDFD);
const Color kTextGrey = Color(0xFF757575);


// ==========================================
// SCREEN 1: SAHABA LIST
// ==========================================
class SahabaListScreen extends StatelessWidget {
  const SahabaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Sahaba", style: GoogleFonts.playfairDisplay(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.chevron_left, color: Colors.black),
        actions: const [Icon(Icons.more_horiz, color: Colors.transparent)], // Spacing
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
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
                  _sahabaCard(
                      context,
                      "Abu Bakr As-Siddiq",
                      "First Caliph & closest companion of Prophet",
                      "https://i.pinimg.com/564x/24/c9/22/24c92250106634710156d95958288593.jpg" // Placeholder URL
                  ),
                  _sahabaCard(
                      context,
                      "Umar ibn Al-Khattab",
                      "Second Caliph & just leader of Islam",
                      "https://i.pinimg.com/564x/d9/15/84/d9158498877569752943391740924976.jpg"
                  ),
                  _sahabaCard(
                      context,
                      "Uthman ibn Affan",
                      "Third Caliph & compiler of the Qur'an",
                      "https://i.pinimg.com/564x/78/33/c4/7833c46114a873832349072973167909.jpg"
                  ),
                  _sahabaCard(
                      context,
                      "Ali ibn Abi Talib",
                      "Fourth Caliph & cousin of Prophet",
                      "https://i.pinimg.com/564x/cf/f3/f1/cff3f15c7e39a0468945325793086381.jpg"
                  ),
                  _sahabaCard(
                      context,
                      "Abdur-Rahman ibn Awf",
                      "Generous companion & trader of Medina",
                      "https://i.pinimg.com/564x/72/06/00/720600a943890288863266943632204c.jpg"
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sahabaCard(BuildContext context, String name, String desc, String img) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SahabaDetailScreen()));
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
                  Text(name, style: GoogleFonts.playfairDisplay(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 11, color: kTextGrey), maxLines: 2, overflow: TextOverflow.ellipsis),
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
// SCREEN 2, 3, 4: DETAIL TABS (Bio, Teachings, Quotes)
// ==========================================
class SahabaDetailScreen extends StatefulWidget {
  const SahabaDetailScreen({super.key});

  @override
  State<SahabaDetailScreen> createState() => _SahabaDetailScreenState();
}

class _SahabaDetailScreenState extends State<SahabaDetailScreen> {
  int _currentTab = 0; // 0: Bio, 1: Teachings, 2: Quotes

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
              const CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://i.pinimg.com/564x/24/c9/22/24c92250106634710156d95958288593.jpg")),
              const SizedBox(height: 15),
              Text("Abu Bakr As-Siddiq", style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("أبو بكر الصديق", style: GoogleFonts.amiri(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Custom Tab Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tabButton("Biography", 0),
                  const SizedBox(width: 10),
                  _tabButton("Teachings", 1),
                  const SizedBox(width: 10),
                  _tabButton("Quotes", 2),
                ],
              ),
              const SizedBox(height: 20),

              // Dynamic Content
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    _currentTab == 0 ? "Biography" : (_currentTab == 1 ? "His Teaching" : "His Quotes"),
                    style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w600)
                ),
              ),
              const SizedBox(height: 15),

              if (_currentTab == 0) _buildBiographyContent(),
              if (_currentTab == 1) _buildTeachingsList(),
              if (_currentTab == 2) _buildQuotesList(),
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

  // --- TAB 1: BIOGRAPHY ---
  Widget _buildBiographyContent() {
    return Container(
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
          _bioRow("Known For :", "Closest Companion of Prophet ﷺ – unwavering support throughout Prophet's mission"),
        ],
      ),
    );
  }

  Widget _bioRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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

  // --- TAB 2 & 3: TEACHINGS / QUOTES (Reusable Card) ---
  Widget _buildTeachingsList() {
    return Column(
      children: [
        _contentCard("Inner Purification (Tazkiyah al-Nafs)", "A central theme in his teachings was the cleansing of the heart from spiritual maladies such as pride, envy, greed..."),
        _contentCard("Inner Purification (Tazkiyah al-Nafs)", "A central theme in his teachings was the cleansing of the heart from spiritual maladies such as pride, envy, greed..."),
        _contentCard("Inner Purification (Tazkiyah al-Nafs)", "A central theme in his teachings was the cleansing of the heart from spiritual maladies such as pride, envy, greed..."),
      ],
    );
  }

  Widget _buildQuotesList() {
    return Column(
      children: [
        _contentCard("On Remembrance of Allah", "Let your heart constantly call out Allah, Allah. Allah in every moment of your daily life..."),
        _contentCard("On Muraqabah (Heart-Reflection)", "\"When you sit in stillness and look into your own heart, you patiently await Allah's mercy..."),
        _contentCard("On Purifying the Heart", "\"The heart finds peace only through the remembrance of Allah; no wealth, companion..."),
        _contentCard("On Spiritual Struggle", "\"Thoughts of the self will rise when you begin remembrance—don't be discouraged..."),
      ],
    );
  }

  Widget _contentCard(String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(fontSize: 11, color: kTextGrey, height: 1.5),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // Navigate to Audio Player (Screen 5)
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SahabaAudioScreen()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(20)),
                child: const Text("Read More", style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 5: AUDIO PLAYER / LESSON DETAILS
// ==========================================
class SahabaAudioScreen extends StatelessWidget {
  const SahabaAudioScreen({super.key});

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
              const CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://i.pinimg.com/564x/24/c9/22/24c92250106634710156d95958288593.jpg")),
              const SizedBox(height: 15),
              Text("Abu Bakr As-Siddiq", style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("أبو بكر الصديق", style: GoogleFonts.amiri(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Filter Tabs (Darker theme here per image)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _actionTab("His Teaches", true),
                  const SizedBox(width: 8),
                  _actionTab("Translation", false),
                  const SizedBox(width: 8),
                  _actionTab("Tafsir", false),
                ],
              ),
              const SizedBox(height: 25),

              // White Content Card
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
                    Text("كرامات الأولياء", style: GoogleFonts.amiri(fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryBrown)),
                    const SizedBox(height: 10),
                    Text(
                      "تعني: أحداث خارقة تحدث بإذن الله لأوليائه الصالحين تظهر لطاعتهم وقربهم من الله",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Extraordinary events that occur by the permission of Allah for His righteous servants, demonstrating their obedience and closeness to Allah.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: kTextGrey, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Slider
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
                    child: Slider(value: 0.3, onChanged: (v) {}),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Play Controls
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

              // Bottom Action Buttons
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: kPrimaryBrown.withOpacity(0.5)),
                    color: Colors.white
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
          ),
        ),
      ),
    );
  }

  Widget _actionTab(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? kPrimaryBrown : kDarkButton,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _bottomAction(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: isActive ? kPrimaryBrown : Colors.black),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 8, color: isActive ? kPrimaryBrown : Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }
}