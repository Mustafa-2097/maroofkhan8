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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
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
          // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          padding: EdgeInsets.symmetric(
            horizontal: sw * 0.05,
            vertical: sh * 0.018,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Date Pill
              Center(
                child: Container(
                  // padding: const EdgeInsets.symmetric(
                  //   horizontal: 25,
                  //   vertical: 10,
                  // ),
                  padding: EdgeInsets.symmetric(
                    horizontal: sw * 0.06,
                    vertical: sh * 0.012,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
                      // fontSize: 14,
                      fontSize: sw * 0.035,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 25),
              SizedBox(height: sh * 0.03),

              // 2. Main Header
              Text(
                tr("asr_prayer"),
                style: GoogleFonts.playfairDisplay(
                  // fontSize: 24,
                  fontSize: sw * 0.06,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kTextDark,
                ),
              ),
              // const SizedBox(height: 5),
              SizedBox(height: sh * 0.006),
              Text(
                "${tr("next_prayer")} ${tr("magrib")} ${tr("in")} ${localizeDigits("00:38", context)}",
                style: GoogleFonts.playfairDisplay(
                  // fontSize: 18,
                  fontSize: sw * 0.045,
                  color: isDark ? Colors.white : kTextDark,
                ),
              ),
              // const SizedBox(height: 20),
              SizedBox(height: sh * 0.025),

              // 3. Prayer Times Card
              const PrayerTimesCard(),
              // const SizedBox(height: 15),
              SizedBox(height: sh * 0.018),

              // 4. Rak'ah Guide Card
              //const RakahGuideCard(),
              // const SizedBox(height: 15),
              SizedBox(height: sh * 0.018),

              // 5. Duas & Reflection
              const DuasReflectionCard(),
              // const SizedBox(height: 15),
              SizedBox(height: sh * 0.018),

              // 6. Special in Ramadan
              // const SpecialRamadanCard(),
              // const SizedBox(height: 15),

              // 7. Ramadan Countdown Circles
              const RamadanCountdownCard(),
              // const SizedBox(height: 15),
              SizedBox(height: sh * 0.018),

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Container(
      // padding: const EdgeInsets.all(16),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: _cardDecoration(sw, isDark),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr("todays_prayer_time"),
                style: GoogleFonts.playfairDisplay(
                  // fontSize: 13,
                  fontSize: sw * 0.032,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    tr("weekly_view"),
                    style: TextStyle(
                      // fontSize: 12,
                      fontSize: sw * 0.03,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[400] : kTextDark,
                    ),
                  ),
                  // const Icon(Icons.chevron_right, size: 16),
                  Icon(
                    Icons.chevron_right,
                    size: sw * 0.04,
                    color: isDark ? Colors.grey[400] : Colors.black,
                  ),
                ],
              ),
            ],
          ),
          // const Divider(height: 25, color: Color(0xFFEEEEEE)),
          Divider(
            height: sh * 0.03,
            color: isDark ? Colors.grey.shade800 : const Color(0xFFEEEEEE),
          ),
          _prayerRow(tr("fajr"), localizeDigits("4:15am", context), sw, isDark),
          _prayerRow(
            tr("sunrise"),
            localizeDigits("5:45am", context),
            sw,
            isDark,
          ),
          _prayerRow(
            tr("dhuhr"),
            localizeDigits("12:10pm", context),
            sw,
            isDark,
          ),

          // Active Row (Asr)
          Container(
            // margin: const EdgeInsets.symmetric(vertical: 6),
            // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            margin: EdgeInsets.symmetric(vertical: sh * 0.007),
            padding: EdgeInsets.symmetric(
              horizontal: sw * 0.03,
              vertical: sh * 0.015,
            ),
            decoration: BoxDecoration(
              color: kPrimaryBrown,
              // borderRadius: BorderRadius.circular(8),
              borderRadius: BorderRadius.circular(sw * 0.02),
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
                    // fontSize: 13,
                    fontSize: sw * 0.032,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    // style: const TextStyle(color: Colors.white, fontSize: 13),
                    style: TextStyle(color: Colors.white, fontSize: sw * 0.032),
                    children: [
                      TextSpan(
                        text: "${localizeDigits("4:45pm", context)} ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            "${tr("jamaah")} ${localizeDigits("5:00 pm", context)}",
                        // style: const TextStyle(fontSize: 11),
                        style: TextStyle(fontSize: sw * 0.028),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _prayerRow(
            tr("magrib"),
            localizeDigits("6:25pm", context),
            sw,
            isDark,
          ),
          _prayerRow(tr("isha"), localizeDigits("7:45pm", context), sw, isDark),
        ],
      ),
    );
  }

  Widget _prayerRow(String name, String time, double sw, bool isDark) {
    return Padding(
      // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: EdgeInsets.symmetric(
        vertical: sw * 0.02,
        horizontal: sw * 0.025,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text(name, style: const TextStyle(fontSize: 13, color: kTextDark)),
          Text(
            name,
            style: TextStyle(
              fontSize: sw * 0.032,
              color: isDark ? Colors.white : kTextDark,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: sw * 0.032,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : kTextDark,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Container(
      // padding: const EdgeInsets.all(16),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: _cardDecoration(sw, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("duas_reflection"),
            style: GoogleFonts.playfairDisplay(
              // fontSize: 13,
              fontSize: sw * 0.032,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          // const Divider(height: 25, color: Color(0xFFEEEEEE)),
          Divider(
            height: sh * 0.03,
            color: isDark ? Colors.grey.shade800 : const Color(0xFFEEEEEE),
          ),
          Row(
            children: [
              Expanded(
                child: _brownButton(
                  tr("dua_before_salah"),
                  sw,
                  showArrow: true,
                  fullWidth: true,
                ),
              ),
              // const SizedBox(width: 15),
              SizedBox(width: sw * 0.04),
              Expanded(
                child: _brownButton(
                  tr("dua_after_salah"),
                  sw,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;

    return Container(
      // padding: const EdgeInsets.all(16),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: _cardDecoration(sw, isDark),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr("special_in_ramadan"),
                style: GoogleFonts.playfairDisplay(
                  // fontSize: 13,
                  fontSize: sw * 0.032,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Text(
                    tr("special_month"),
                    // style: const TextStyle(fontSize: 12),
                    style: TextStyle(
                      fontSize: sw * 0.03,
                      color: isDark ? Colors.grey[400] : Colors.black,
                    ),
                  ),
                  // const Icon(Icons.keyboard_arrow_down, size: 16),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: sw * 0.04,
                    color: isDark ? Colors.grey[400] : Colors.black,
                  ),
                ],
              ),
            ],
          ),
          // const SizedBox(height: 20),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          Row(
            children: [
              Expanded(
                child: _iconPillButton(
                  Icons.mosque_outlined,
                  tr("dua_for_ramadan"),
                  sw,
                  isDark,
                ),
              ),
              // const SizedBox(width: 15),
              SizedBox(width: sw * 0.04),
              Expanded(
                child: _iconPillButton(
                  Icons.dark_mode_outlined,
                  tr("track_fasting"),
                  sw,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconPillButton(IconData icon, String label, double sw, bool isDark) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      padding: EdgeInsets.symmetric(
        vertical: sw * 0.03,
        horizontal: sw * 0.025,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        // borderRadius: BorderRadius.circular(30),
        borderRadius: BorderRadius.circular(sw * 0.08),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            // radius: 12,
            radius: sw * 0.03,
            backgroundColor: kPrimaryBrown,
            // child: Icon(icon, size: 14, color: Colors.white),
            child: Icon(icon, size: sw * 0.035, color: Colors.white),
          ),
          // const SizedBox(width: 8),
          SizedBox(width: sw * 0.02),
          Expanded(
            child: Text(
              label,
              // style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              style: TextStyle(
                fontSize: sw * 0.028,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // const Icon(Icons.chevron_right, size: 16, color: Colors.black),
          Icon(
            Icons.chevron_right,
            size: sw * 0.04,
            color: isDark ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }
}

class RamadanCountdownCard extends StatelessWidget {
  const RamadanCountdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Container(
      // padding: const EdgeInsets.all(20),
      padding: EdgeInsets.all(sw * 0.05),
      decoration: _cardDecoration(sw, isDark),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                localizeDigits(tr("ramadan_countdown_example"), context),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  // fontSize: 14,
                  fontSize: sw * 0.035,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  // radius: 12,
                  radius: sw * 0.03,
                  backgroundColor: kPrimaryBrown,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    // size: 16,
                    size: sw * 0.04,
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 30),
          SizedBox(height: sh * 0.035),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleInfo(
                kNavyCircle,
                Icons.wb_sunny_outlined, // Placeholder for sun/moon icon
                tr("sahuri_time"),
                localizeDigits("04:10 am", context),
                "${tr("starts_in")} ${localizeDigits("01:25:30", context)}",
                sw,
              ),
              // const SizedBox(width: 25),
              SizedBox(width: sw * 0.06),
              _circleInfo(
                kOrangeCircleStart,
                Icons.wb_sunny_outlined,
                tr("iftar_time"),
                localizeDigits("05:10 pm", context),
                "${tr("end_in")} ${localizeDigits("01:25:30", context)}",
                sw,
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
    String sub,
    double sw, {
    bool isGradient = false,
  }) {
    return Container(
      // width: 135,
      // height: 135,
      width: sw * 0.35,
      height: sw * 0.35,
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
          // Icon(icon, color: Colors.white, size: 18),
          Icon(icon, color: Colors.white, size: sw * 0.045),
          // const SizedBox(height: 5),
          SizedBox(height: sw * 0.015),
          Text(
            title,
            // style: const TextStyle(color: Colors.white70, fontSize: 11),
            style: TextStyle(color: Colors.white70, fontSize: sw * 0.028),
          ),
          // const SizedBox(height: 2),
          SizedBox(height: sw * 0.005),
          Text(
            time,
            style: TextStyle(
              color: Colors.white,
              // fontSize: 13,
              fontSize: sw * 0.032,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 5),
          SizedBox(height: sw * 0.015),
          // Container(height: 1, width: 80, color: Colors.white30),
          Container(height: 1, width: sw * 0.2, color: Colors.white30),
          // const SizedBox(height: 5),
          SizedBox(height: sw * 0.015),
          // Text(sub, style: const TextStyle(color: Colors.white, fontSize: 10)),
          Text(
            sub,
            style: TextStyle(color: Colors.white, fontSize: sw * 0.025),
          ),
        ],
      ),
    );
  }
}

class AyahOfDayCard extends StatelessWidget {
  const AyahOfDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.06),
      decoration: _cardDecoration(sw, isDark),
      child: Column(
        children: [
          Text(
            tr("ayah_of_the_day"),
            style: GoogleFonts.playfairDisplay(
              // fontSize: 14,
              fontSize: sw * 0.035,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Divider(
            height: 30,
            color: isDark ? Colors.grey.shade800 : const Color(0xFFEEEEEE),
          ),
          Text(
            "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٥﴾\nإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٦﴾",
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              // fontSize: 20,
              fontSize: sw * 0.05,
              fontWeight: FontWeight.bold,
              height: 1.5,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          // const SizedBox(height: 15),
          SizedBox(height: sw * 0.04),
          Text(
            tr("ayah_meaning"),
            textAlign: TextAlign.center,
            // style: GoogleFonts.playfairDisplay(fontSize: 15, color: kTextDark),
            style: GoogleFonts.playfairDisplay(
              fontSize: sw * 0.038,
              color: isDark ? Colors.white : kTextDark,
            ),
          ),
          // const SizedBox(height: 15),
          SizedBox(height: sw * 0.04),
          Text(
            localizeDigits(tr("surah_reference"), context),
            // style: const TextStyle(fontSize: 12, color: kTextGrey),
            style: TextStyle(
              fontSize: sw * 0.03,
              color: isDark ? Colors.grey[400] : kTextGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// --- HELPERS ---

BoxDecoration _cardDecoration(double sw, bool isDark) {
  return BoxDecoration(
    color: isDark ? const Color(0xFF1E1E1E) : kCardColor,
    // borderRadius: BorderRadius.circular(20),
    borderRadius: BorderRadius.circular(sw * 0.05),
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
  String text,
  double sw, {
  bool showArrow = false,
  bool fullWidth = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      // horizontal: fullWidth ? 15 : 20,
      // vertical: 12,
      horizontal: fullWidth ? sw * 0.038 : sw * 0.05,
      vertical: sw * 0.03,
    ),
    decoration: BoxDecoration(
      color: kPrimaryBrown,
      // borderRadius: BorderRadius.circular(30),
      borderRadius: BorderRadius.circular(sw * 0.08),
    ),
    child: Row(
      mainAxisAlignment: fullWidth
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            // fontSize: 11,
            fontSize: sw * 0.028,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showArrow)
          // const Icon(Icons.chevron_right, color: Colors.white, size: 16),
          Icon(Icons.chevron_right, color: Colors.white, size: sw * 0.04),
      ],
    ),
  );
}
