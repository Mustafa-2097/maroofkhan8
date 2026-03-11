import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/core/network/api_Service.dart';
import 'package:maroofkhan8/core/network/api_endpoints.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';
import 'package:maroofkhan8/features/dua/views/dua_screen.dart';
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

// ==========================================
// PRAYER DATA MODEL
// ==========================================
class PrayerTimesData {
  final DateTime date;
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime sunrise;
  final DateTime sunset;
  final String hijriDate;
  final String hijriString;
  final DateTime? sehri;
  final DateTime? iftar;

  PrayerTimesData({
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.sunrise,
    required this.sunset,
    required this.hijriDate,
    required this.hijriString,
    this.sehri,
    this.iftar,
  });

  factory PrayerTimesData.fromJson(Map<String, dynamic> json) {
    return PrayerTimesData(
      date: DateTime.parse(json['date']),
      fajr: DateTime.parse(json['fajr']).toLocal(),
      dhuhr: DateTime.parse(json['dhuhr']).toLocal(),
      asr: DateTime.parse(json['asr']).toLocal(),
      maghrib: DateTime.parse(json['maghrib']).toLocal(),
      isha: DateTime.parse(json['isha']).toLocal(),
      sunrise: DateTime.parse(json['sunrise']).toLocal(),
      sunset: DateTime.parse(json['sunset']).toLocal(),
      hijriDate: json['hijriDate'] ?? '',
      hijriString: json['hijriString'] ?? '',
      sehri: json['sehri'] != null
          ? DateTime.parse(json['sehri']).toLocal()
          : null,
      iftar: json['iftar'] != null
          ? DateTime.parse(json['iftar']).toLocal()
          : null,
    );
  }

  /// Returns the currently active prayer name and its time
  String get currentPrayerName {
    final now = DateTime.now();
    if (now.isAfter(isha)) return 'isha';
    if (now.isAfter(maghrib)) return 'maghrib';
    if (now.isAfter(asr)) return 'asr';
    if (now.isAfter(dhuhr)) return 'dhuhr';
    if (now.isAfter(sunrise)) return 'sunrise';
    if (now.isAfter(fajr)) return 'fajr';
    return 'isha'; // past midnight before fajr
  }

  /// Returns name + time of next prayer
  ({String name, DateTime time}) get nextPrayer {
    final now = DateTime.now();
    if (now.isBefore(fajr)) return (name: 'fajr', time: fajr);
    if (now.isBefore(sunrise)) return (name: 'sunrise', time: sunrise);
    if (now.isBefore(dhuhr)) return (name: 'dhuhr', time: dhuhr);
    if (now.isBefore(asr)) return (name: 'asr', time: asr);
    if (now.isBefore(maghrib)) return (name: 'maghrib', time: maghrib);
    if (now.isBefore(isha)) return (name: 'isha', time: isha);
    // After isha → next is tomorrow's fajr (approximate +24h)
    return (name: 'fajr', time: fajr.add(const Duration(hours: 24)));
  }
}

// ==========================================
// MAIN SCREEN
// ==========================================
class PrayerTrackerScreenn extends StatefulWidget {
  final bool hideBack;
  const PrayerTrackerScreenn({super.key, this.hideBack = false});

  @override
  State<PrayerTrackerScreenn> createState() => _PrayerTrackerScreennState();
}

class _PrayerTrackerScreennState extends State<PrayerTrackerScreenn> {
  // Location & API state
  bool _locationGranted = false;
  bool _isLoading = false;
  String? _errorMsg;
  PrayerTimesData? _prayerData;
  Position? _position;

  // Countdown timer
  Timer? _ticker;
  Duration _countdown = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Show location popup on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestLocation();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  // ── Location + API ──────────────────────────────────────────────────────────

  Future<void> _checkAndRequestLocation() async {
    // Check if location service is enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog(serviceDisabled: true);
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showLocationDialog(serviceDisabled: false);
      return;
    }

