import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final String title;
  final IconData icon;
  final Widget Function() destination;
  final Color Function(bool isDark, Color primary) colorBuilder;
  final bool isPinkCard;

  QuickStartFeature({
    required this.title,
    required this.icon,
    required this.destination,
    required this.colorBuilder,
    this.isPinkCard = false,
  });
}

class DashboardController extends GetxController {
  var searchQuery = ''.obs;
  var bannerQuote = {}.obs;
  var isQuoteLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBannerQuote();
  }

  Future<void> fetchBannerQuote() async {
    isQuoteLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.bannerQuote);
      if (response['success'] == true) {
        bannerQuote.value = response['data'] ?? {};
      }
    } catch (e) {
      print("Error fetching banner quote: $e");
    } finally {
      isQuoteLoading.value = false;
    }
  }

  final List<QuickStartFeature> allFeatures = [
    QuickStartFeature(
      title: "Quran",
      icon: Icons.menu_book,
      destination: () => const QuranScreen(),
      colorBuilder: (isDark, primary) =>
          isDark ? primary.withOpacity(0.15) : const Color(0xFFDCD6FF),
    ),
    QuickStartFeature(
      title: "Hadith",
      icon: Icons.book,
      destination: () => const HadithScreen(),
      colorBuilder: (isDark, primary) =>
          isDark ? Colors.orange.withOpacity(0.15) : const Color(0xFFFFD6CA),
    ),
    QuickStartFeature(
      title: "Dua",
      icon: Icons.front_hand,
      destination: () => const DuaListScreen(),
      colorBuilder: (isDark, primary) =>
          isDark ? Colors.orange.withOpacity(0.15) : const Color(0xFFFFD6CA),
    ),
    QuickStartFeature(
      title: "Prayer\nTracker",
      icon: Icons.gps_fixed,
      destination: () => const PrayerTrackerScreenn(),
      colorBuilder: (isDark, primary) =>
          isDark ? primary.withOpacity(0.1) : const Color(0xFFE0D9FA),
    ),
    QuickStartFeature(
      title: "Islamic\nStories",
      icon: Icons.auto_stories,
      destination: () => const IslamicStoriesScreen(),
      colorBuilder: (isDark, primary) =>
          isDark ? primary.withOpacity(0.15) : const Color(0xFFDCD6FF),
    ),
    QuickStartFeature(
      title: "Zakat\nCalculator",
      icon: Icons.savings_outlined,
      destination: () => const ZakatCalculator(),
      colorBuilder: (isDark, primary) =>
          isDark ? Colors.pink.withOpacity(0.15) : const Color(0xFFE94E77),
      isPinkCard: true,
    ),
    QuickStartFeature(
      title: "Audio",
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
          (feature) => feature.title
              .toLowerCase()
              .replaceAll('\n', ' ')
              .contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }
}
