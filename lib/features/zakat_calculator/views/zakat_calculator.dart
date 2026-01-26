import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/features/zakat_calculator/views/zakat_details_screen.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFF9F9FB);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);
const Color kInputIconBg = Color(0xFFE8F5E9); // Light green background for icons
const Color kInputIconColor = Color(0xFF4CAF50); // Green color for icons

// ==========================================
// SCREEN 1: ZAKAT HOME (Rules & Guidelines)
// ==========================================
class ZakatCalculator extends StatelessWidget {
  const ZakatCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("Zakat", style: GoogleFonts.playfairDisplay(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: _buildBottomNav(0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Calculate Zakat CTA
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ZakatCalculatorScreen()));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.calculate, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Calculate Zakat", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text("Calculate your zakat easily &\naccurately", style: TextStyle(fontSize: 11, color: kTextGrey)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Hadith Quote
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: const Border(left: BorderSide(color: kPrimaryBrown, width: 4)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book, color: kPrimaryBrown, size: 20),
                      const SizedBox(width: 8),
                      Text("Hadith on Zakat", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\"The believer's shade on the Day of Resurrection will be his charity.\"",
                    style: GoogleFonts.playfairDisplay(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 5),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text("— Prophet Muhammad (ﷺ), Tirmidhi", style: TextStyle(fontSize: 10, color: kTextGrey)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 3. Rules & Guidelines Header
            Text("Zakat Rules & Guidelines", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 16)),
            const Text("Learn about the fundamentals of Zakat in Islam", style: TextStyle(fontSize: 11, color: kTextGrey)),
            const SizedBox(height: 15),

            // 4. List Items
            GestureDetector(
                onTap: (){
                  Get.to(ZakatRulesDetailScreen());
                },
                child: _ruleItem(Icons.library_books, "What is Zakat?", "Learn the fundamental meaning and importance of Zakat", kPrimaryBrown)),
            _ruleItem(Icons.people, "Who Must Pay Zakat?", "Understand the conditions for Zakat obligation", const Color(0xFFA1887F)),
            _ruleItem(Icons.balance, "Nisab & Hawl", "Understanding the minimum threshold and time period", const Color(0xFF8D6E63)),
            _ruleItem(Icons.pie_chart, "Assets Included In Zakat", "What types of wealth are subject to Zakat", const Color(0xFF795548)),
            _ruleItem(Icons.volunteer_activism, "Who Can Receive Zakat?", "The eight categories of Zakat recipients", const Color(0xFF6D4C41)),
            _ruleItem(Icons.block, "Who Cannot Receive Zakat?", "People who are not eligible for Zakat", const Color(0xFF5D4037)),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _ruleItem(IconData icon, String title, String sub, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(sub, style: const TextStyle(fontSize: 10, color: kTextGrey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 2: ZAKAT CALCULATOR INPUT
// ==========================================
class ZakatCalculatorScreen extends StatelessWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.calculate_outlined, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Zakat Calculator", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Text("Enter your assets below", style: TextStyle(fontSize: 12, color: kTextGrey)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Nisab Toggle Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Nisab Based On:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      SizedBox(height: 5),
                      Text("✓ Silver Nisab (612.36g) or = Balance", style: TextStyle(color: Colors.white, fontSize: 11)),
                      Text("✓ Gold Nisab (87.48g) or = Balance", style: TextStyle(color: Colors.white, fontSize: 11)),
                    ],
                  ),
                  Container(
                    height: 40, width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1)
                    ),
                    child: const Center(child: Text("2.5%\nor\n40/1", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8))),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Inputs
            _inputField(Icons.attach_money, "Cash in Hand & Bank", "0.00", "USD"),
            _inputField(Icons.trending_up, "Gold Price per Gram", "0.00", "USD"),
            _inputField(Icons.diamond_outlined, "Gold", "0.00", "grams"),
            _inputField(Icons.trending_up, "Silver Price per Gram", "0.85", "USD"),
            _inputField(Icons.link, "Silver", "0.00", "grams"),
            _inputField(Icons.store, "Business Assets", "0.85", ""),
            _inputField(Icons.credit_card, "Savings & Investments", "0.85", ""),
            _inputField(Icons.money_off, "Liabilities / Debts", "0.85", ""),

            const SizedBox(height: 20),

            // Summary Footer
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  const Align(alignment: Alignment.centerLeft, child: Text("Summary", style: TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  _summaryRow("Total Assets:", "\$0.00"),
                  _summaryRow("Nisab Threshold:", "\$520.51"),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Status:", style: TextStyle(fontSize: 12)),
                      Text("Below Nisab", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red[800])),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBrown, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ZakatResultScreen()));
                },
                child: const Text("View Detailed Results", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _inputField(IconData icon, String label, String value, String suffix) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: kInputIconBg, borderRadius: BorderRadius.circular(6)),
                    child: Icon(icon, color: kInputIconColor, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const Icon(Icons.info_outline, color: Colors.grey, size: 16),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
                if (suffix.isNotEmpty) Text(suffix, style: const TextStyle(fontSize: 12, color: kTextGrey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: kTextGrey)),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 3: ZAKAT RESULT
// ==========================================
class ZakatResultScreen extends StatelessWidget {
  const ZakatResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: _buildAppBar(context),
      bottomNavigationBar: _buildBottomNav(0), // Just for visual consistency
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Short Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: _cardDecoration(),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.calculate, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 15),
                  const Text("Zakat Calculator\nTotal your assets below", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Nisab Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: kPrimaryBrown, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Nisab Based On:", style: TextStyle(color: Colors.white70, fontSize: 10)),
                      Text("✓ Silver Nisab (612.36g) or = Balance", style: TextStyle(color: Colors.white, fontSize: 10)),
                      Text("✓ Gold Nisab (87.48g) or = Balance", style: TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                  Container(
                    height: 35, width: 35,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                    child: const Center(child: Text("2.5%", style: TextStyle(color: Colors.white, fontSize: 8))),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  const Text("Zakat Status: NOT ELIGIBLE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Text("Nisab threshold (silver): \$520.51", style: TextStyle(fontSize: 11, color: kTextGrey)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Total Zakat Assets:", style: TextStyle(fontSize: 12, color: kTextGrey)),
                        Text("\$0.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your wealth is below the Nisab threshold. Zakat is not obligatory at this time, but voluntary charity (Sadaqah) is always encouraged.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: kTextGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Breakdown
            Container(
              padding: const EdgeInsets.all(15),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Breakdown", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _breakdownRow(Icons.attach_money, "Cash", "\$0.00"),
                  _breakdownRow(Icons.diamond_outlined, "Gold\n0g x \$65", "\$0.00"),
                  _breakdownRow(Icons.link, "Silver\n0g x \$0.85", "\$0.00"),
                  _breakdownRow(Icons.store, "Business Assets", "\$0.00"),
                  _breakdownRow(Icons.credit_card, "Savings & Investments", "\$0.00"),
                  _breakdownRow(Icons.money_off, "Less: Debts", "\$0.00"),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("\$0.00", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryBrown)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Reminders
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: const Border(left: BorderSide(color: kPrimaryBrown, width: 3)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Important Reminders:", style: TextStyle(color: kPrimaryBrown, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  _reminderText("Zakat is due only if wealth has been in possession for one lunar year (Hawl)"),
                  _reminderText("Ensure gold and silver prices are updated to current market rates"),
                  _reminderText("Consult a scholar regarding jewelry worn regularly by women"),
                  _reminderText("Distribute Zakat to eligible recipients as defined in the Quran (9:60)"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(child: _outlineButton(Icons.download, "Save")),
                const SizedBox(width: 15),
                Expanded(child: _outlineButton(Icons.share, "Share")),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryBrown, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () => Navigator.pop(context),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, size: 18),
                    SizedBox(width: 8),
                    Text("Recalculate"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text("Back to Home", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _breakdownRow(IconData icon, String title, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: kInputIconBg, borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, color: kInputIconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 11))),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _reminderText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("✓ ", style: TextStyle(fontSize: 10, color: kPrimaryBrown)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10, color: kTextGrey))),
        ],
      ),
    );
  }

  Widget _outlineButton(IconData icon, String label) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: kTextDark),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- HELPER FUNCTIONS ---

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
        child: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
      ),
    ),
    centerTitle: true,
    title: Column(
      children: [
        Text("Zakat", style: GoogleFonts.playfairDisplay(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        const Text("Purify your wealth with ease and accuracy", style: TextStyle(fontSize: 10, color: kTextGrey)),
      ],
    ),
  );
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
  );
}

Widget _buildBottomNav(int index) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: kPrimaryBrown,
    unselectedItemColor: Colors.grey,
    selectedFontSize: 10,
    unselectedFontSize: 10,
    showUnselectedLabels: true,
    currentIndex: index,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), label: "AI Murshid"),
      BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: "Hadith"),
      BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Quran"),
      BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Prayer"),
    ],
  );
}