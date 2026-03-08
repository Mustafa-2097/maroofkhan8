import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maroofkhan8/features/profile/view/profile_screen.dart';
import 'package:maroofkhan8/features/quran/views/quran_screen.dart';
import '../../../core/constant/app_colors.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/dashboard_controller.dart';
import 'custom_app_drawer.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to locale changes
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).colorScheme.background;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

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
            // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            padding: EdgeInsets.symmetric(
              horizontal: sw * 0.04,
              vertical: sh * 0.012,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderSection(),
                // SizedBox(height: 20.h),
                SizedBox(height: sh * 0.025),
                const HeroSection(),
                // SizedBox(height: 30.h),
                SizedBox(height: sh * 0.035),

                // 1. Your Journey Section
                SectionHeader(title: tr("your_journey")),
                // SizedBox(height: 15.h),
                SizedBox(height: sh * 0.018),
                const YourJourneyRow(),

                // SizedBox(height: 30.h),
                SizedBox(height: sh * 0.035),

                // 2. Quick Start Section
                SectionHeader(title: tr("quick_start")),
                // SizedBox(height: 15.h),
                SizedBox(height: sh * 0.018),
                const QuickStartGrid(),

                // SizedBox(height: 40.h),
                SizedBox(height: sh * 0.05),
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
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

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
              // child: Icon(Icons.menu_rounded, color: primaryColor, size: 26),
              child: Icon(
                Icons.menu_rounded,
                color: primaryColor,
                size: sw * 0.065,
              ),
            ),
            // Logo Circle
            Row(
              children: [
                Container(
                  // height: 35,
                  height: sh * 0.045,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/onboarding02.png',
                      // height: 100,
                      height: sh * 0.1,
                    ),
                  ),
                ),
                // SizedBox(width: 10),
                SizedBox(width: sw * 0.025),
                Text(
                  tr("digital_khanqah"),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            InkWell(
              onTap: () => Get.to(() => ProfileScreen()),
              child: Obx(
                () => CircleAvatar(
                  // radius: 18,
                  radius: sw * 0.045,
                  backgroundColor: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  backgroundImage: profileController.avatar.value.isNotEmpty
                      ? NetworkImage(profileController.avatar.value)
                      : null,
                  child: profileController.avatar.value.isEmpty
                      ? Icon(
                          Icons.person,
                          // size: 20,
                          size: sw * 0.05,
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

        // const SizedBox(height: 20),
        SizedBox(height: sh * 0.025),

        /// Greeting
        Text(
          tr("greeting"),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).disabledColor.withValues(alpha: 0.6),
            // fontSize: 20.sp,
            fontSize: sw * 0.05,
            height: 0.9,
          ),
        ),

        /// Main message
        Text(
          tr("greeting_subtitle"),
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
      "type": "daily_story",
      "title": "شيخ عبدالقادر جيلاني",
      "description": "He who knows self\nknows his Lord.",
      "image":
          "https://img.freepik.com/free-vector/islamic-pattern-background-luxury-green-gold_1017-30814.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final dashboardController = Get.find<DashboardController>();
    final sh = MediaQuery.of(context).size.height;

    return Obx(() {
      if (dashboardController.isQuoteLoading.value) {
        return SizedBox(
          // height: 210,
          height: sh * 0.25,
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      final quoteData = dashboardController.bannerQuote;
      final List<Map<String, dynamic>> slides = [];

      if (quoteData.isNotEmpty) {
        slides.add({
          "type": "daily_story",
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
            // height: 210,
            height: sh * 0.25,
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
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

    return Container(
      // margin: EdgeInsets.only(right: 8),
      margin: EdgeInsets.only(right: sw * 0.02),
      width: double.infinity,
      // height: 210,
      height: sh * 0.25,
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
                  tr(data['type'] ?? "daily_story"),
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
    context.locale;
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
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        // Card 1: 5 Day Streak (Purple)
        Expanded(
          child: _JourneyCard(
            topText: tr("num_5"),
            bottomText: tr("day_streak"),
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
            topText: tr("num_1"),
            bottomText: tr("surah"),
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
            topText: tr("time_2h_15m"),
            bottomText: tr("surah"),
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
            topText: tr("num_8"),
            bottomText: tr("saved"),
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
            // radius: 14,
            radius: MediaQuery.of(context).size.width * 0.035,
            backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
            child: Icon(
              icon,
              // size: 18,
              size: MediaQuery.of(context).size.width * 0.045,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          // const SizedBox(height: 6),
          SizedBox(height: MediaQuery.of(context).size.height * 0.008),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              topText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                // fontSize: 12.sp,
                fontSize: MediaQuery.of(context).size.width * 0.03,
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
                // fontSize: 10.sp,
                fontSize: MediaQuery.of(context).size.width * 0.025,
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
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final DashboardController controller = Get.find<DashboardController>();
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;

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
          // childAspectRatio: 0.75, // Increased vertical space
          childAspectRatio: (sw / 4) / (sh * 0.15),
          // mainAxisSpacing: 12.h,
          mainAxisSpacing: sh * 0.015,
          // crossAxisSpacing: 8.w,
          crossAxisSpacing: sw * 0.02,
        ),
        itemBuilder: (context, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () {
              Get.to(feature.destination());
            },
            child: _GridCard(
              title: tr(feature.titleKey),
              icon: feature.icon,
              imagePath: feature.imagePath,
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
  final IconData? icon;
  final String? imagePath;
  final Color color;
  final bool isPinkCard;
  final Color? textColor;
  final bool isDark;

  const _GridCard({
    required this.title,
    this.icon,
    this.imagePath,
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
            // radius: 16,
            radius: MediaQuery.of(context).size.width * 0.04,
            backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
            child: imagePath != null
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(imagePath!, fit: BoxFit.contain),
                  )
                : Icon(
                    icon,
                    // size: 18,
                    size: MediaQuery.of(context).size.width * 0.045,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
          ),
          // const SizedBox(height: 4),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                // fontSize: 11.sp,
                fontSize: MediaQuery.of(context).size.width * 0.028,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
