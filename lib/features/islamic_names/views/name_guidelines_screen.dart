import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFFBFBFD);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class NameGuidelinesScreen extends StatelessWidget {
  const NameGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Islamic Name",
          style: GoogleFonts.ebGaramond(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Title Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "Islamic Guidelines for Choosing a Name",
                textAlign: TextAlign.center,
                style: GoogleFonts.ebGaramond(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Content Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _paragraph(
                    "Islam provides clear guidance when choosing a name for a child. Parents are encouraged to select names that have good and positive meanings, as names reflect a person's identity and character.",
                  ),
                  const SizedBox(height: 12),
                  _paragraph("Islamic guidelines for naming include:"),
                  const SizedBox(height: 8),
                  _bulletPoint("Choosing names with good and noble meanings"),
                  _bulletPoint(
                    "Avoiding names with bad, offensive, or negative meanings",
                  ),
                  _bulletPoint(
                    "Avoiding names that imply shirk (associating partners with Allah)",
                  ),
                  _bulletPoint(
                    "Preferring names of Prophets, companions, pious people, and righteous women",
                  ),
                  _bulletPoint(
                    "Choosing names that are easy to pronounce and respectful",
                  ),
                  const SizedBox(height: 16),
                  _paragraph(
                    "The Prophet Muhammad (ﷺ) encouraged giving good names and sometimes changed names that had bad meanings. Therefore, selecting a beautiful and meaningful name is part of Islamic etiquette and a responsibility of parents.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Text(
      text,
      style: GoogleFonts.ebGaramond(
        fontSize: 16,
        color: kTextDark,
        height: 1.4,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(
              fontSize: 16,
              color: kTextDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.ebGaramond(
                fontSize: 16,
                color: kTextDark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
