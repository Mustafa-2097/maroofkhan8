import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'hadith_book_details_screen.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  int _selectedIndex = 0;
  final Color primaryBrown = const Color(0xFF8D3C1F);
  final Color darkBlack = const Color(0xFF1E120D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // 1. Custom Decorated Header
            const HeaderDecoration(),

            const SizedBox(height: 15),

            // 2. Search & Bookmark Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Icon(Icons.bookmark_outline, color: Colors.grey.shade300),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 3. Pill Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _tabButton("Hadith Book", 0),
                  const SizedBox(width: 8),
                  _tabButton("Popular Hadith", 1),
                  const SizedBox(width: 8),
                  _tabButton("Last Read", 2, icon: Icons.access_time),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 4. Content List
            Expanded(
              child: _selectedIndex == 0 ? _buildBookList() : _buildHadithList(),
            ),
          ],
        ),
      ),
    );
  }

  // Book List for Screen 1
  Widget _buildBookList() {
    final List<String> books = [
      "Sahih al-Bukhari",
      "Sahih Muslim",
      "Sunan Abu Dawood",
      "Jami' at-Tirmidhi",
      "Sunan an-Nasa'i"
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Get.to(HadithBookDetailsScreen());
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                // Dummy Book Image
                Container(
                  width: 45,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.menu_book, color: Colors.amber, size: 20),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    books[index],
                    style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: primaryBrown, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Hadith Detail List for Screen 2 & 3
  Widget _buildHadithList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  "إن الله لا ينظر إلى صوركم وأموالكم، ولكن ينظر إلى قلوبكم وأعمالكم",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '"Allah looks not at your appearance or wealth, but at your hearts and actions."',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Text("— Sahih Muslim", style: TextStyle(color: primaryBrown, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 30),
              Row(
                children: [
                  const Icon(Icons.favorite_border, size: 18, color: Colors.grey),
                  const SizedBox(width: 15),
                  const Icon(Icons.share_outlined, size: 18, color: Colors.grey),
                  const Spacer(),
                  _iconLabel(Icons.volume_up_outlined, "Listen"),
                  const SizedBox(width: 15),
                  _iconLabel(Icons.visibility_outlined, "Full View"),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _iconLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _tabButton(String text, int index, {IconData? icon}) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? (index == 2 ? primaryBrown : darkBlack) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.black), const SizedBox(width: 5)],
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderDecoration extends StatelessWidget {
  const HeaderDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFF8D3C1F);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
          const SizedBox(width: 10),
          const Icon(Icons.circle, size: 4, color: brown),
          const SizedBox(width: 10),
          Text(
            "Hadith",
            style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.circle, size: 4, color: brown),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        ],
      ),
    );
  }
}