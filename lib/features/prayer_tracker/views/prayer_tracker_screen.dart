import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';
import '../../../core/constant/widgets/header.dart';

// --- COLORS & THEME ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFF4F6F8);
const Color kCardColor = Colors.white;
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

// Ramadan Circle Colors
const Color kNavyCircle = Color(0xFF2E2A4F);
const Color kOrangeCircleStart = Color(0xFFD66445);
const Color kOrangeCircleEnd = Color(0xFFC75138);

class PrayerTrackerScreenn extends StatelessWidget {
  final bool hideBack;
  const PrayerTrackerScreenn({super.key, this.hideBack = false});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("prayer_tracker")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: hideBack
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Date Pill
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    localizeDigits(tr("rajab_date_example"), context),
                    style: GoogleFonts.playfairDisplay(
                      color: kPrimaryBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 2. Main Header
              Text(
                tr("asr_prayer"),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "${tr("next_prayer")} ${tr("magrib")} ${tr("in")} ${localizeDigits("00:38", context)}",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 20),

              // 3. Prayer Times Card
              const PrayerTimesCard(),
              const SizedBox(height: 15),

              // 4. Rak'ah Guide Card
              //const RakahGuideCard(),
              const SizedBox(height: 15),

              // 5. Duas & Reflection
              const DuasReflectionCard(),
              const SizedBox(height: 15),

              // 6. Special in Ramadan
              // const SpecialRamadanCard(),
              // const SizedBox(height: 15),

              // 7. Ramadan Countdown Circles
              const RamadanCountdownCard(),
              const SizedBox(height: 15),

              // 8. Ayah of the Day
              // const AyahOfDayCard(),
              // const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// WIDGETS
// ==========================================

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
              Text(
                tr("todays_prayer_time"),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    tr("weekly_view"),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16),
                ],
              ),
            ],
          ),
          const Divider(height: 25, color: Color(0xFFEEEEEE)),
          _prayerRow(tr("fajr"), localizeDigits("4:15am", context)),
          _prayerRow(tr("sunrise"), localizeDigits("5:45am", context)),
          _prayerRow(tr("dhuhr"), localizeDigits("12:10pm", context)),

          // Active Row (Asr)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: kPrimaryBrown,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryBrown.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("asr"),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    children: [
                      TextSpan(
                        text: "${localizeDigits("4:45pm", context)} ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "${tr("jamaah")} ${localizeDigits("5:00 pm", context)}",
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _prayerRow(tr("magrib"), localizeDigits("6:25pm", context)),
          _prayerRow(tr("isha"), localizeDigits("7:45pm", context)),
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
          Text(
            time,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }
}

// class RakahGuideCard extends StatelessWidget {
//   const RakahGuideCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//       decoration: _cardDecoration(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Rak'ah Guide",
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.only(bottom: 2),
//             decoration: const BoxDecoration(
//               border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
//             ),
//             child: const Text("Asr - 4Rak'ahs", style: TextStyle(fontSize: 12)),
//           ),
//           _brownButton("Step by step", showArrow: true),
//         ],
//       ),
//     );
//   }
// }

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
          Text(
            tr("duas_reflection"),
            style: GoogleFonts.playfairDisplay(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 25, color: Color(0xFFEEEEEE)),
          Row(
            children: [
              Expanded(
                child: _brownButton(
                  tr("dua_before_salah"),
                  showArrow: true,
                  fullWidth: true,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _brownButton(
                  tr("dua_after_salah"),
                  showArrow: true,
                  fullWidth: true,
                ),
              ),
            ],
          ),
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
              Text(
                tr("special_in_ramadan"),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    tr("special_month"),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _iconPillButton(
                  Icons.mosque_outlined,
                  tr("dua_for_ramadan"),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _iconPillButton(
                  Icons.dark_mode_outlined,
                  tr("track_fasting"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconPillButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: kPrimaryBrown,
            child: Icon(icon, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
                localizeDigits(tr("ramadan_countdown_example"), context),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: kPrimaryBrown,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleInfo(
                kNavyCircle,
                Icons.wb_sunny_outlined, // Placeholder for sun/moon icon
                tr("sahuri_time"),
                localizeDigits("04:10 am", context),
                "${tr("starts_in")} ${localizeDigits("01:25:30", context)}",
              ),
              const SizedBox(width: 25),
              _circleInfo(
                kOrangeCircleStart,
                Icons.wb_sunny_outlined,
                tr("iftar_time"),
                localizeDigits("05:10 pm", context),
                "${tr("end_in")} ${localizeDigits("01:25:30", context)}",
                isGradient: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleInfo(
    Color color,
    IconData icon,
    String title,
    String time,
    String sub, {
    bool isGradient = false,
  }) {
    return Container(
      width: 135,
      height: 135,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isGradient ? null : color,
        gradient: isGradient
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kOrangeCircleStart, kOrangeCircleEnd],
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text(
            tr("ayah_of_the_day"),
            style: GoogleFonts.playfairDisplay(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 30, color: Color(0xFFEEEEEE)),
          Text(
            "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٥﴾\nإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٦﴾",
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            tr("ayah_meaning"),
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(fontSize: 15, color: kTextDark),
          ),
          const SizedBox(height: 15),
          Text(
            localizeDigits(tr("surah_reference"), context),
            style: const TextStyle(fontSize: 12, color: kTextGrey),
          ),
        ],
      ),
    );
  }
}

// --- HELPERS ---

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: kCardColor,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

Widget _brownButton(
  String text, {
  bool showArrow = false,
  bool fullWidth = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: fullWidth ? 15 : 20,
      vertical: 12,
    ),
    decoration: BoxDecoration(
      color: kPrimaryBrown,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisAlignment: fullWidth
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showArrow)
          const Icon(Icons.chevron_right, color: Colors.white, size: 16),
      ],
    ),
  );
}
