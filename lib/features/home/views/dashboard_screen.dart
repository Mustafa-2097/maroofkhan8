import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/hadis/views/hadis_screen.dart';
import 'package:maroofkhan8/features/profile/view/profile_screen.dart';
import 'package:maroofkhan8/features/quran/views/quran_screen.dart';
import '../../../core/constant/app_colors.dart';
import '../../Islam_meditation/views/islam_meditation_screen.dart';
import '../../ahle_bait/views/ahle_bait_screen.dart';
import '../../allah_names/views/allah_names.dart' hide HeaderWithLines;
import '../../dua/views/dua_screen.dart';
import '../../islamic_books/views/islamic_books_screen.dart';
import '../../islamic_calander/views/islamic_calander.dart';
import '../../prayer_tracker/views/prayer_tracker_screen.dart';
import '../../sahaba/views/sahaba_screen.dart';
import '../../salawat/views/salawat_screen.dart';
import '../../sufism/views/sufism_screen.dart' hide HeaderWithLines;
import '../../zakat_calculator/views/zakat_calculator.dart';
import '../awliya_allah/awliya_allah_list_screen.dart';
import '../tasbih/tasbih_screen.dart';
import 'custom_app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).colorScheme.background;

    return Scaffold(
      drawer: const CustomAppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor.withOpacity(0.95),
              backgroundColor,
              backgroundColor,
            ],
          )
              : LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade100,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(),
                const SizedBox(height: 20),
                HeroSection(),
                const SizedBox(height: 30),

                // 1. Your Journey Section
                SectionHeader(title: "Your Journey"),
                const SizedBox(height: 15),
                const YourJourneyRow(),

                const SizedBox(height: 30),

                // 2. Quick Start Section
                SectionHeader(title: "Quick Start"),
                const SizedBox(height: 15),
                const QuickStartGrid(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(
                Icons.menu_rounded,
                color: primaryColor,
                size: 26,
              ),
            ),
            // Logo Circle
            Row(
              children: [
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/onboarding02.png',
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Digital Khanqah",
                  style: Theme.of(context).textTheme.headlineSmall
                ),
              ],
            ),
            InkWell(
              onTap: () => Get.to(() => const ProfileScreen()),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// Greeting
        Text(
          "Assalamu Alaikum",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.6),
            fontSize: 20.sp,
            height: 0.9,
          ),
        ),
        /// Main message
        Text(
          "May your heart find peace today",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
            height: 1.3,
          ),
        ),

        const SizedBox(height: 13),

        /// Search bar
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: isDark ? kDarkBlack : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: Theme.of(context).disabledColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Quran, Duas, Names…",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      "title": "Daily Story",
      "nameEn": "Abdul Qadir al-Jilani",
      "nameAr": "شيخ عبدالقادر جيلاني",
      "quoteEn": "He who knows self\nknows his Lord.",
      "quoteAr": "من عرف نفسه فقد عرف ربه",
      "image": "https://img.freepik.com/free-vector/islamic-pattern-background-luxury-green-gold_1017-30814.jpg",
      "progress": 0.3,
      "time": "58 sec",
    },
    {
      "title": "Daily Wisdom",
      "nameEn": "Jalaluddin Rumi",
      "nameAr": "جلال الدين الرومي",
      "quoteEn": "What you seek is\nseeking you.",
      "quoteAr": "ما تبحث عنه يبحث عنك",
      "image": "https://img.freepik.com/free-vector/gradient-islamic-new-year-background_23-2148967924.jpg",
      "progress": 0.7,
      "time": "1 min 20 sec",
    },
    {
      "title": "Hadith of the Day",
      "nameEn": "Imam Ali (AS)",
      "nameAr": "الإمام علي",
      "quoteEn": "Patience is of two kinds: patience over what pains you, and patience against what you covet.",
      "quoteAr": "الصبر صبران: صبر على ما تكره وصبر عما تحب",
      "image": "https://img.freepik.com/free-vector/golden-islamic-pattern-dark-background_1017-31354.jpg",
      "progress": 0.1,
      "time": "45 sec",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildSlideCard(_slides[index], isDark, primaryColor);
            },
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? primaryColor : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSlideCard(Map<String, dynamic> data, bool isDark, Color primaryColor) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(data['image']),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            // Tag (Top Left)
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Icons (Top Right)
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_border, color: Colors.white.withOpacity(0.8)),
                  const SizedBox(width: 10),
                  Icon(Icons.download_outlined, color: Colors.white.withOpacity(0.8)),
                ],
              ),
            ),

            // Content (Center)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data['nameEn'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['nameAr'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data['quoteEn'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data['quoteAr'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Progress & Time (Bottom)
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    value: data['progress'],
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, color: Colors.white, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          data['time'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}

