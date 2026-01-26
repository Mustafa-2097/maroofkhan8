import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/features/hadis/views/hadis_screen.dart';

import 'hadith_list_details_screen.dart';

class HadithBookDetailsScreen extends StatelessWidget {
  const HadithBookDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                // 1. Header with Decorative Lines
                const HeaderDecoration(),

                const SizedBox(height: 15),

                // 2. Search Bar & Bookmark
                const SearchBarSection(),

                const SizedBox(height: 10),

                // 3. Grid of Volumes
                // 3. Grid of Volumes
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 25,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HadithListDetailsScreen(),
                            ),
                          );
                        },
                        child: VolumeCard(volumeNumber: index + 1),
                      );
                    },
                  ),
                ),


              ],
            ),

            // // 4. Overlapping Floating Avatar (positioned between search and grid)
            // Positioned(
            //   top: 105,
            //   child: Container(
            //     padding: const EdgeInsets.all(4),
            //     decoration: BoxDecoration(
            //       color: const Color(0xFF2E2E2E),
            //       borderRadius: BorderRadius.circular(30),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.3),
            //           blurRadius: 10,
            //           offset: const Offset(0, 4),
            //         )
            //       ],
            //     ),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         const CircleAvatar(
            //           radius: 18,
            //           backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
            //         ),
            //         const SizedBox(width: 4),
            //         CircleAvatar(
            //           radius: 18,
            //           backgroundColor: Colors.purple.shade400,
            //           child: const Text("S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

          ],
        ),
      ),
    );
  }
}

class HeaderDecoration extends StatelessWidget {
  const HeaderDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
          ),
          const Expanded(child: Divider(indent: 10, endIndent: 10, color: Colors.grey, thickness: 0.5)),
          const Icon(Icons.circle, size: 4, color: Color(0xFF8D3C1F)),
          const SizedBox(width: 8),
          Text(
            "Sahih al-Bukhari",
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E2E2E),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.circle, size: 4, color: Color(0xFF8D3C1F)),
          const Expanded(child: Divider(indent: 10, endIndent: 10, color: Colors.grey, thickness: 0.5)),
          const SizedBox(width: 30), // Balancing for back button
        ],
      ),
    );
  }
}

class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class VolumeCard extends StatelessWidget {
  final int volumeNumber;
  const VolumeCard({super.key, required this.volumeNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFBD4A41), // Reddish
            Color(0xFF5D2D49), // Dark Purple/Red
          ],
        ),
        boxShadow: [
          // Blueish Outer Glow as seen in design
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Book Shape Pattern
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.menu_book_rounded, size: 100, color: Colors.white),
            ),
          ),
          // Text Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "سورة",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Volume $volumeNumber",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Small Arrow Button
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF6B2613),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_right, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}