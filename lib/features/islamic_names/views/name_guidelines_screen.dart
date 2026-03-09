import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);

class NameGuidelinesScreen extends StatelessWidget {
  const NameGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFBFBFD),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white70 : Colors.grey,
            size: sw * 0.05,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          tr("islamic_names"),
          style: GoogleFonts.ebGaramond(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: sw * 0.055,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: sw * 0.05,
          vertical: sh * 0.03,
        ),
        child: Column(
          children: [
            // Title Header Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(sw * 0.04),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                tr("choosing_name_guidelines"),
                textAlign: TextAlign.center,
                style: GoogleFonts.ebGaramond(
                  fontSize: sw * 0.05,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2E2E2E),
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(height: sh * 0.03),

            // Content Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(sw * 0.05),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _paragraph(context, tr("guidelines_paragraph_1")),
                  const SizedBox(height: 12),
                  _paragraph(context, tr("guidelines_subtitle")),
                  const SizedBox(height: 8),
                  _bulletPoint(context, tr("guideline_1")),
                  _bulletPoint(context, tr("guideline_2")),
                  _bulletPoint(context, tr("guideline_3")),
                  _bulletPoint(context, tr("guideline_4")),
                  _bulletPoint(context, tr("guideline_5")),
                  const SizedBox(height: 16),
                  _paragraph(context, tr("guidelines_paragraph_2")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paragraph(BuildContext context, String text) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: GoogleFonts.ebGaramond(
        fontSize: sw * 0.04,
        color: isDark ? Colors.grey[300] : const Color(0xFF2E2E2E),
        height: 1.4,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _bulletPoint(BuildContext context, String text) {
    final sw = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(
              fontSize: sw * 0.04,
              color: isDark ? Colors.white : const Color(0xFF2E2E2E),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.ebGaramond(
                fontSize: sw * 0.04,
                color: isDark ? Colors.grey[300] : const Color(0xFF2E2E2E),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
