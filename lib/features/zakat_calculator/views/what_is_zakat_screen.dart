import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFF8F9FB);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class ZakatWhatIsScreen extends StatelessWidget {
  const ZakatWhatIsScreen({super.key});

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
        title: Column(
          children: [
            Text(
              "Zakat",
              style: GoogleFonts.ebGaramond(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "Purify your wealth with ease and accuracy",
              style: GoogleFonts.ebGaramond(fontSize: 12, color: kTextGrey),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // 1. Top Card: What is Zakat?
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: kPrimaryBrown,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What is Zakat?",
                          style: GoogleFonts.ebGaramond(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kTextDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Learn the fundamental meaning and importance of Zakat",
                          style: GoogleFonts.ebGaramond(
                            fontSize: 13,
                            color: kTextGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Main content Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _contentParagraph(
                    "Zakat is one of the Five Pillars of Islam, making it an obligatory act of worship.",
                  ),
                  _contentParagraph(
                    "The word \"Zakat\" means purification and growth. It purifies your wealth and helps it grow in blessings.",
                  ),
                  _contentParagraph(
                    "Zakat is 2.5% of your accumulated wealth that has been in your possession for one lunar year (Hawl).",
                  ),
                  _contentParagraph(
                    "It is a form of charity ordained by Allah to help the poor and needy in the community.",
                  ),
                  _contentParagraph(
                    "Paying Zakat is not just giving away money—it is fulfilling a divine obligation and ensuring social justice.",
                  ),
                  Text(
                    "Allah says in the Quran: \"Take from their wealth a charity to cleanse them and purify them.\" (9:103)",
                    style: GoogleFonts.ebGaramond(
                      fontSize: 15,
                      color: kTextDark,
                      height: 1.5,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Need More Guidance Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: const Border(
                  left: BorderSide(color: kPrimaryBrown, width: 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Icon(
                      Icons.menu_book_outlined,
                      color: kTextDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Need More Guidance?",
                          style: GoogleFonts.ebGaramond(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kTextDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "For specific questions about your situation, consult with a knowledgeable Islamic scholar or imam in your community. They can provide personalized guidance based on authentic sources.",
                          style: GoogleFonts.ebGaramond(
                            fontSize: 13,
                            color: kTextGrey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        text,
        style: GoogleFonts.ebGaramond(
          fontSize: 15,
          color: kTextDark,
          height: 1.5,
        ),
      ),
    );
  }
}
