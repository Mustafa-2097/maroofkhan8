import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrayerHomeScreen extends StatelessWidget {
  const PrayerHomeScreen({super.key});

  final Color primaryBrown = const Color(0xFF8D3C1F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Hijri Date Pill
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Text(
                    "4 Rajab 1447, Yaumul khamis",
                    style: TextStyle(color: primaryBrown, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text("Asr Prayer", style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text("Next: Magrib in 00:38", style: TextStyle(fontSize: 18, color: Colors.black87)),
              const SizedBox(height: 20),

              // 1. Today's Prayer Time Card
              _buildSectionCard(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Today's Prayer Time", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Row(
                          children: [
                            Text("Weekly View", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Icon(Icons.chevron_right, size: 14, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _prayerRow("Fajr", "4:15am"),
                    _prayerRow("Sunrise", "5:45am"),
                    _prayerRow("Dhuhr", "12:10pm"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(color: primaryBrown, borderRadius: BorderRadius.circular(10)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Asr", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text("4:45pm  Jama'ah 5:00 pm", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                    _prayerRow("Magrib", "6:25pm"),
                    _prayerRow("Isha", "7:45pm"),
                  ],
                ),
              ),

              // 2. Rak'ah Guide Bar
              _buildSectionCard(
                padding: 10,
                child: Row(
                  children: [
                    const Text("Rak'ah Guide", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const Spacer(),
                    const Text("Asr - 4 Rak'ahs", style: TextStyle(fontSize: 12, decoration: TextDecoration.underline)),
                    const SizedBox(width: 15),
                    _brownButton("Step by step", small: true),
                  ],
                ),
              ),

              // 3. Duas & Reflection
              _buildSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Duas & Reflection", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const Divider(),
                    Row(
                      children: [
                        Expanded(child: _brownButton("Dua Before Salah")),
                        const SizedBox(width: 10),
                        Expanded(child: _brownButton("Dua After Salah")),
                      ],
                    )
                  ],
                ),
              ),

              // 4. Special in Ramadan
              _buildSectionCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Special in Ramadan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Row(
                          children: [
                            const Text("Special Month", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _iconTile("Dua For Ramadan", Icons.mosque)),
                        const SizedBox(width: 10),
                        Expanded(child: _iconTile("Track Fasting", Icons.nights_stay)),
                      ],
                    )
                  ],
                ),
              ),

              // 5. Ramadan Timer Card
              _buildSectionCard(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(Icons.arrow_circle_right, color: primaryBrown, size: 28),
                    ),
                    const Text("24 Ramadan 1446 AH ≈ 24 December 2025 AD", textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _timerCircle("Sahari Time", "04:10 am", "Starts in 01:25:30", [const Color(0xFF2C244C), const Color(0xFF3F3661)], Icons.wb_twilight),
                        _timerCircle("Iftar Time", "05:10 pm", "End in 01:25:30", [const Color(0xFFC04838), const Color(0xFFEE8A4E)], Icons.wb_sunny_outlined),
                      ],
                    )
                  ],
                ),
              ),

              // 6. Ayah of the day
              _buildSectionCard(
                child: Column(
                  children: [
                    const Text("Ayah of the day", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                    const Divider(),
                    const Text("( فَإِنَّ مَعَ الْعُسْرِ يُسْرًا )\n( فَإِنَّ مَعَ الْعُسْرِ يُسْرًا )\n( إِنَّ مَعَ الْعُسْرِ يُسْرًا )",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text(
                      "So surely with hardship comes ease. Surely with hardship comes ease.\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    const Text("— Surah Ash-Sharh (94:5–6)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child, double padding = 15}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _prayerRow(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Text(time, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _brownButton(String text, {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: small ? 6 : 10),
      decoration: BoxDecoration(color: primaryBrown, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontSize: small ? 10 : 12)),
          const SizedBox(width: 5),
          const Icon(Icons.chevron_right, color: Colors.white, size: 14),
        ],
      ),
    );
  }

  Widget _iconTile(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryBrown, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          const Icon(Icons.chevron_right, size: 14),
        ],
      ),
    );
  }

  Widget _timerCircle(String title, String time, String countdown, List<Color> colors, IconData icon) {
    return Column(
      children: [
        Container(
          height: 140,
          width: 140,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 5),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 10)),
              Text(time, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const Divider(color: Colors.white24, indent: 20, endIndent: 20),
              Text(countdown, style: const TextStyle(color: Colors.white70, fontSize: 9)),
            ],
          ),
        ),
      ],
    );
  }
}