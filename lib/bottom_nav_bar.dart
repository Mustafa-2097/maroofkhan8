import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'features/ai_murshid/views/ai_murshid_screen.dart';
import 'features/hadis/views/hadis_screen.dart';
import 'features/home/views/dashboard_screen.dart';
import 'features/prayer/views/prayer_screen.dart';
import 'features/quran/views/quran_screen.dart';
import 'features/sufism/views/sufism_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _UserNavBarState();
}

class _UserNavBarState extends State<CustomBottomNavBar> {
  bool _isNavbarVisible = true;
  var currentIndex = 0.obs;

  // The Exact Color from the Design
  final Color primaryBrown = const Color(0xFF8D3C1F);

  final List<Widget> pages = [
    DashboardScreen(),
    ChatScreen(),
    QuranScreen(hideBack: true),
    HadithScreen(hideBack: true),
    SufismHomeScreen(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    context.locale; // Register dependency
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (currentIndex.value == 1) return false; // Don't hide in Chat

              if (notification is UserScrollNotification) {
                final direction = notification.direction;
                if (direction == ScrollDirection.reverse && _isNavbarVisible) {
                  setState(() => _isNavbarVisible = false);
                } else if (direction == ScrollDirection.forward &&
                    !_isNavbarVisible) {
                  setState(() => _isNavbarVisible = true);
                }
              }
              return false;
            },
            child: Obx(() => pages[currentIndex.value]),
          ),

          // --- FIXED NAV DESIGN ---
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            left: sw * 0.05,
            right: sw * 0.05,
            bottom: keyboardOpen
                ? -sh * 0.15
                : (_isNavbarVisible ? sh * 0.03 : -sh * 0.15),
            child: Container(
              height: sh * 0.08,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(sw * 0.05),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.home_outlined,
                    labelKey: "nav_home",
                    index: 0,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.auto_awesome_outlined,
                    labelKey: "nav_al_murshid",
                    index: 1,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.menu_book_outlined,
                    labelKey: "nav_quran",
                    index: 2,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.import_contacts, // Quran Icon
                    labelKey: "nav_hadith",
                    index: 3,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.man_outlined,
                    labelKey: "nav_sufism",
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String labelKey,
    required int index,
  }) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => changeIndex(index),
        behavior: HitTestBehavior.opaque,
        child: Obx(() {
          final isSelected = currentIndex.value == index;
          final Color color = isSelected
              ? primaryBrown
              : (isDark ? Colors.white38 : Colors.grey.shade400);

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: sw * 0.065),
              SizedBox(height: sw * 0.01),
              Text(
                tr(labelKey),
                style: TextStyle(
                  color: color,
                  fontSize: sw * 0.025,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              // Indicator Dot
              if (isSelected)
                Container(
                  margin: EdgeInsets.only(top: sw * 0.01),
                  height: sw * 0.01,
                  width: sw * 0.01,
                  decoration: BoxDecoration(
                    color: primaryBrown,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