class YourJourneyRow extends StatelessWidget {
  const YourJourneyRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        // Card 1: 5 Day Streak (Purple)
        Expanded(
          child: _JourneyCard(
            topText: "5",
            bottomText: "Day\nStreak",
            color: isDark ? primaryColor.withOpacity(0.15) : const Color(0xFFDCD6FF),
            icon: Icons.local_fire_department,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),

        // Card 2: 1 Surah (Peach)
        Expanded(
          child: _JourneyCard(
            topText: "1",
            bottomText: "Surah",
            color: isDark ? Colors.orange.withOpacity(0.15) : const Color(0xFFFFD6CA),
            icon: Icons.menu_book,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),

        // Card 3: 2h 15 min Surah (Green)
        Expanded(
          child: _JourneyCard(
            topText: "2h 15\nmin",
            bottomText: "Surah",
            color: isDark ? Colors.green.withOpacity(0.15) : const Color(0xFFE6F5D8),
            icon: Icons.schedule,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),

        // Card 4: 8 Saved (Pink)
        Expanded(
          child: _JourneyCard(
            topText: "8",
            bottomText: "Saved",
            color: isDark ? Colors.pink.withOpacity(0.15) : const Color(0xFFE94E77),
            icon: Icons.bookmark_border,
            isPinkCard: true,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _JourneyCard extends StatelessWidget {
  final String topText;
  final String bottomText;
  final Color color;
  final IconData icon;
  final bool isPinkCard;
  final bool isDark;

  const _JourneyCard({
    required this.topText,
    required this.bottomText,
    required this.color,
    required this.icon,
    this.isPinkCard = false,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
            child: Icon(
              icon,
              size: 18,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            topText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            bottomText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickStartGrid extends StatelessWidget {
  const QuickStartGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.90,
      mainAxisSpacing: 12,
      crossAxisSpacing: 4,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => QuranScreen());
          },
          child: _GridCard(
            title: "Quran",
            icon: Icons.menu_book,
            color: isDark ? primaryColor.withOpacity(0.15) : const Color(0xFFDCD6FF),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => HadithScreen());
          },
          child: _GridCard(
            title: "Hadith",
            icon: Icons.book,
            color: isDark ? Colors.orange.withOpacity(0.15) : const Color(0xFFFFD6CA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => DuaApp());
          },
          child: _GridCard(
            title: "Dua",
            icon: Icons.front_hand,
            color: isDark ? Colors.orange.withOpacity(0.15) : const Color(0xFFFFD6CA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => PrayerTrackerScreen());
          },
          child: _GridCard(
            title: "Prayer\nTracker",
            icon: Icons.gps_fixed,
            color: isDark ? primaryColor.withOpacity(0.1) : const Color(0xFFE0D9FA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: _GridCard(
            title: "Islamic\nStories",
            icon: Icons.auto_stories,
            color: isDark ? primaryColor.withOpacity(0.15) : const Color(0xFFDCD6FF),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => ZakatCalculator());
          },
          child: _GridCard(
            title: "Zakat\nCalculator",
            icon: Icons.savings_outlined,
            color: isDark ? Colors.pink.withOpacity(0.15) : const Color(0xFFE94E77),
            isPinkCard: true,
            textColor: isDark ? Colors.white : Colors.white,
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => PrayerTrackerScreen());
          },
          child: _GridCard(
            title: "Islamic\nCalendar",
            icon: Icons.calendar_month_outlined,
            color: isDark ? Colors.green.withOpacity(0.15) : const Color(0xFFE6F5D8),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: _GridCard(
            title: "Audio",
            icon: Icons.audiotrack,
            color: isDark ? primaryColor.withOpacity(0.15) : const Color(0xFFDCD6FF),
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class ExploreMoreGrid extends StatelessWidget {
  const ExploreMoreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.90,
      mainAxisSpacing: 12,
      crossAxisSpacing: 4,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => AhleBaitListScreen());
          },
          child: _GridCard(
            title: "Ahle Bait",
            icon: Icons.diversity_3,
            color: isDark ? Colors.green.withOpacity(0.15) : const Color(0xFFE6F5D8),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => AwliyaAllahListScreen());
          },
          child: _GridCard(
            title: "Awliya\nAllah",
            icon: Icons.nightlight_round,
            color: isDark ? Colors.green.withOpacity(0.15) : const Color(0xFFE6F5D8),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SahabaListScreen());
          },
          child: _GridCard(
            title: "Sahaba",
            icon: Icons.groups,
            color: isDark ? Colors.orange.withOpacity(0.15) : const Color(0xFFFFD6CA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SufismHomeScreen());
          },
          child: _GridCard(
            title: "Dhikr",
            icon: Icons.search,
            color: isDark ? Colors.pink.withOpacity(0.15) : const Color(0xFFE94E77),
            isPinkCard: true,
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => NamesOfAllahScreen());
          },
          child: _GridCard(
            title: "99\nNames",
            icon: Icons.verified_outlined,
            color: isDark ? primaryColor.withOpacity(0.1) : const Color(0xFFE0D9FA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => IslaahApp());
          },
          child: _GridCard(
            title: "Islaah &\nMeditation",
            icon: Icons.self_improvement,
            color: isDark ? primaryColor.withOpacity(0.1) : const Color(0xFFE0D9FA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SalawatListScreen());
          },
          child: _GridCard(
            title: "Salawat",
            icon: Icons.handshake_outlined,
            color: isDark ? Colors.orange.withOpacity(0.15) : const Color(0xFFFFD6CA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => IslamicBooksListScreen());
          },
          child: _GridCard(
            title: "Islamic\nBooks",
            icon: Icons.diversity_2,
            color: isDark ? Colors.pink.withOpacity(0.15) : const Color(0xFFE94E77),
            isPinkCard: true,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

class _GridCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isPinkCard;
  final Color? textColor;
  final bool isDark;

  const _GridCard({
    required this.title,
    required this.icon,
    required this.color,
    this.isPinkCard = false,
    this.textColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
            child: Icon(
              icon,
              size: 18,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}