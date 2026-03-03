import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFF8F9FB);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class WhoCannotReceiveZakatScreen extends StatelessWidget {
  const WhoCannotReceiveZakatScreen({super.key});

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
            const SizedBox(height: 2),
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
            // 1. Top Card: Who Can't Receive Zakat?
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
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
                      Icons.cancel_outlined,
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
                          "Who Can't Receive Zakat?",
                          style: GoogleFonts.ebGaramond(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kTextDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "People who are not eligible for Zakat",
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
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "The following people cannot receive Zakat:",
                    style: GoogleFonts.ebGaramond(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _ineligibleItem(
                    "Your immediate family: parents, grandparents, children, grandchildren, spouse",
                  ),
                  _ineligibleItem(
                    "The wealthy or those who possess wealth above Nisab",
                  ),
                  _ineligibleItem(
                    "Non-Muslims (except those whose hearts are being reconciled to Islam)",
                  ),
                  _ineligibleItem(
                    "Descendants of the Prophet Muhammad (ﷺ) - they are prohibited from accepting Zakat",
                  ),
                  _ineligibleItem(
                    "People who are physically capable of earning but choose not to work",
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "However, extended family like cousins, aunts, uncles, nephews, and nieces CAN receive Zakat if they meet the criteria.\n\nGiving Zakat to eligible relatives is actually more rewarding as it combines charity and maintaining family ties.\n\nAlways verify the recipient's eligibility or give through trusted Islamic organizations.",
                    style: GoogleFonts.ebGaramond(
                      fontSize: 15,
                      color: kTextDark,
                      height: 1.5,
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
                    color: Colors.black.withValues(alpha: 0.02),
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

  Widget _ineligibleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
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
}
