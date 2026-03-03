import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFF8F9FB);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class AssetsIncludedScreen extends StatelessWidget {
  const AssetsIncludedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
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
            // 1. Top Card: Assets Included in Zakat
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
                      Icons.savings_outlined,
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
                          "Assets Included in Zakat",
                          style: GoogleFonts.ebGaramond(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kTextDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "What types of wealth are subject to Zakat",
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
                  Text(
                    "The following assets are included when calculating Zakat:",
                    style: GoogleFonts.ebGaramond(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _checkListItem("Cash in hand and in bank accounts"),
                  _checkListItem("Gold and silver (jewelry, coins, bars)"),
                  _checkListItem("Stocks, shares, and investment certificates"),
                  _checkListItem("Business inventory and merchandise"),
                  _checkListItem(
                    "Money lent to others (expected to be returned)",
                  ),
                  _checkListItem("Retirement funds (if accessible)"),
                  _checkListItem(
                    "Agricultural produce (with different percentage)",
                  ),
                  _checkListItem("Livestock (with specific conditions)"),

                  const SizedBox(height: 24),
                  _bulletItem(
                    "Personal items like your home, car, clothing, and furniture are NOT subject to Zakat.",
                  ),
                  _bulletItem(
                    "Gold/silver jewelry regularly worn by women has a difference of opinion—consult a scholar.",
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

  Widget _checkListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: kPrimaryBrown,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.ebGaramond(
                fontSize: 15,
                color: kTextDark,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(Icons.circle, color: kTextDark, size: 4),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.ebGaramond(
                fontSize: 15,
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
