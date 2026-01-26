import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkBrown = Color(0xFF6D2E17);
const Color kBackground = Color(0xFFF6F7F9);
const Color kCardColor = Colors.white;
const Color kTextDark = Color(0xFF1E1E1E);
const Color kTextGrey = Color(0xFF757575);

// Specific Colors for the Ramadan Circles
const Color kCircleDark = Color(0xFF342E52); // Dark Purple/Blue
const Color kCircleOrangeStart = Color(0xFFC75138); // Burnt Orange
const Color kCircleOrangeEnd = Color(0xFFE07A58); // Lighter Orange


class PrayerTrackerScreen extends StatelessWidget {
  const PrayerTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Date Pill
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                    ],
                  ),
                  child: Text(
                    "4 Rajab 1447, Yaumul khamis",
                    style: GoogleFonts.playfairDisplay(
                      color: kPrimaryBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Main Header
              Text("Asr Prayer", style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold, color: kTextDark)),
              const SizedBox(height: 5),
              Text("Next:Magrib in 00:38", style: GoogleFonts.playfairDisplay(fontSize: 18, color: kTextDark)),
              const SizedBox(height: 20),

              // 3. Prayer Time Card
              const PrayerTimesCard(),
              const SizedBox(height: 15),

              // 4. Rak'ah Guide Card
              const RakahGuideCard(),
              const SizedBox(height: 15),

              // 5. Duas & Reflection
              const DuasReflectionCard(),
              const SizedBox(height: 15),

              // 6. Special in Ramadan
              const SpecialRamadanCard(),
              const SizedBox(height: 15),

              // 7. Ramadan Countdown Circles
              const RamadanCountdownCard(),
              const SizedBox(height: 15),

              // 8. Ayah of the Day
              const AyahOfDayCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS ---

class PrayerTimesCard extends StatelessWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's Prayer Time", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold)),
              const Row(
                children: [
                  Text("Weekly View", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Icon(Icons.chevron_right, size: 16),
                ],
              )
            ],
          ),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          _prayerRow("Fajr", "4:15am"),
          _prayerRow("Sunrise", "5:45am"),
          _prayerRow("Dhuhr", "12:10pm"),
          // Active Row
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: kPrimaryBrown,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: kPrimaryBrown.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Asr", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                const Text("4:45pm Jama'ah 5:00 pm", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          _prayerRow("Magrib", "6:25pm"),
          _prayerRow("Isha", "7:45pm"),
        ],
      ),
    );
  }

  Widget _prayerRow(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 13, color: kTextDark)),
          Text(time, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kTextDark)),
        ],
      ),
    );
  }
}

class RakahGuideCard extends StatelessWidget {
  const RakahGuideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _cardDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Rak'ah Guide", style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: const Text("Asr - 4Rak'ahs", style: TextStyle(fontSize: 12)),
          ),
          _brownButton("Step by step"),
        ],
      ),
    );
  }
}

class DuasReflectionCard extends StatelessWidget {
  const DuasReflectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Duas & Reflection", style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold)),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          Row(
            children: [
              Expanded(child: _brownButton("Dua Before Salah", fullWidth: true)),
              const SizedBox(width: 15),
              Expanded(child: _brownButton("Dua After Salah", fullWidth: true)),
            ],
          )
        ],
      ),
    );
  }
}

class SpecialRamadanCard extends StatelessWidget {
  const SpecialRamadanCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Special in Ramadan", style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.bold)),
              Row(
                children: const [
                  Text("Special Month", style: TextStyle(fontSize: 12)),
                  Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _iconButton(Icons.mosque_outlined, "Dua For Ramadan")), // Using generic icon
              const SizedBox(width: 15),
              Expanded(child: _iconButton(Icons.dark_mode_outlined, "Track Fasting")),
            ],
          )
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 12,
              backgroundColor: kPrimaryBrown,
              child: Icon(icon, size: 14, color: Colors.white)
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
          const Icon(Icons.chevron_right, size: 16, color: Colors.black),
        ],
      ),
    );
  }
}

class RamadanCountdownCard extends StatelessWidget {
  const RamadanCountdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                "24 Ramadan 1446 AH = 24 December 2025\nAD",
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(radius: 12, backgroundColor: kPrimaryBrown, child: Icon(Icons.chevron_right, color: Colors.white, size: 16)),
              )
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleInfo(
                kCircleDark,
                Icons.wb_twilight,
                "Sahuri Time",
                "04:10 am",
                "Starts in 01:25:30",
              ),
              const SizedBox(width: 20),
              _circleInfo(
                kCircleOrangeStart,
                Icons.wb_sunny_outlined,
                "Iftar Time",
                "05:10 pm",
                "End in 01:25:30",
                isGradient: true,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _circleInfo(Color color, IconData icon, String title, String time, String sub, {bool isGradient = false}) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isGradient ? null : color,
        gradient: isGradient ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kCircleOrangeStart, kCircleOrangeEnd]
        ) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 2),
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Container(height: 1, width: 80, color: Colors.white30),
          const SizedBox(height: 5),
          Text(sub, style: const TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}

class AyahOfDayCard extends StatelessWidget {
  const AyahOfDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text("Ayah of the day", style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.bold)),
          const Divider(height: 20, color: Color(0xFFEEEEEE)),
          Text(
            "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٥﴾\nإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٦﴾",
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "So surely with hardship comes\nease. Surely with hardship comes\nease.\"",
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(fontSize: 14, color: kTextDark),
          ),
          const SizedBox(height: 10),
          const Text("— Surah Ash-Sharh (94:5–6)", style: TextStyle(fontSize: 11, color: kTextGrey)),
        ],
      ),
    );
  }
}

// --- HELPER FUNCTIONS ---

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: kCardColor,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
    ],
  );
}

Widget _brownButton(String text, {bool fullWidth = false}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: fullWidth ? 10 : 16, vertical: 10),
    decoration: BoxDecoration(
      color: kPrimaryBrown,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisAlignment: fullWidth ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        if (fullWidth) const Icon(Icons.chevron_right, color: Colors.white, size: 16)
        else const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Icon(Icons.chevron_right, color: Colors.white, size: 16),
        ),
      ],
    ),
  );
}