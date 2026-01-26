import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IslaahApp extends StatelessWidget {
  const IslaahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
        primaryColor: const Color(0xFF8D4B33),
      ),
      home: const MainMenuScreen(),
    );
  }
}

// --- Reusable Components ---

class CustomHeader extends StatelessWidget {
  final String title;
  const CustomHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFF8D4B33), indent: 40, endIndent: 10, thickness: 0.8)),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.ebGaramond(
              fontSize: 10,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8D4B33),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFF8D4B33), indent: 10, endIndent: 40, thickness: 0.8)),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const CategoryCard({super.key, required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle, style: GoogleFonts.ebGaramond(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8D4B33)),
            child: const Icon(Icons.chevron_right, color: Colors.white, size: 16),
          )
        ],
      ),
    );
  }
}

// --- Screens ---

// 1. Main Menu Screen
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Islaah & Meditation"),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const MeditationPlayerScreen())),
              child: const CategoryCard(
                title: "Inner Peace",
                subtitle: "Find tranquility within",
                icon: Icons.self_improvement,
              ),
            ),
            const CategoryCard(
              title: "Relief from Anxiety",
              subtitle: "Calm your mind",
              icon: Icons.spa_outlined,
            ),
            const CategoryCard(
              title: "Journey of Repentance",
              subtitle: "Calm your mind",
              icon: Icons.auto_awesome_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Meditation Player Screen (Matches Screen 5, 6, 7)
class MeditationPlayerScreen extends StatelessWidget {
  const MeditationPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Inner Peace"),
            const SizedBox(height: 20),
            Text(
              "Calm your heart, balance your\nmind",
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black87),
            ),
            const Spacer(),
            // The Circular Image
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1519817650390-64a93db51149?q=80&w=400'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: const Color(0xFFF0E6E1), width: 8),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text("Al Murshid", style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "Take a deep breath and remember Allah.\nPause if needed. Focus on your heart",
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(fontSize: 15, color: Colors.black54),
            ),
            const Spacer(),
            // Audio Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("02:25", style: GoogleFonts.ebGaramond(fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: 0.3,
                          onChanged: (v) {},
                          activeColor: const Color(0xFF8D4B33),
                          inactiveColor: Colors.grey[300],
                        ),
                      ),
                      Text("10:25", style: GoogleFonts.ebGaramond(fontSize: 12)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.skip_previous_outlined, size: 30),
                      const SizedBox(width: 25),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1)),
                        child: const Icon(Icons.play_arrow_rounded, size: 35),
                      ),
                      const SizedBox(width: 25),
                      const Icon(Icons.skip_next_outlined, size: 30),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Bottom Action Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBottomBtn("Start Session", const Color(0xFF0D5D4E)),
                  const SizedBox(width: 8),
                  _buildBottomBtn("Keep Breathing", const Color(0xFF8D4B33)),
                  const SizedBox(width: 8),
                  _buildBottomBtn("End Session", const Color(0xFF1B2344)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBtn(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.ebGaramond(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}