    // Already granted
    await _fetchLocationAndPrayer();
  }

  void _showLocationDialog({required bool serviceDisabled}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 28,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: kPrimaryBrown,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Turn On Your Location',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kTextDark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'To show accurate prayer times for your area, we need access to your location.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : kTextGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (serviceDisabled) {
                      await Geolocator.openLocationSettings();
                      // Re-check after user returns from settings
                      await Future.delayed(const Duration(milliseconds: 800));
                      await _checkAndRequestLocation();
                    } else {
                      final perm = await Geolocator.requestPermission();
                      if (perm == LocationPermission.always ||
                          perm == LocationPermission.whileInUse) {
                        await _fetchLocationAndPrayer();
                      } else {
                        // User denied → go back
                        if (mounted) Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    serviceDisabled ? 'Open Settings' : 'Allow Location',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // dialog
                  Navigator.pop(context); // go back to dashboard
                },
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: kTextGrey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchLocationAndPrayer() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      Position? pos;

      // 1️⃣ Try to get current position with a 10 second timeout
      try {
        pos =
            await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy:
                    LocationAccuracy.low, // low = faster, works on emulator
              ),
            ).timeout(
              const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException('GPS timeout'),
            );
      } catch (_) {
        // 2️⃣ Fallback: use last known position (instant, usually works on emulator)
        pos = await Geolocator.getLastKnownPosition();
      }

      // 3️⃣ Final fallback: use Dhaka coordinates (emulator has no GPS)
      pos ??= Position(
        latitude: 23.8103,
        longitude: 90.4125,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      _position = pos;
      final url = ApiEndpoints.prayer(pos.latitude, pos.longitude);
      final response = await ApiService.get(url);
      if (response['success'] == true) {
        final data = PrayerTimesData.fromJson(response['data']);
        setState(() {
          _prayerData = data;
          _locationGranted = true;
          _isLoading = false;
        });
        _startCountdown();
      }
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  void _startCountdown() {
    _ticker?.cancel();
    _updateCountdown();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_prayerData == null) return;
    final next = _prayerData!.nextPrayer;
    final diff = next.time.difference(DateTime.now());
    if (mounted) {
      setState(() {
        _countdown = diff.isNegative ? Duration.zero : diff;
      });
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  String _formatCountdown(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  // ── Build ────────────────────────────────────────────────────────────────────

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
        leading: widget.hideBack
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: kPrimaryBrown),
              )
            : _errorMsg != null
            ? _buildError()
            : _locationGranted && _prayerData != null
            ? _buildContent(isDark, sh, sw)
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: kPrimaryBrown, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMsg ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBrown),
              onPressed: _fetchLocationAndPrayer,
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark, double sh, double sw) {
    final data = _prayerData!;
    final currentPrayer = data.currentPrayerName;
    final next = data.nextPrayer;

    // Ordered prayer list (Removed sunrise/sunset as they go to a separate card)
    final prayers = [
      ('fajr', data.fajr),
      ('dhuhr', data.dhuhr),
      ('asr', data.asr),
      ('maghrib', data.maghrib),
      ('isha', data.isha),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: sw * 0.05,
        vertical: sh * 0.018,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hijri Date Pill ─────────────────────────────────────────
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.06,
                vertical: sh * 0.012,
              ),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                localizeDigits(data.hijriString, context),
                style: GoogleFonts.playfairDisplay(
                  color: kPrimaryBrown,
                  fontWeight: FontWeight.bold,
                  fontSize: sw * 0.035,
                ),
              ),
            ),
          ),
          // SizedBox(height: sh * 0.03),

          // ── Current Prayer Header ────────────────────────────────────
          Text(
            tr(currentPrayer),
            style: GoogleFonts.playfairDisplay(
              fontSize: sw * 0.06,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : kTextDark,
            ),
          ),
          SizedBox(height: sh * 0.006),

          // ── Countdown to next prayer ─────────────────────────────────
          Row(
            children: [
              const Icon(Icons.timer_outlined, color: kPrimaryBrown, size: 18),
              const SizedBox(width: 6),
              Text(
                "${tr("next_prayer")} ${tr(next.name)} ${tr("in")} ${localizeDigits(_formatCountdown(_countdown), context)}",
                style: GoogleFonts.playfairDisplay(
                  fontSize: sw * 0.04,
                  color: isDark ? Colors.white70 : kTextDark,
                ),
              ),
            ],
          ),
          SizedBox(height: sh * 0.025),

          // ── Prayer Times Card ────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(sw * 0.04),
            decoration: _cardDecoration(sw, isDark),
            child: Column(
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr("todays_prayer_time"),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: sw * 0.032,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    // Location info
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: sw * 0.035,
                          color: kPrimaryBrown,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "${_position!.latitude.toStringAsFixed(2)}°, ${_position!.longitude.toStringAsFixed(2)}°",
                          style: TextStyle(
                            fontSize: sw * 0.027,
                            color: isDark ? Colors.grey[400] : kTextGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: sh * 0.03,
                  color: isDark
                      ? Colors.grey.shade800
                      : const Color(0xFFEEEEEE),
                ),

                // Prayer rows
                ...prayers.map((entry) {
                  final pKey = entry.$1;
                  final pTime = entry.$2;
                  final isActive = pKey == currentPrayer;
                  final isPast = pTime.isBefore(DateTime.now());

                  if (isActive) {
                    // Highlighted active row
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: sh * 0.007),
                      padding: EdgeInsets.symmetric(
                        horizontal: sw * 0.03,
                        vertical: sh * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryBrown,
                        borderRadius: BorderRadius.circular(sw * 0.02),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryBrown.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                color: Colors.white70,
                                size: 8,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tr(pKey),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: sw * 0.035,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            localizeDigits(_formatTime(pTime), context),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: sw * 0.035,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Normal row
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: sw * 0.02,
                      horizontal: sw * 0.025,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr(pKey),
                          style: TextStyle(
                            fontSize: sw * 0.032,
                            color: isPast
                                ? (isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400)
                                : (isDark ? Colors.white : kTextDark),
                          ),
                        ),
                        Text(
                          localizeDigits(_formatTime(pTime), context),
                          style: TextStyle(
                            fontSize: sw * 0.032,
                            fontWeight: FontWeight.bold,
                            color: isPast
                                ? (isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400)
                                : (isDark ? Colors.white : kTextDark),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: sh * 0.018),

          // ── Sunrise & Sunset Section ──────────────────────────────
          SunriseSunsetCard(data: data),
          SizedBox(height: sh * 0.018),

          // ── Duas & Reflection Card (unchanged) ──────────────────────
          const DuasReflectionCard(),
          SizedBox(height: sh * 0.018),

          // ── Special in Ramadan Card ──────────────────────────────
          //const SpecialRamadanCard(),
          SizedBox(height: sh * 0.018),

          // ── Ramadan Countdown Card (dynamic sehri & iftar) ─────────
          RamadanCountdownCard(data: data),
          SizedBox(height: sh * 0.018),
        ],
      ),
    );
  }
}

