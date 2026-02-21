import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'features/ai_murshid/views/ai_murshid_screen.dart';
import 'features/hadis/views/hadis_screen.dart';
import 'features/home/views/dashboard_screen.dart';
import 'features/prayer/views/prayer_screen.dart';
import 'features/quran/views/quran_screen.dart';

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
    QuranScreen(),
    HadithScreen(),
    SufismHomeScreen(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
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
                } else if (direction == ScrollDirection.forward && !_isNavbarVisible) {
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
            left: 20,
            right: 20,
            bottom: keyboardOpen
                ? -100
                : (_isNavbarVisible ? 25 : -100),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    label: "Home",
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.auto_awesome_outlined,
                    label: "Al Murshid",
                    index: 1,
                  ),
                  _buildNavItem(
                    icon: Icons.menu_book_outlined,
                    label: "Hadith",
                    index: 2,
                  ),
                  _buildNavItem(
                    icon: Icons.import_contacts, // Quran Icon
                    label: "Quran",
                    index: 3,
                  ),
                  _buildNavItem(
                    icon: Icons.man_outlined,
                    label: "Sufism",
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

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => changeIndex(index),
        behavior: HitTestBehavior.opaque,
        child: Obx(() {
          final isSelected = currentIndex.value == index;
          final Color color = isSelected ? primaryBrown : Colors.grey.shade400;

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              // Fixed the error line below
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 4), // Corrected this line
                  height: 4,
                  width: 4,
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