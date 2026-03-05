import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/profile/view/profile_screen.dart';
import 'package:maroofkhan8/features/quran/views/quran_screen.dart';
import '../../../core/constant/app_colors.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/dashboard_controller.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderSection(),
                SizedBox(height: 20.h),
                const HeroSection(),
                SizedBox(height: 30.h),

                // 1. Your Journey Section
                const SectionHeader(title: "Your Journey"),
                SizedBox(height: 15.h),
                const YourJourneyRow(),

                SizedBox(height: 30.h),

                // 2. Quick Start Section
                const SectionHeader(title: "Quick Start"),
                SizedBox(height: 15.h),
                const QuickStartGrid(),

                SizedBox(height: 40.h),
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

    final profileController = Get.put(ProfileController());
    final dashboardController = Get.put(DashboardController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(Icons.menu_rounded, color: primaryColor, size: 26),
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
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            InkWell(
              onTap: () => Get.to(() => ProfileScreen()),
              child: Obx(
                () => CircleAvatar(
                  radius: 18,
                  backgroundColor: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  backgroundImage: profileController.avatar.value.isNotEmpty
                      ? NetworkImage(profileController.avatar.value)
                      : null,
                  child: profileController.avatar.value.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 20,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade600,
                        )
                      : null,
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
        // Container(
        //   height: 45,
        //   padding: const EdgeInsets.symmetric(horizontal: 15),
        //   decoration: BoxDecoration(
        //     color: isDark ? kDarkBlack : Colors.white,
        //     borderRadius: BorderRadius.circular(10),
        //     border: Border.all(color: AppColors.stroke),
        //   ),
        //   child: Row(
        //     children: [
        //       Icon(Icons.search, color: Theme.of(context).disabledColor),
        //       const SizedBox(width: 8),
        //       Expanded(
        //         child: TextField(
        //           onChanged: (val) {
        //             dashboardController.searchQuery.value = val;
        //           },
        //           decoration: const InputDecoration(
        //             hintText: "Search Features...",
        //             hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        //             border: InputBorder.none,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    final dashboardController = Get.find<DashboardController>();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final slidesCount = dashboardController.bannerQuote.isNotEmpty
          ? 1
          : 1; // Currently only 1 from API
      if (_currentIndex < slidesCount - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Fallback slides if API fails or for other types
  final List<Map<String, dynamic>> _fallbackSlides = [
    {
      "type": "Daily Story",
      "title": "شيخ عبدالقادر جيلاني",
      "description": "He who knows self\nknows his Lord.",
      "image":
          "https://img.freepik.com/free-vector/islamic-pattern-background-luxury-green-gold_1017-30814.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final dashboardController = Get.find<DashboardController>();

    return Obx(() {
      if (dashboardController.isQuoteLoading.value) {
        return const SizedBox(
          height: 210,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final quoteData = dashboardController.bannerQuote;
      final List<Map<String, dynamic>> slides = [];

      if (quoteData.isNotEmpty) {
        slides.add({
          "type": "Daily Story",
          "title": quoteData['title'] ?? "",
          "description": quoteData['description'] ?? "",
          "image":
              "https://img.freepik.com/free-vector/islamic-pattern-background-luxury-green-gold_1017-30814.jpg",
        });
      } else {
        slides.addAll(_fallbackSlides);
      }

      // Update timer if slides length changed
      if (_timer == null || slides.length != 1) {
        // Simple one slide doesn't need complex timer but keeping for future expansion
      }

      return Column(
        children: [
          SizedBox(
            height: 210,
            child: PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildSlideCard(slides[index], isDark, primaryColor);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSlideCard(
    Map<String, dynamic> data,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      width: double.infinity,
      height: 210,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data['type'] ?? "Daily Story",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Icons (Top Right)
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(
            //         Icons.bookmark_border,
            //         color: Colors.white.withOpacity(0.8),
            //       ),
            //       const SizedBox(width: 10),
            //       Icon(
            //         Icons.download_outlined,
            //         color: Colors.white.withOpacity(0.8),
            //       ),
            //     ],
            //   ),
            // ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data['title'] ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data['description'] ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Progress & Time (Bottom)
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       LinearProgressIndicator(
            //         value: data['progress'],
            //         backgroundColor: Colors.white.withOpacity(0.3),
            //         valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            //         borderRadius: BorderRadius.circular(4),
            //       ),
            //       const SizedBox(height: 10),
            //       Container(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 10,
            //           vertical: 5,
            //         ),
            //         decoration: BoxDecoration(
            //           color: primaryColor.withOpacity(0.4),
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         child: Row(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Icon(Icons.access_time, color: Colors.white, size: 14),
            //             const SizedBox(width: 5),
            //             Text(
            //               data['time'],
            //               style: const TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 12,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
            color: isDark
                ? primaryColor.withOpacity(0.15)
                : const Color(0xFFDCD6FF),
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
            color: isDark
                ? Colors.orange.withOpacity(0.15)
                : const Color(0xFFFFD6CA),
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
            color: isDark
                ? Colors.green.withOpacity(0.15)
                : const Color(0xFFE6F5D8),
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
            color: isDark
                ? Colors.pink.withOpacity(0.15)
                : const Color(0xFFE94E77),
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              topText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 12.sp,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              bottomText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 10.sp,
              ),
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
    final DashboardController controller = Get.find<DashboardController>();

    return Obx(() {
      final features = controller.filteredFeatures;

      if (features.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              "No features found matching your search.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: features.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.75, // Increased vertical space
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 8.w,
        ),
        itemBuilder: (context, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () {
              Get.to(feature.destination());
            },
            child: _GridCard(
              title: feature.title,
              icon: feature.icon,
              color: feature.colorBuilder(isDark, primaryColor),
              isPinkCard: feature.isPinkCard,
              textColor: isDark ? Colors.white : Colors.white,
              isDark: isDark,
            ),
          );
        },
      );
    });
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
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
