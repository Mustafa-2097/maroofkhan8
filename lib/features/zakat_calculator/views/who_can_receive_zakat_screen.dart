import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';

const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFF8F9FB);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);

class WhoCanReceiveZakatScreen extends StatelessWidget {
  const WhoCanReceiveZakatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : kBackground,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              tr("zakat"),
              style: GoogleFonts.ebGaramond(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              tr("purify_wealth_sub"),
              style: GoogleFonts.ebGaramond(fontSize: 12, color: kTextGrey),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // 1. Top Card: Who Can Receive Zakat?
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
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
                      Icons.volunteer_activism_outlined,
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
                          tr("who_can_receive_zakat"),
                          style: GoogleFonts.ebGaramond(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : kTextDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tr("who_can_receive_zakat_sub"),
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
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizeDigits(tr("zakat_recipients_title"), context),
                    style: GoogleFonts.ebGaramond(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kTextDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _recipientItem(tr("recipient_poor"), isDark),
                  _recipientItem(tr("recipient_needy"), isDark),
                  _recipientItem(tr("recipient_admin"), isDark),
                  _recipientItem(tr("recipient_hearts"), isDark),
                  _recipientItem(tr("recipient_slaves"), isDark),
                  _recipientItem(tr("recipient_travelers"), isDark),
                  _recipientItem(tr("recipient_debt"), isDark),
                  _recipientItem(tr("recipient_cause"), isDark),
                  const SizedBox(height: 20),
                  Text(
                    tr("zakat_distribution_notice"),
                    style: GoogleFonts.ebGaramond(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : kTextDark,
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
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: const Border(
                  left: BorderSide(color: kPrimaryBrown, width: 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Icon(
                      Icons.menu_book_outlined,
                      color: isDark ? Colors.white70 : kTextDark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr("need_more_guidance"),
                          style: GoogleFonts.ebGaramond(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : kTextDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr("guidance_desc"),
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

  Widget _recipientItem(String text, bool isDark) {
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
                color: isDark ? Colors.white70 : kTextDark,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
