import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Placeholder imports for navigation - keep or remove as needed
import 'package:maroofkhan8/features/hadis/views/hadis_screen.dart';
import 'package:maroofkhan8/features/quran/views/quran_screen.dart';
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
    return Scaffold(
      drawer: const CustomAppDrawer(),
      // Gradient Background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFC4B8EB), // Top Lilac
              Color(0xFFD6D1F5), // Mid
              Color(0xFFEBE6F8), // Bottom Light
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
                const SizedBox(height: 10),
                HeroSection(),

                // 1. Your Journey Section
                const SectionHeader(title: "Your Journey"),
                const SizedBox(height: 15),
                const YourJourneyRow(),

                const SizedBox(height: 25),

                // 2. Quick Start Section
                const SectionHeader(title: "Quick Start"),
                const SizedBox(height: 15),
                const QuickStartGrid(),

                const SizedBox(height: 25),

                // 3. Explore more Section
                Row(
                  children: [
                    const Icon(Icons.explore_outlined, color: Color(0xFF8B4513), size: 24), // Brownish compass
                    const SizedBox(width: 8),
                    Text(
                      "Explore more",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w500, // Slightly thinner than bold
                        color: const Color(0xFF3B2A50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const ExploreMoreGrid(),

                const SizedBox(height: 30),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: const Icon(
                  Icons.menu_rounded,
                  color: Color(0xFF3B2A50),
                  size: 26,
                ),
              ),
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/user_placeholder.png'),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Greeting
          Text(
            "Assalamu Alaikum",
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              color: const Color(0xFF6D5A8E),
            ),
          ),

          const SizedBox(height: 4),

          /// Main message
          Text(
            "May your heart find peace today",
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3B2A50),
              height: 1.3,
            ),
          ),

          const SizedBox(height: 10),

          /// Search bar
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: TextDecoration.none is InputDecoration
                        ? const InputDecoration()
                        : const InputDecoration(
                      hintText: "Search Quran, Duas, Names…",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  // Controller to handle page snapping
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentIndex = 0;

  // Mock Data for the Slider
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
    return Column(
      children: [
        // 1. The Slider
        SizedBox(
          height: 260, // Height of the card area
          child: PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildSlideCard(_slides[index]);
            },
          ),
        ),

        const SizedBox(height: 10),

        // 2. The Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? const Color(0xFF7B66FF) : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSlideCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5), // Spacing between cards
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(data['image']),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5)
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.7)
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
                    color: Colors.blue.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Text(
                    data['title'],
                    style: const TextStyle(color: Colors.white, fontSize: 10)
                ),
              ),
            ),

            // Icons (Top Right)
            const Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_border, color: Colors.white),
                  SizedBox(width: 10),
                  Icon(Icons.download_outlined, color: Colors.white),
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
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  Text(
                      data['nameAr'],
                      style: const TextStyle(color: Colors.white70, fontSize: 14)
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data['quoteEn'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 20, // Slightly adjusted for multi-line safety
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      data['quoteAr'],
                      style: const TextStyle(color: Colors.white70, fontSize: 16)
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
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time, color: Colors.white, size: 14),
                        const SizedBox(width: 5),
                        Text(
                            data['time'],
                            style: const TextStyle(color: Colors.white, fontSize: 12)
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
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
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 22,
        color: const Color(0xFF3B2A50),
      ),
    );
  }
}

class YourJourneyRow extends StatelessWidget {
  const YourJourneyRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1: 5 Day Streak (Purple)
        Expanded(
          child: _JourneyCard(
            topText: "5",
            bottomText: "Day\nStreak",
            color: const Color(0xFFDCD6FF), // Light Purple
            icon: Icons.local_fire_department,
          ),
        ),
        const SizedBox(width: 8),

        // Card 2: 1 Surah (Peach)
        Expanded(
          child: _JourneyCard(
            topText: "1",
            bottomText: "Surah",
            color: const Color(0xFFFFD6CA), // Peach
            icon: Icons.menu_book,
          ),
        ),
        const SizedBox(width: 8),

        // Card 3: 2h 15 min Surah (Green)
        Expanded(
          child: _JourneyCard(
            topText: "2h 15\nmin",
            bottomText: "Surah",
            color: const Color(0xFFE6F5D8), // Light Green
            icon: Icons.schedule,
          ),
        ),
        const SizedBox(width: 8),

