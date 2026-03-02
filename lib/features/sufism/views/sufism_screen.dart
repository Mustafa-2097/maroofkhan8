import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/sufism/controller/sufism_controller.dart';
import '../../Islam_meditation/controller/meditation_controller.dart';
import '../../Islam_meditation/model/meditation_model.dart';
import '../../Islam_meditation/views/islam_meditation_screen.dart';
import '../../ahle_bait/views/ahle_bait_screen.dart';
import '../../allah_names/views/allah_names.dart';
import '../../home/awliya_allah/awliya_allah_list_screen.dart';
import '../../islamic_books/views/islamic_books_screen.dart';
import '../../sahaba/views/sahaba_screen.dart';
import '../../salawat/views/salawat_screen.dart';
import '../../home/dhikr/dhikr_screen.dart';

// --- CONSTANTS & THEME ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);
const Color kBackground = Color(0xFFFDFDFD);

// ==========================================
// SCREEN 1: SUFISM HOME
// ==========================================
class SufismHomeScreen extends StatelessWidget {
  final bool hideBack;
  const SufismHomeScreen({super.key, this.hideBack = false});

  @override
  Widget build(BuildContext context) {
    Get.put(MeditationController());
    final sufismController = Get.put(SufismController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            children: [
              const HeaderSection(title: "Sufism"),
              Center(
                child: Text(
                  "Daily Wisdom & Meditation",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.whiteColor : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Search
              // Search
              CustomSearchBar(
                onChanged: (val) => sufismController.searchQuery.value = val,
              ),
              const SizedBox(height: 20),

              // Quote Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "مَنْ عَرَفَ نَفْسَهُ عَرَفَ رَبَّهُ",
                      style: GoogleFonts.amiri(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Man ‘arafa nafsahu ‘arafa rabbahu.",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Whoever knows himself knows his Lord.\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: kTextGrey),
                    ),
                    const SizedBox(height: 10),
                    const HeaderDecorationMini(label: "Ibn Arabi"),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // 3. Explore more Section
              Row(
                children: [
                  Icon(Icons.explore_outlined, color: primaryColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "Explore",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const ExploreMoreGrid(),

              const SizedBox(height: 25),

              // Guided Meditation List
              Text(
                "Guided Meditation",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Obx(() {
                if (sufismController.filteredMeditationList.isEmpty) {
                  return const Center(child: Text("No records found"));
                }
                return Column(
                  children: sufismController.filteredMeditationList
                      .take(5) // Limit to 5 items on home
                      .map(
                        (med) => _meditationTile(
                          context,
                          med.title ?? "Untitled",
                          med.subtitle ?? "",
                          medData: med,
                        ),
                      )
                      .toList(),
                );
              }),

              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Get.to(() => const MainMenuScreen()),
                child: const Center(
                  child: Text(
                    "See more",
                    style: TextStyle(
                      color: kPrimaryBrown,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Teaching Section
              Text(
                "Teaching",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _teachingCard(
                            context,
                            "Spiritual Teaches",
                            'https://images.unsplash.com/photo-1542358827-046645367332?auto=format&fit=crop&q=80&w=200',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _teachingCard(
                            context,
                            "Poem of love",
                            'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?auto=format&fit=crop&q=80&w=200',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryBrown,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "More",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward,
                            size: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meditationTile(
    BuildContext context,
    String title,
    String sub, {
    MeditationData? medData,
  }) {
    return GestureDetector(
      onTap: () {
        if (medData != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MeditationPlayerScreen(meditation: medData),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: kPrimaryBrown,
              child: Icon(Icons.donut_large, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(fontSize: 10, color: kTextGrey),
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 12,
              backgroundColor: kPrimaryBrown,
              child: Icon(Icons.chevron_right, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _teachingCard(BuildContext context, String title, String imgUrl) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const IslamicTeachersScreen()),
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(imgUrl)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 12, color: kTextGrey)),
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 2: ISLAMIC TEACHERS LIST
// ==========================================
class IslamicTeachersScreen extends StatelessWidget {
  const IslamicTeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sufismController = SufismController.instance;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const HeaderSection(title: "Islamic Teachers"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Simple Border Search
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  onChanged: (val) =>
                      sufismController.teacherSearchQuery.value = val,
                  decoration: const InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // List
              Expanded(
                child: Obx(() {
                  if (sufismController.filteredTeacherList.isEmpty) {
                    return const Center(child: Text("No teachers found"));
                  }
                  return ListView.builder(
                    itemCount: sufismController.filteredTeacherList.length,
                    itemBuilder: (context, index) {
                      final teacher =
                          sufismController.filteredTeacherList[index];
                      return _teacherCard(
                        context,
                        teacher['name']!,
                        teacher['img']!,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teacherCard(BuildContext context, String name, String imgUrl) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TeachingDetailsScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 28, backgroundImage: NetworkImage(imgUrl)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.playfairDisplay(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Sufi Scholar + Baghdad",
                    style: TextStyle(fontSize: 10, color: kTextGrey),
                  ),
                ],
              ),
            ),
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: kPrimaryBrown,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 3: TEACHING DETAILS
// ==========================================
class TeachingDetailsScreen extends StatelessWidget {
  const TeachingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1542358827-046645367332?auto=format&fit=crop&q=80&w=300",
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Spiritual Teaches",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "المُرْشِدُونَ الرُّوحِيُّونَ",
                style: GoogleFonts.amiri(fontSize: 16, color: kTextGrey),
              ),
              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "His Teaching",
                  style: GoogleFonts.playfairDisplay(fontSize: 18),
                ),
              ),
              const SizedBox(height: 15),

              _teachingContentCard(),
              _teachingContentCard(),
              _teachingContentCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teachingContentCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Inner Purification (Tazkiyah al-Nafs)",
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "A central theme in his teachings was the cleansing of the heart from spiritual maladies such as pride, envy, greed, and heedlessness. He taught that true spirituality begins with...",
            style: TextStyle(fontSize: 12, color: kTextGrey, height: 1.5),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kPrimaryBrown,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Read More",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SHARED HELPER WIDGETS ---

class HeaderWithLines extends StatelessWidget {
  final String title;
  const HeaderWithLines({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.circle, size: 4, color: kPrimaryBrown),
        Container(width: 40, height: 1, color: Colors.grey.shade300),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Container(width: 40, height: 1, color: Colors.grey.shade300),
        const Icon(Icons.circle, size: 4, color: kPrimaryBrown),
      ],
    );
  }
}

class HeaderDecorationMini extends StatelessWidget {
  final String label;
  const HeaderDecorationMini({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 20, height: 1, color: kPrimaryBrown),
        const SizedBox(width: 5),
        const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 5),
        const Icon(Icons.circle, size: 3, color: kPrimaryBrown),
        const SizedBox(width: 5),
        Container(width: 20, height: 1, color: kPrimaryBrown),
      ],
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const CustomSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E120D) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.stroke),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
          hintText: "Search...",
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 8),
        ),
      ),
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
      crossAxisSpacing: 8,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => AhleBaitListScreen());
          },
          child: _GridCard(
            title: "Ahle Bait",
            icon: Icons.diversity_3,
            color: isDark
                ? Colors.green.withOpacity(0.15)
                : const Color(0xFFE6F5D8),
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
            color: isDark
                ? primaryColor.withOpacity(0.1)
                : const Color(0xFFE0D9FA),
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
            color: isDark
                ? Colors.orange.withOpacity(0.15)
                : const Color(0xFFFFD6CA),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => DhikrListScreen());
          },
          child: _GridCard(
            title: "Dhikr",
            icon: Icons.search,
            color: isDark
                ? Colors.pink.withOpacity(0.15)
                : const Color(0xFFE94E77),
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
            color: isDark
                ? Colors.green.withOpacity(0.15)
                : const Color(0xFFE6F5D8),
            isDark: isDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => const MainMenuScreen());
          },
          child: _GridCard(
            title: "Islaah &\nMeditation",
            icon: Icons.self_improvement,
            color: isDark
                ? primaryColor.withOpacity(0.1)
                : const Color(0xFFE0D9FA),
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
            color: isDark
                ? Colors.orange.withOpacity(0.15)
                : const Color(0xFFFFD6CA),
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
            color: isDark
                ? Colors.pink.withOpacity(0.15)
                : const Color(0xFFE94E77),
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
          const SizedBox(height: 2),
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
