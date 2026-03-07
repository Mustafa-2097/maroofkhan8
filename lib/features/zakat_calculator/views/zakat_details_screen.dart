import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFF3F4F6);
const Color kCardColor = Colors.white;
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF555555);

class ZakatRulesDetailScreen extends StatelessWidget {
  const ZakatRulesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Column(
          children: [
            HeaderSection(title: tr("zakat_calculator_title")),
            Text(
              tr("purify_wealth_sub"),
              style: const TextStyle(fontSize: 10, color: kTextGrey),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: Padding(
      //     padding: const EdgeInsets.all(10.0),
      //     child: GestureDetector(
      //       onTap: () => Navigator.pop(context),
      //       child: Container(
      //         decoration: BoxDecoration(
      //           border: Border.all(color: Colors.grey.shade300),
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //         child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
      //       ),
      //     ),
      //   ),
      //   centerTitle: true,
      //   title: Column(
      //     children: [
      //       Text(
      //         "Zakat",
      //         style: GoogleFonts.playfairDisplay(
      //           color: Colors.black,
      //           fontWeight: FontWeight.bold,
      //           fontSize: 18,
      //         ),
      //       ),
      //       const SizedBox(height: 4),
      //       const Text(
      //         "Purify your wealth with ease and accuracy",
      //         style: TextStyle(fontSize: 10, color: Colors.grey),
      //       ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8D3C1F), // Brown background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.people_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr("who_must_pay_zakat"),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kTextDark,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          tr("who_must_pay_zakat_sub"),
                          style: const TextStyle(
                            fontSize: 12,
                            color: kTextGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Main Content Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr("zakat_conditions_title"),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Checklist Items
                  _checkListItem(tr("cond_adult_sane")),
                  _checkListItem(tr("cond_free")),
                  _checkListItem(tr("cond_nisab")),
                  _checkListItem(localizeDigits(tr("cond_hawl"), context)),
                  _checkListItem(tr("cond_nature")),

                  const SizedBox(height: 15),

                  // Paragraphs
                  Text(
                    tr("exempt_notice"),
                    style: const TextStyle(
                      fontSize: 13,
                      color: kTextDark,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    tr("nisab_reset_notice"),
                    style: const TextStyle(
                      fontSize: 13,
                      color: kTextDark,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Guidance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                // Left Border styling
                border: const Border(
                  left: BorderSide(color: kPrimaryBrown, width: 4),
                  top: BorderSide.none,
                  right: BorderSide.none,
                  bottom: BorderSide.none,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Icon(
                      Icons.menu_book_outlined,
                      color: kTextDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr("need_more_guidance"),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kTextDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr("guidance_desc"),
                          style: const TextStyle(
                            fontSize: 12,
                            color: kTextGrey,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _checkListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
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
              style: const TextStyle(
                fontSize: 13,
                color: kTextDark,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
