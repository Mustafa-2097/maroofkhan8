import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CONSTANTS & THEME ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);
const Color kBackground = Color(0xFFFDFDFD);

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SufismHomeScreen(),
  ));
}

// ==========================================
// SCREEN 1: SUFISM HOME
// ==========================================
class SufismHomeScreen extends StatelessWidget {
  const SufismHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Center(child: HeaderWithLines(title: "Sufism")),
              const Center(
                child: Text(
                  "Daily Wisdom & Meditation",
                  style: TextStyle(color: kTextGrey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Search
              const CustomSearchBar(),
              const SizedBox(height: 20),

              // Quote Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "مَنْ عَرَفَ نَفْسَهُ عَرَفَ رَبَّهُ",
                      style: GoogleFonts.amiri(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Man ‘arafa nafsahu ‘arafa rabbahu.",
                      style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Whoever knows himself knows his Lord.\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: kTextGrey),
                    ),
                    const SizedBox(height: 10),
                    const HeaderDecorationMini(label: "Ibn Arabi"),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.favorite_border, size: 18, color: Colors.grey.shade400),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Guided Meditation List
              Text("Guided Meditation", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _meditationTile(context, "Yā Halīm (يَا حَلِيمُ)", "Calms anger and brings patience"),
              _meditationTile(context, "Yā Salām (يَا سَلَامُ)", "Brings tranquility to the heart"),
              _meditationTile(context, "Yā Rahmān (يَا رَحْمَٰنُ)", "Softens the heart and removes fear"),
              _meditationTile(context, "Yā Latīf (يَا لَطِيفُ)", "Helps in difficult and sensitive moments"),
              _meditationTile(context, "Astaghfirullāh (أَسْتَغْفِرُ اللَّهَ)", "Cleanses the heart and brings relief"),

              const SizedBox(height: 10),
              const Center(
                child: Text("See more", style: TextStyle(color: kPrimaryBrown, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 25),

              // Teaching Section
              Text("Teaching", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _teachingCard(context, "Spiritual Teaches", 'https://images.unsplash.com/photo-1542358827-046645367332?auto=format&fit=crop&q=80&w=200')),
                        const SizedBox(width: 15),
                        Expanded(child: _teachingCard(context, "Poem of love", 'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?auto=format&fit=crop&q=80&w=200')),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(20)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("More", style: TextStyle(color: Colors.white, fontSize: 12)),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward, size: 12, color: Colors.white)
                        ],
                      ),
                    )
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

