import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFFBFBFD);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class NameImportanceScreen extends StatelessWidget {
  const NameImportanceScreen({super.key});

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
                "The Importance of Giving a Beautiful\nName to a Child in Islam",
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
                    "In Islam, giving a child a beautiful and meaningful name is very important. A name carries identity, dignity, and has an influence on a person’s character and personality. Islam encourages parents to choose names with good meanings, as a person will be called by their name in this world and in the Hereafter.",
                  ),
                  const SizedBox(height: 16),
                  _paragraph(
                    "The Prophet Muhammad (ﷺ) emphasized choosing good names and discouraged names with bad or negative meanings. A good name reflects faith, good character, and a positive identity. Therefore, parents should select names that have pleasant meanings, are easy to pronounce, and are aligned with Islamic values.",
                  ),
                  const SizedBox(height: 16),
                  _paragraph(
                    "Giving a child a beautiful name is not only a parental responsibility but also a Sunnah, and it is considered a way of making du‘a (supplication) for the child’s good future.",
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
}
