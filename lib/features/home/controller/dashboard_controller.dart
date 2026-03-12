import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/features/hadis/views/hadis_screen.dart';
import 'package:maroofkhan8/features/quran/views/quran_screen.dart';
import '../../audio/views/audio_screen.dart';
import '../../dua/views/dua_screen.dart';
import '../../islamic_stories/views/islamic_stories.dart';
import '../../prayer_tracker/views/prayer_tracker_screen.dart';
import '../../zakat_calculator/views/zakat_calculator.dart';
import '../../../core/network/api_Service.dart';
import '../../../core/network/api_endpoints.dart';

class QuickStartFeature {
  final String titleKey;
  final IconData? icon;
  final String? imagePath;
  final String? darkImagePath;
  final Widget Function() destination;
  final Color Function(bool isDark, Color primary) colorBuilder;
  final bool isPinkCard;

  QuickStartFeature({
    required this.titleKey,
    this.icon,
    this.imagePath,
    this.darkImagePath,
    required this.destination,
    required this.colorBuilder,
    this.isPinkCard = false,
  });
}

class DashboardController extends GetxController with WidgetsBindingObserver {
  var searchQuery = ''.obs;
  var bannerQuote = {}.obs;
  var userActivity = {}.obs;
  var isQuoteLoading = false.obs;
  var isActivityLoading = false.obs;
  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchBannerQuote();
    refreshAllData();
    // _startPeriodicRefresh(); // Commented out as requested - using RefreshIndicator instead
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshAllData();
    }
  }

  Future<void> refreshAllData() async {
    await Future.wait([
      pingUser(),
      fetchUserActivity(),
      //fetchBannerQuote(), // Also refresh banner quote
    ]);
  }

  // void _startPeriodicRefresh() {
  //   _refreshTimer?.cancel();
  //   // Ping every 30 seconds and refresh activity
  //   _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
  //     refreshAllData();
  //   });
  // }

  Future<void> fetchBannerQuote() async {
    isQuoteLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.bannerQuote);
      if (response['success'] == true) {
        bannerQuote.value = response['data'] ?? {};
      }
    } catch (e) {
      if (e is! String) print("Error fetching banner quote: $e");
    } finally {
      isQuoteLoading.value = false;
    }
  }

  Future<void> fetchUserActivity() async {
    // Only show loading for the very first fetch or if data is empty
    if (userActivity.isEmpty) isActivityLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.userActivity);
      if (response['success'] == true && response['data'] != null) {
        userActivity.assignAll(response['data']);
        debugPrint("User Activity Data Refreshed: $userActivity");
      }
    } catch (e) {
      debugPrint("Error fetching user activity: $e");
    } finally {
      isActivityLoading.value = false;
    }
  }

  Future<void> pingUser() async {
    try {
      await ApiService.get(ApiEndpoints.mePing);
      debugPrint("User Pinged successfully");
    } catch (e) {
      debugPrint("Error pinging user: $e");
    }
  }

  final List<QuickStartFeature> allFeatures = [
    QuickStartFeature(
      titleKey: "feature_quran",
      icon: Icons.menu_book,
      destination: () => const QuranScreen(),
      colorBuilder: (isDark, primary) =>
          isDark ? primary.withOpacity(0.15) : const Color(0xFFDCD6FF),
    ),
    QuickStartFeature(
      titleKey: "feature_hadith",
      icon: Icons.book,
      destination: () => const HadithScreen(),
      colorBuilder: (isDark, primary) =>
          isDark ? Colors.orange.withOpacity(0.15) : const Color(0xFFFFD6CA),
    ),
    QuickStartFeature(
      titleKey: "feature_dua",
      icon: Icons.front_hand,
      destination: () => const DuaListScreen(),
      colorBuilder: (isDark, primary) =>
          isDark ? Colors.orange.withOpacity(0.15) : const Color(0xFFFFD6CA),
    ),
    QuickStartFeature(
      titleKey: "feature_prayer_tracker",
      icon: Icons.gps_fixed,
      destination: () => const PrayerTrackerScreenn(),
      colorBuilder: (isDark, primary) =>
          isDark ? primary.withOpacity(0.1) : const Color(0xFFE0D9FA),
    ),
    QuickStartFeature(
      titleKey: "feature_islamic_stories",
      icon: Icons.auto_stories,
      destination: () => const IslamicStoriesScreen(),
      colorBuilder: (isDark, primary) =>
          isDark ? primary.withOpacity(0.15) : const Color(0xFFDCD6FF),
    ),
    QuickStartFeature(
      titleKey: "feature_zakat_calculator",
      imagePath: "assets/images/zakat.png",
      darkImagePath: "assets/images/zakat_white.png",
      destination: () => const ZakatCalculator(),
      colorBuilder: (isDark, primary) =>
          isDark ? Colors.pink.withOpacity(0.15) : const Color(0xFFE94E77),
      isPinkCard: true,
    ),
    QuickStartFeature(
      titleKey: "feature_audio",
      icon: Icons.audiotrack,
      destination: () => const AudioScreen(),
      colorBuilder: (isDark, primary) =>
          isDark ? primary.withOpacity(0.15) : const Color(0xFFDCD6FF),
    ),
  ];

  List<QuickStartFeature> get filteredFeatures {
    if (searchQuery.value.isEmpty) {
      return allFeatures;
    }
    return allFeatures
        .where(
          (feature) => tr(feature.titleKey)
              .toLowerCase()
              .replaceAll('\n', ' ')
              .contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }
}