  Widget _meditationTile(BuildContext context, String title, String sub) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MeditationPlayerScreen())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: kPrimaryBrown,
              child: Icon(Icons.donut_large, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(sub, style: const TextStyle(fontSize: 10, color: kTextGrey)),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 12,
              backgroundColor: kPrimaryBrown,
              child: Icon(Icons.chevron_right, color: Colors.white, size: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget _teachingCard(BuildContext context, String title, String imgUrl) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IslamicTeachersScreen())),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imgUrl),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 12, color: kTextGrey)),
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 2: ISLAMIC TEACHERS LIST
// ==========================================
class IslamicTeachersScreen extends StatelessWidget {
  const IslamicTeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              Text("Islamic teachers", style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // Simple Border Search
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // List
              Expanded(
                child: ListView(
                  children: [
                    _teacherCard(context, "Islamic Mentor", "https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&q=80&w=200"),
                    _teacherCard(context, "Islamic Mentor", "https://images.unsplash.com/photo-1542358827-046645367332?auto=format&fit=crop&q=80&w=200"),
                    _teacherCard(context, "Deen Guide", "https://images.unsplash.com/photo-1519817650390-64a93db51149?auto=format&fit=crop&q=80&w=200"),
                    _teacherCard(context, "Fiqh Instructor", "https://images.unsplash.com/photo-1545989253-02cc26577f88?auto=format&fit=crop&q=80&w=200"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _teacherCard(BuildContext context, String name, String imgUrl) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeachingDetailsScreen())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(imgUrl),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text("Sufi Scholar + Baghdad", style: TextStyle(fontSize: 10, color: kTextGrey)),
                ],
              ),
            ),
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 3: TEACHING DETAILS
// ==========================================
class TeachingDetailsScreen extends StatelessWidget {
  const TeachingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.chevron_left, color: Colors.grey),
                  ),
                ),
              ),
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage("https://images.unsplash.com/photo-1542358827-046645367332?auto=format&fit=crop&q=80&w=300"),
              ),
              const SizedBox(height: 15),
              Text("Spiritual Teaches", style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("المُرْشِدُونَ الرُّوحِيُّونَ", style: GoogleFonts.amiri(fontSize: 16, color: kTextGrey)),
              const SizedBox(height: 25),

              Align(alignment: Alignment.centerLeft, child: Text("His Teaching", style: GoogleFonts.playfairDisplay(fontSize: 18))),
              const SizedBox(height: 15),

              _teachingContentCard(),
              _teachingContentCard(),
              _teachingContentCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teachingContentCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Inner Purification (Tazkiyah al-Nafs)", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          const Text(
            "A central theme in his teachings was the cleansing of the heart from spiritual maladies such as pride, envy, greed, and heedlessness. He taught that true spirituality begins with...",
            style: TextStyle(fontSize: 12, color: kTextGrey, height: 1.5),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(20)),
              child: const Text("Read More", style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 4: MEDITATION PLAYER
// ==========================================
class MeditationPlayerScreen extends StatelessWidget {
  const MeditationPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header
            const HeaderWithLines(title: "Inner Peace"),
            const SizedBox(height: 10),
            const Text("Calm your heart, balance your\nmind", textAlign: TextAlign.center, style: TextStyle(color: kTextGrey)),

            const Spacer(),

            // Central Image
            Container(
              height: 150,
              width: 150,
              decoration: const BoxDecoration(
                color: kPrimaryBrown,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.volunteer_activism, size: 70, color: Colors.white), // Tasbih Icon Placeholder
            ),

            const SizedBox(height: 30),

            Text("Al Murshid", style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Take a deep breath and remember Allah.", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            const Text("Pause if needed. Focus on your heart", style: TextStyle(fontSize: 12, color: kTextGrey)),

            const SizedBox(height: 30),

            // Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: kPrimaryBrown,
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: kPrimaryBrown,
                      trackHeight: 2,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(value: 0.3, onChanged: (val) {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("02:25", style: TextStyle(fontSize: 10)),
                        Text("10:25", style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.skip_previous_outlined, size: 30)),
                const SizedBox(width: 20),
                const Icon(Icons.play_circle_outline, size: 50, color: kTextDark),
                const SizedBox(width: 20),
                IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next_outlined, size: 30)),
              ],
            ),

            const Spacer(),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton("Start Session", const Color(0xFF1B5E20)), // Green
                  _actionButton("Keep Breathing", kPrimaryBrown), // Brown
                  _actionButton("End Session", const Color(0xFF0D47A1)), // Blue
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}


// --- SHARED HELPER WIDGETS ---

class HeaderWithLines extends StatelessWidget {
  final String title;
  const HeaderWithLines({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.circle, size: 4, color: kPrimaryBrown),
        Container(width: 40, height: 1, color: Colors.grey.shade300),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Container(width: 40, height: 1, color: Colors.grey.shade300),
        const Icon(Icons.circle, size: 4, color: kPrimaryBrown),
      ],
    );
  }
}

class HeaderDecorationMini extends StatelessWidget {
  final String label;
  const HeaderDecorationMini({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 20, height: 1, color: kPrimaryBrown),
        const SizedBox(width: 5),
        const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.playfairDisplay(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
        const SizedBox(width: 5),
        Container(width: 20, height: 1, color: kPrimaryBrown),
      ],
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
          hintText: "Search...",
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 8),
        ),
      ),
    );
  }
}