// ==========================================
// WIDGETS (original, unchanged)
// ==========================================

// class PrayerTimesCard extends StatelessWidget {
//   // Old static card - replaced by live API version above
// }

// ==========================================
// WIDGETS
// ==========================================

class SunriseSunsetCard extends StatelessWidget {
  final PrayerTimesData data;
  const SunriseSunsetCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(sw * 0.04),
      decoration: _cardDecoration(sw, isDark),
      child: Row(
        children: [
          // Sunrise
          Expanded(
            child: _buildItem(
              context,
              isDark,
              sw,
              Icons.wb_sunny_outlined,
              tr("sunrise"),
              data.sunrise,
              const Color(0xFFE67E22), // Warm orange
            ),
          ),
          // Vertical Divider
          Container(
            height: 40,
            width: 1,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            margin: EdgeInsets.symmetric(horizontal: sw * 0.04),
          ),
          // Sunset
          Expanded(
            child: _buildItem(
              context,
              isDark,
              sw,
              Icons.wb_twilight_outlined,
              tr("sunset"),
              data.sunset,
              const Color(0xFFD35400), // Deeper orange
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    bool isDark,
    double sw,
    IconData icon,
    String label,
    DateTime time,
    Color iconColor,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(sw * 0.02),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: sw * 0.05),
        ),
        SizedBox(width: sw * 0.03),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: sw * 0.028,
                color: isDark ? Colors.white60 : kTextGrey,
              ),
            ),
            Text(
              localizeDigits(_formatTime(time), context),
              style: TextStyle(
                fontSize: sw * 0.035,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : kTextDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }
}

class DuasReflectionCard extends StatelessWidget {
  const DuasReflectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(sw * 0.04),
      decoration: _cardDecoration(sw, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("duas_reflection"),
            style: GoogleFonts.playfairDisplay(
              fontSize: sw * 0.032,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
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
                  onTap: () => Get.to(() => const DuaListScreen()),
                ),
              ),
              SizedBox(width: sw * 0.04),
              Expanded(
                child: _brownButton(
                  tr("dua_after_salah"),
                  sw,
                  showArrow: true,
                  fullWidth: true,
                  onTap: () => Get.to(() => const DuaListScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class SpecialRamadanCard extends StatelessWidget {
//   const SpecialRamadanCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final sw = MediaQuery.of(context).size.width;

//     return Container(
//       padding: EdgeInsets.all(sw * 0.04),
//       decoration: _cardDecoration(sw, isDark),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 tr("special_in_ramadan"),
//                 style: GoogleFonts.playfairDisplay(
//                   fontSize: sw * 0.032,
//                   fontWeight: FontWeight.bold,
//                   color: isDark ? Colors.white : Colors.black,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     tr("special_month"),
//                     style: TextStyle(
//                       fontSize: sw * 0.03,
//                       color: isDark ? Colors.grey[400] : Colors.black,
//                     ),
//                   ),
//                   Icon(
//                     Icons.keyboard_arrow_down,
//                     size: sw * 0.04,
//                     color: isDark ? Colors.grey[400] : Colors.black,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.025),
//           Row(
//             children: [
//               Expanded(
//                 child: _iconPillButton(
//                   Icons.mosque_outlined,
//                   tr("dua_for_ramadan"),
//                   sw,
//                   isDark,
//                 ),
//               ),
//               SizedBox(width: sw * 0.04),
//               Expanded(
//                 child: _iconPillButton(
//                   Icons.dark_mode_outlined,
//                   tr("track_fasting"),
//                   sw,
//                   isDark,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _iconPillButton(IconData icon, String label, double sw, bool isDark) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         vertical: sw * 0.03,
//         horizontal: sw * 0.025,
//       ),
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
//         borderRadius: BorderRadius.circular(sw * 0.08),
//         border: Border.all(
//           color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
//         ),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5),
//         ],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: sw * 0.03,
//             backgroundColor: kPrimaryBrown,
//             child: Icon(icon, size: sw * 0.035, color: Colors.white),
//           ),
//           SizedBox(width: sw * 0.02),
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: sw * 0.028,
//                 fontWeight: FontWeight.bold,
//                 color: isDark ? Colors.white : Colors.black,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Icon(
//             Icons.chevron_right,
//             size: sw * 0.04,
//             color: isDark ? Colors.white : Colors.black,
//           ),
//         ],
//       ),
//     );
//   }
// }

class RamadanCountdownCard extends StatefulWidget {
  final PrayerTimesData data;
  const RamadanCountdownCard({super.key, required this.data});

  @override
  State<RamadanCountdownCard> createState() => _RamadanCountdownCardState();
}

class _RamadanCountdownCardState extends State<RamadanCountdownCard> {
  Timer? _ticker;
  Duration _sehriCountdown = Duration.zero;
  Duration _iftarCountdown = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateCountdowns();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdowns();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _updateCountdowns() {
    final now = DateTime.now();
    if (widget.data.sehri != null) {
      final diff = widget.data.sehri!.difference(now);
      _sehriCountdown = diff.isNegative ? Duration.zero : diff;
    }
    if (widget.data.iftar != null) {
      final diff = widget.data.iftar!.difference(now);
      _iftarCountdown = diff.isNegative ? Duration.zero : diff;
    }
    if (mounted) setState(() {});
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _fmtTime(DateTime? dt) {
    if (dt == null) return '--:--';
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final data = widget.data;

    // Determine sub-label per circle
    final now = DateTime.now();
    final sehriLabel = data.sehri != null && now.isBefore(data.sehri!)
        ? "${tr("starts_in")} ${localizeDigits(_fmt(_sehriCountdown), context)}"
        : localizeDigits(tr("sahuri_time"), context);
    final iftarLabel = data.iftar != null && now.isBefore(data.iftar!)
        ? "${tr("end_in")} ${localizeDigits(_fmt(_iftarCountdown), context)}"
        : localizeDigits(tr("iftar_time"), context);

    return Container(
      padding: EdgeInsets.all(sw * 0.035),
      decoration: _cardDecoration(sw, isDark),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizeDigits(
              "${data.hijriString}   ≈   ${data.hijriDate}",
              context,
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: sw * 0.035,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: sh * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleInfo(
                kNavyCircle,
                Icons.nights_stay_outlined,
                tr("sahuri_time"),
                localizeDigits(_fmtTime(data.sehri), context),
                sehriLabel,
                sw,
              ),
              SizedBox(width: sw * 0.04),
              _circleInfo(
                kOrangeCircleStart,
                Icons.wb_twilight_outlined,
                tr("iftar_time"),
                localizeDigits(_fmtTime(data.iftar), context),
                iftarLabel,
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
      width: sw * 0.37,
      height: sw * 0.37,
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
          Icon(icon, color: Colors.white, size: sw * 0.045),
          SizedBox(height: sw * 0.01),
          Text(
            title,
            style: TextStyle(color: Colors.white70, fontSize: sw * 0.028),
          ),
          SizedBox(height: sw * 0.002),
          Text(
            time,
            style: TextStyle(
              color: Colors.white,
              fontSize: sw * 0.032,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sw * 0.01),
          Container(height: 1, width: sw * 0.22, color: Colors.white30),
          SizedBox(height: sw * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sw * 0.02),
            child: Text(
              sub,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: sw * 0.022),
            ),
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
      padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.06),
      decoration: _cardDecoration(sw, isDark),
      child: Column(
        children: [
          Text(
            tr("ayah_of_the_day"),
            style: GoogleFonts.playfairDisplay(
              fontSize: sw * 0.035,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Divider(
            height: MediaQuery.of(context).size.height * 0.03,
            color: isDark ? Colors.grey.shade800 : const Color(0xFFEEEEEE),
          ),
          Text(
            "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٥﴾\nإِنَّ مَعَ الْعُسْرِ يُسْرًا ﴿٦﴾",
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: sw * 0.05,
              fontWeight: FontWeight.bold,
              height: 1.5,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: sw * 0.04),
          Text(
            tr("ayah_meaning"),
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: sw * 0.038,
              color: isDark ? Colors.white : kTextDark,
            ),
          ),
          SizedBox(height: sw * 0.04),
          Text(
            localizeDigits(tr("surah_reference"), context),
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
    borderRadius: BorderRadius.circular(sw * 0.05),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
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
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: fullWidth ? sw * 0.038 : sw * 0.05,
        vertical: sw * 0.03,
      ),
      decoration: BoxDecoration(
        color: kPrimaryBrown,
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
              fontSize: sw * 0.028,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showArrow)
            Icon(Icons.chevron_right, color: Colors.white, size: sw * 0.04),
        ],
      ),
    ),
  );
}