        // Card 4: 8 Saved (Pink)
        Expanded(
          child: _JourneyCard(
            topText: "8",
            bottomText: "Saved",
            color: const Color(0xFFE94E77), // Dark Pink
            icon: Icons.bookmark_border,
            isPinkCard: true,
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

  const _JourneyCard({
    required this.topText,
    required this.bottomText,
    required this.color,
    required this.icon,
    this.isPinkCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // ↓ reduced
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,
            child: Icon(icon, size: 16, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            topText,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            bottomText,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 11,
              height: 1.1,
              color: Colors.black54,
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
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.85,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        GestureDetector(
            onTap: (){
              Get.to(AwliyaAllahListScreen());
            },
            child: _GridCard(title: "Awliya\nAllah", icon: Icons.nightlight_round, color: const Color(0xFFE6F5D8))),
        GestureDetector(
            onTap: (){
              Get.to(QuranScreen());
            },
            child: _GridCard(title: "Quran", icon: Icons.menu_book, color: const Color(0xFFDCD6FF))),
        GestureDetector(
            onTap: (){
              Get.to(HadithScreen());
            },
            child: _GridCard(title: "Hadith", icon: Icons.book, color: const Color(0xFFFFD6CA))),
        GestureDetector(
            onTap: (){
              Get.to(SufismHomeScreen());
            },
            child: _GridCard(title: "Sufism", icon: Icons.mosque, color: const Color(0xFFE94E77), isPinkCard: true)),
        GestureDetector(
            onTap: (){
              Get.to(TasbihListScreen());
            },
            child: _GridCard(title: "Tasbih", icon: Icons.search, color: const Color(0xFFFFE0CA))),
        GestureDetector(
            onTap: (){
              Get.to(NamesOfAllahScreen());
            },
            child: _GridCard(title: "99\nNames", icon: Icons.verified_outlined, color: const Color(0xFFE0D9FA))),
      ],
    );
  }
}

class ExploreMoreGrid extends StatelessWidget {
  const ExploreMoreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.85, // ↓ less tall
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        // Row 1
        GestureDetector(
            onTap: (){
              Get.to(SahabaListScreen());
            },
            child: _GridCard(title: "Sahaba", icon: Icons.groups, color: const Color(0xFFFFD6CA), fontSize: 11)),
        GestureDetector(
            onTap: (){
              // Get.to(AwliyaAllahListScreen());
            },
            child: _GridCard(title: "Quaranic\nStories", icon: Icons.auto_stories, color: const Color(0xFFDCD6FF), fontSize: 10)), // Note: "Quaranic" spelling in image
        GestureDetector(
            onTap: (){
              Get.to(AhleBaitListScreen());
            },
            child: _GridCard(title: "Ahle Bait", icon: Icons.diversity_3, color: const Color(0xFFE6F5D8), fontSize: 11)),
        GestureDetector(
            onTap: (){
              Get.to(IslamicBooksListScreen());
            },
            child: _GridCard(title: "Islamic\nBooks", icon: Icons.diversity_2, color: const Color(0xFFE94E77), isPinkCard: true, fontSize: 10)),

        // Row 2
        GestureDetector(
            onTap: (){
              Get.to(PrayerTrackerScreen());
            },
            child: _GridCard(title: "-Islamic\ncalandar", icon: Icons.calendar_month_outlined, color: const Color(0xFFE6F5D8), fontSize: 10)), // Note: Hyphen and "calandar" spelling
        GestureDetector(
          onTap: (){
            Get.to(ZakatCalculator());
          },
            child: _GridCard(title: "Zakat\nCalculator", icon: Icons.savings_outlined, color: const Color(0xFFE94E77), isPinkCard: true, textColor: Colors.white, fontSize: 10)),
        GestureDetector(
            onTap: (){
              Get.to(SalawatListScreen());
            },
            child: _GridCard(title: "Salawat", icon: Icons.handshake_outlined, color: const Color(0xFFFFD6CA), fontSize: 11)),
        GestureDetector(
            onTap: (){
              Get.to(PrayerTrackerScreenn());
            },
            child: _GridCard(title: "Prayer\ntracker", icon: Icons.gps_fixed, color: const Color(0xFFE0D9FA), fontSize: 10)),

        // Row 3 (Partial)
        GestureDetector(
            onTap: (){
              Get.to(IslaahApp());
            },
            child: _GridCard(title: "Islaah &\nMeditation", icon: Icons.self_improvement, color: const Color(0xFFE0D9FA), fontSize: 9)),
        GestureDetector(
            onTap: (){
              Get.to(DuaApp());
            },
            child: _GridCard(title: "Dua", icon: Icons.front_hand, color: const Color(0xFFFFD6CA), fontSize: 11)),
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
  final double fontSize;

  const _GridCard({
    required this.title,
    required this.icon,
    required this.color,
    this.isPinkCard = false,
    this.textColor,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16, // ↓ smaller
            backgroundColor: Colors.white,
            child: Icon(icon, size: 18, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
