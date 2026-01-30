import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/app_colors.dart';

class AwliyaAllahDetailsScreen extends StatefulWidget {
  const AwliyaAllahDetailsScreen({super.key});

  @override
  State<AwliyaAllahDetailsScreen> createState() => _AwliyaAllahDetailsScreenState();
}

class _AwliyaAllahDetailsScreenState extends State<AwliyaAllahDetailsScreen> {
  final Color primaryBrown = const Color(0xFF8D3C1F);

  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 2. Back Button
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
                  ),
                ),
              ),

              // 3. Profile Image
              const SizedBox(height: 10),
              const Center(
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: NetworkImage('https://i.pinimg.com/736x/8e/9d/23/8e9d23315a6792345e6912389d5f75e7.jpg'),
                ),
              ),

              // 4. Names
              const SizedBox(height: 20),
              Text(
                "Zulfiqar Ahmad Naqsh-bandi",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E2E2E),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "ذو الفقار أحمد النقشبندي",
                style: GoogleFonts.amiri(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              // 5. Tabs Row
              // 5. Tabs Row
              const SizedBox(height: 25),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _tabButton("Biography", 0),
                    _tabButton("Teachings", 1),
                    _tabButton("Karamat", 2),
                    _tabButton("Quotes", 3),
                  ],
                ),
              ),


              // 6. Section Title
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _getTabTitle(),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    color: const Color(0xFF2E2E2E),
                  ),
                ),
              ),

              // ... after Section Title ...
              const SizedBox(height: 15),

              _buildTabBody(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }


// Update the title getter to match the screenshot labels
  String _getTabTitle() {
    switch (selectedTabIndex) {
      case 1:
        return "His Teaching";
      case 2:
        return "Verified Karamat";
      case 3:
        return "His Quotes";
      default:
        return "Biography";
    }
  }

  // Refined Tab Body Switcher
  Widget _buildTabBody() {
    switch (selectedTabIndex) {
      case 1:
        return _teachingsTab();
      case 2:
        return _karamatTab();
      case 3:
        return _quotesTab();
      default:
        return _biographyTab();
    }
  }
  // 1. Biography TAB
  Widget _biographyTab() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          _infoRow("Name :", "Zulfiqar Ahmad Naqshbandi"),
          _infoRow("Born :", "1 April 1953, Jhang, Pakistan"),
          _infoRow("Passed away :", "14 December 2025"),
          _infoRow("Position :", "Islamic Scholar & Sufi Shaykh of the Naqshbandi-Mujaddidi Order"),
          _infoRow("Institution :", "Jamia Mahad-ul-Faqeer Al-Islami"),
          _infoRow("Works :", "Over 100 books on spirituality, ethics, and Islam"),
          _infoRow("Known For :", "Spiritual purification, inner reform, ethical guidance"),
        ],
      ),
    );
  }

  // 2. TEACHINGS TAB (List of Cards)
  Widget _teachingsTab() {
    return Column(
      children: List.generate(4, (index) => _actionCard(
        "Inner Purification (Tazkiyah al-Nafs)",
        "A central theme in his teachings was the cleansing of the heart from spiritual maladies such as pride, envy, greed, and heedlessness. He taught that true spirituality begins with self-reflection, repentance, and sincerity in worship",
      )),
    );
  }

  // 3. KARAMAT TAB (Summary Card + List)
  Widget _karamatTab() {
    return Column(
      children: [
        // Top Summary Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text("Key Teachings & Guidance", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("1. Love & Service to Humanity\n2. Zikr & Contemplation\n3. Inner Purification (Tazkiya al-Nafs)", textAlign: TextAlign.start, style: TextStyle(fontSize: 12, height: 1.5)),
              const SizedBox(height: 15),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFF5E6E0),
                child: Text("Dargah\nVisuals", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
              )
            ],
          ),
        ),
        _actionCard("Healing through Barakah", "People reported feeling relief from physical ailments after sincere prayer and blessings (barakah) associated with his guidance."),
        _actionCard("Blessed Increase in Provision", "Some followers noted unexpected provision and ease in sustenance when implementing teachings of sincere dhikr and trust in Allah."),
      ],
    );
  }

  // 4. QUOTES TAB (Italicized Text)
  Widget _quotesTab() {
    return Column(
      children: [
        _actionCard(
          "On Remembrance of Allah",
          "Let your heart constantly call out Allah, Allah, Allah in every moment of your daily life—walking, sitting, or working—so that your hands act while your heart remembers Him.\n(Inspired by his guidance on Dhikr practices)",
          isQuote: true,
        ),
        _actionCard(
          "On Muraqabah (Heart-Reflection)",
          "When you sit in stillness and look into your own heart, you patiently await Allah's mercy—this inner watchfulness brings peace to the mind and soul.\n(Based on his instruction on muraqabah meditation)",
          isQuote: true,
        ),
      ],
    );
  }

  // HELPER: The White Card with Brown "Read More" Button
  Widget _actionCard(String title, String body, {bool isQuote = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.playfairDisplay(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
              fontStyle: isQuote ? FontStyle.italic : FontStyle.normal,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: primaryBrown, borderRadius: BorderRadius.circular(15)),
              child: const Text("Read More", style: TextStyle(color: Colors.white, fontSize: 10)),
            ),
          )
        ],
      ),
    );
  }




  Widget _tabButton(String label, int index) {
    final bool isSelected = selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryBrown : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (!isSelected)
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}