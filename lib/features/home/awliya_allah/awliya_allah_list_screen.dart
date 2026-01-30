import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/features/home/awliya_allah/awliya_allah_details_screen.dart';

class AwliyaAllahListScreen extends StatelessWidget {
  const AwliyaAllahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Custom brown color from the design
    const Color primaryBrown = Color(0xFF8D3C1F);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            // 1. Header Title
            Text(
              "Awliya Allah",
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E2E2E),
              ),
            ),
            SizedBox(height: 10),
            // 2. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // 3. Scrollable List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: 10, // Number of items
                itemBuilder: (context, index) {
                  return const AwliyaCard(
                    title: "Shayidh Abdul Qadir\nJilani (RA)",
                    subtitle: "Sufi Scholar + Baghdad",
                    buttonColor: primaryBrown,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AwliyaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color buttonColor;

  const AwliyaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AwliyaAllahDetailsScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3), // vertical shadow
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                'https://i.pinimg.com/736x/8e/9d/23/8e9d23315a6792345e6912389d5f75e7.jpg',
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
