import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:maroofkhan8/core/utils/localization_utils.dart';
import 'package:maroofkhan8/core/constant/widgets/header.dart';
import 'package:maroofkhan8/features/zakat_calculator/views/what_is_zakat_screen.dart';
import 'package:maroofkhan8/features/zakat_calculator/views/who_must_pay_zakat_screen.dart';
import 'package:maroofkhan8/features/zakat_calculator/views/nisab_hawl_screen.dart';
import 'package:maroofkhan8/features/zakat_calculator/views/assets_included_screen.dart';
import 'package:maroofkhan8/features/zakat_calculator/views/who_can_receive_zakat_screen.dart';
import 'package:maroofkhan8/features/zakat_calculator/views/who_cannot_receive_zakat_screen.dart';
import 'package:maroofkhan8/features/zakat_calculator/controller/zakat_controller.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

// --- CONSTANTS ---
const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kBackground = Color(0xFFF9F9FB);
const Color kTextDark = Color(0xFF2E2E2E);
const Color kTextGrey = Color(0xFF757575);
const Color kInputIconBg = Color(
  0xFFE8F5E9,
); // Light green background for icons
const Color kInputIconColor = Color(0xFF4CAF50); // Green color for icons

// ==========================================
// SCREEN 1: ZAKAT HOME (Rules & Guidelines)
// ==========================================
class ZakatCalculator extends StatelessWidget {
  const ZakatCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("zakat")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text("Zakat", style: GoogleFonts.playfairDisplay(color: Colors.black, fontWeight: FontWeight.bold)),
      // ),
      //bottomNavigationBar: _buildBottomNav(0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Calculate Zakat CTA
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ZakatCalculatorScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kPrimaryBrown,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calculate, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr("calculate_zakat"),
                          style: GoogleFonts.playfairDisplay(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          tr("calculate_zakat_sub"),
                          style: const TextStyle(
                            fontSize: 11,
                            color: kTextGrey,
                          ),
                        ),
                      ],
                    ),
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
                border: const Border(
                  left: BorderSide(color: kPrimaryBrown, width: 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book,
                        color: kPrimaryBrown,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tr("hadith_on_zakat"),
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tr("zakat_hadith_quote"),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      tr("zakat_hadith_source"),
                      style: const TextStyle(fontSize: 10, color: kTextGrey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 3. Rules & Guidelines Header
            Text(
              tr("zakat_rules_guidelines"),
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              tr("zakat_rules_sub"),
              style: const TextStyle(fontSize: 11, color: kTextGrey),
            ),
            const SizedBox(height: 15),

            // 4. List Items
            GestureDetector(
              onTap: () {
                Get.to(const ZakatWhatIsScreen());
              },
              child: _ruleItem(
                Icons.library_books,
                tr("what_is_zakat"),
                tr("what_is_zakat_sub"),
                kPrimaryBrown,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const ZakatWhoMustPayScreen());
              },
              child: _ruleItem(
                Icons.people,
                tr("who_must_pay_zakat"),
                tr("who_must_pay_zakat_sub"),
                kPrimaryBrown,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const NisabHawlScreen());
              },
              child: _ruleItem(
                Icons.balance,
                tr("nisab_hawl"),
                tr("nisab_hawl_sub"),
                kPrimaryBrown,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const AssetsIncludedScreen());
              },
              child: _ruleItem(
                Icons.pie_chart,
                tr("assets_included"),
                tr("assets_included_sub"),
                kPrimaryBrown,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const WhoCanReceiveZakatScreen());
              },
              child: _ruleItem(
                Icons.volunteer_activism,
                tr("who_can_receive"),
                tr("who_can_receive_sub"),
                kPrimaryBrown,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const WhoCannotReceiveZakatScreen());
              },
              child: _ruleItem(
                Icons.block,
                tr("who_cannot_receive"),
                tr("who_cannot_receive_sub"),
                kPrimaryBrown,
              ),
            ),

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
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(fontSize: 10, color: kTextGrey),
                ),
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
    context.locale;
    final controller = Get.put(ZakatController());

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

      //appBar: _buildAppBar(context),
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
                    decoration: BoxDecoration(
                      color: kPrimaryBrown,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calculate_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr("zakat_calculator_title"),
                        style: GoogleFonts.playfairDisplay(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        tr("enter_assets_below"),
                        style: const TextStyle(fontSize: 12, color: kTextGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Nisab Toggle Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: kPrimaryBrown,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr("nisab_based_on"),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        localizeDigits(tr("silver_nisab_text"), context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        localizeDigits(tr("gold_nisab_text"), context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        localizeDigits("2.5%\nor\n40/1", context),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Inputs
            _inputField(
              Icons.attach_money,
              tr("cash_in_hand"),
              controller.cashController,
              tr("usd"),
            ),
            _inputField(
              Icons.trending_up,
              tr("gold_price_per_gram"),
              controller.goldPriceController,
              tr("usd"),
            ),
            _inputField(
              Icons.diamond_outlined,
              tr("gold_label"),
              controller.goldGramsController,
              tr("grams"),
            ),
            _inputField(
              Icons.trending_up,
              tr("silver_price_per_gram"),
              controller.silverPriceController,
              tr("usd"),
            ),
            _inputField(
              Icons.link,
              tr("silver_label"),
              controller.silverGramsController,
              tr("grams"),
            ),
            _inputField(
              Icons.store,
              tr("business_assets"),
              controller.businessAssetsController,
              tr("usd"),
            ),
            _inputField(
              Icons.credit_card,
              tr("savings_investments"),
              controller.savingsInvestmentsController,
              tr("usd"),
            ),
            _inputField(
              Icons.money_off,
              tr("liabilities_debts"),
              controller.liabilitiesController,
              tr("usd"),
            ),

            const SizedBox(height: 20),

            // Summary Footer
            Obx(
              () => Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        tr("summary"),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _summaryRow(
                      tr("total_assets_colon"),
                      "${localizeDigits("\$", context)}${localizeDigits(controller.totalAssets.value.toStringAsFixed(2), context)}",
                    ),
                    _summaryRow(
                      tr("nisab_threshold_colon"),
                      "${localizeDigits("\$", context)}${localizeDigits(controller.nisabThreshold.value.toStringAsFixed(2), context)}",
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${tr("status_colon")} ",
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          controller.isAboveNisab.value
                              ? tr("eligible")
                              : tr("not_eligible"),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: controller.isAboveNisab.value
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBrown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ZakatResultScreen(),
                    ),
                  );
                },
                child: Text(
                  tr("view_detailed_results"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    IconData icon,
    String label,
    TextEditingController controller,
    String suffix,
  ) {
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
                    decoration: BoxDecoration(
                      color: kInputIconBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(icon, color: kInputIconColor, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.info_outline, color: Colors.grey, size: 16),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () {
                      if (controller.text == "0.00" ||
                          controller.text == "0.0") {
                        controller.clear();
                      }
                    },
                  ),
                ),
                if (suffix.isNotEmpty)
                  Text(
                    suffix,
                    style: const TextStyle(fontSize: 12, color: kTextGrey),
                  ),
              ],
            ),
          ),
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
          Text(
            val,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
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

  Future<void> _downloadZakatDetails(
    BuildContext context,
    ZakatController controller,
  ) async {
    try {
      if (Platform.isAndroid) {
        await Permission.storage.request();
      }

      Directory? directory;
      if (Platform.isAndroid) {
        final dirs = await getExternalStorageDirectories(
          type: StorageDirectory.downloads,
        );
        if (dirs != null && dirs.isNotEmpty) {
          directory = dirs.first;
        } else {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'Zakat_Calculation_$timestamp.txt';
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        final breakdown =
            """
${tr("cash")}: ${localizeDigits("\$", context)}${localizeDigits(double.tryParse(controller.cashController.text)?.toStringAsFixed(2) ?? "0.00", context)}
${tr("gold_label")} (${localizeDigits(controller.goldGramsController.text, context)}${tr("grams_abbr")}): ${localizeDigits("\$", context)}${localizeDigits(((double.tryParse(controller.goldGramsController.text) ?? 0) * (double.tryParse(controller.goldPriceController.text) ?? 0)).toStringAsFixed(2), context)}
${tr("silver_label")} (${localizeDigits(controller.silverGramsController.text, context)}${tr("grams_abbr")}): ${localizeDigits("\$", context)}${localizeDigits(((double.tryParse(controller.silverGramsController.text) ?? 0) * (double.tryParse(controller.silverPriceController.text) ?? 0)).toStringAsFixed(2), context)}
${tr("business_assets")}: ${localizeDigits("\$", context)}${localizeDigits(double.tryParse(controller.businessAssetsController.text)?.toStringAsFixed(2) ?? "0.00", context)}
${tr("savings_investments")}: ${localizeDigits("\$", context)}${localizeDigits(double.tryParse(controller.savingsInvestmentsController.text)?.toStringAsFixed(2) ?? "0.00", context)}
${tr("less_debts")}: ${localizeDigits("\$", context)}${localizeDigits(double.tryParse(controller.liabilitiesController.text)?.toStringAsFixed(2) ?? "0.00", context)}
--------------------------------
${tr("total_assets_colon")} ${localizeDigits("\$", context)}${localizeDigits(controller.totalAssets.value.toStringAsFixed(2), context)}
${tr("nisab_threshold_colon")} ${localizeDigits("\$", context)}${localizeDigits(controller.nisabThreshold.value.toStringAsFixed(2), context)}
${tr("status_colon")} ${controller.isAboveNisab.value ? tr("eligible") : tr("not_eligible")}
""";

        final zakatPayableStr = controller.isAboveNisab.value
            ? "\n${tr("zakat_payable_colon")} ${localizeDigits("\$", context)}${localizeDigits(controller.zakatPayable.value.toStringAsFixed(2), context)}"
            : "";

        final textToSave =
            """
${tr("zakat_calculator_title")} ${tr("summary")}
${tr("date_colon")} ${localizeDigits(DateTime.now().toString(), context)}

$breakdown$zakatPayableStr

${tr("shared_via")}
""";

        await file.writeAsString(textToSave);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${tr("zakat_results_saved")}\n${tr("path_colon")} $filePath",
            ),
            backgroundColor: kPrimaryBrown,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${tr("error_colon")} $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final controller = Get.find<ZakatController>();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: HeaderSection(title: tr("zakat_calculator_title")),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      //appBar: _buildAppBar(context),
      //  bottomNavigationBar: _buildBottomNav(0), // Just for visual consistency
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
                    decoration: BoxDecoration(
                      color: kPrimaryBrown,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calculate,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "${tr("zakat_calculator_title")}\n${tr("enter_assets_below")}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Nisab Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryBrown,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr("nisab_based_on"),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        localizeDigits(tr("silver_nisab_text"), context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        localizeDigits(tr("gold_nisab_text"), context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        localizeDigits("2.5%", context),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Status Card
            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    Text(
                      "${tr("zakat_status_colon")} ${controller.isAboveNisab.value ? tr("eligible") : tr("not_eligible")}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${tr("nisab_threshold_silver")} ${localizeDigits("\$", context)}${localizeDigits(controller.nisabThreshold.value.toStringAsFixed(2), context)}",
                      style: const TextStyle(fontSize: 11, color: kTextGrey),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr("total_zakat_assets_colon"),
                            style: const TextStyle(
                              fontSize: 12,
                              color: kTextGrey,
                            ),
                          ),
                          Text(
                            "${localizeDigits("\$", context)}${localizeDigits(controller.totalAssets.value.toStringAsFixed(2), context)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      localizeDigits(
                        controller.isAboveNisab.value
                            ? tr("above_nisab_msg")
                            : tr("below_nisab_msg"),
                        context,
                      ),
                      style: GoogleFonts.ebGaramond(
                        fontSize: 13,
                        color: kTextGrey,
                        height: 1.4,
                      ),
                    ),
                    if (controller.isAboveNisab.value) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.green[50]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localizeDigits(
                                tr("zakat_payable_colon"),
                                context,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              "${localizeDigits("\$", context)}${localizeDigits(controller.zakatPayable.value.toStringAsFixed(2), context)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Breakdown
            Obx(
              () => Container(
                padding: const EdgeInsets.all(15),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr("breakdown"),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    _breakdownRow(
                      Icons.attach_money,
                      tr("cash"),
                      "${localizeDigits("\$", context)}${localizeDigits(double.tryParse(controller.cashController.text)?.toStringAsFixed(2) ?? "0.00", context)}",
                    ),
                    _breakdownRow(
                      Icons.diamond_outlined,
                      "${tr("gold_label")}\n${localizeDigits(controller.goldGramsController.text, context)}${tr("grams_abbr")} x ${localizeDigits("\$", context)}${localizeDigits(controller.goldPriceController.text, context)}",
                      "${localizeDigits("\$", context)}${localizeDigits(((double.tryParse(controller.goldGramsController.text) ?? 0) * (double.tryParse(controller.goldPriceController.text) ?? 0)).toStringAsFixed(2), context)}",
                    ),
                    _breakdownRow(
                      Icons.link,
                      "${tr("silver_label")}\n${localizeDigits(controller.silverGramsController.text, context)}${tr("grams_abbr")} x ${localizeDigits("\$", context)}${localizeDigits(controller.silverPriceController.text, context)}",
                      "${localizeDigits("\$", context)}${localizeDigits(((double.tryParse(controller.silverGramsController.text) ?? 0) * (double.tryParse(controller.silverPriceController.text) ?? 0)).toStringAsFixed(2), context)}",
                    ),
                    _breakdownRow(
                      Icons.store,
                      tr("business_assets"),
                      "${localizeDigits("\$", context)}${localizeDigits(double.tryParse(controller.businessAssetsController.text)?.toStringAsFixed(2) ?? "0.00", context)}",
                    ),
                    _breakdownRow(
                      Icons.credit_card,
                      tr("savings_investments"),
                      "${localizeDigits("\$", context)}${localizeDigits(double.tryParse(controller.savingsInvestmentsController.text)?.toStringAsFixed(2) ?? "0.00", context)}",
                    ),
                    _breakdownRow(
                      Icons.money_off,
                      tr("less_debts"),
                      "${localizeDigits("\$", context)}${localizeDigits(double.tryParse(controller.liabilitiesController.text)?.toStringAsFixed(2) ?? "0.00", context)}",
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr("total_colon"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${localizeDigits("\$", context)}${localizeDigits(controller.totalAssets.value.toStringAsFixed(2), context)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kPrimaryBrown,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Reminders
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: const Border(
                  left: BorderSide(color: kPrimaryBrown, width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr("important_reminders"),
                    style: const TextStyle(
                      color: kPrimaryBrown,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _reminderText(localizeDigits(tr("reminder_1"), context)),
                  _reminderText(localizeDigits(tr("reminder_2"), context)),
                  _reminderText(localizeDigits(tr("reminder_3"), context)),
                  _reminderText(localizeDigits(tr("reminder_4"), context)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _outlineButton(
                    Icons.download,
                    tr("save"),
                    onTap: () => _downloadZakatDetails(context, controller),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _outlineButton(
                    Icons.share,
                    tr("share"),
                    onTap: () {
                      final text =
                          "${tr("zakat_calculator_title")} ${tr("summary")}:\n"
                          "${tr("total_assets_colon")} ${localizeDigits("\$", context)}${localizeDigits(controller.totalAssets.value.toStringAsFixed(2), context)}\n"
                          "${tr("nisab_threshold_colon")} ${localizeDigits("\$", context)}${localizeDigits(controller.nisabThreshold.value.toStringAsFixed(2), context)}\n"
                          "${tr("status_colon")} ${controller.isAboveNisab.value ? tr("eligible") : tr("not_eligible")}\n"
                          "${controller.isAboveNisab.value ? '${tr("zakat_payable_colon")} ${localizeDigits("\$", context)}${localizeDigits(controller.zakatPayable.value.toStringAsFixed(2), context)}\n' : ''}";
                      Share.share(localizeDigits(text, context));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryBrown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh, size: 18),
                    const SizedBox(width: 8),
                    Text(tr("recalculate")),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: Text(
                  tr("back_to_home"),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            decoration: BoxDecoration(
              color: kInputIconBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: kInputIconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 11))),
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
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
          const Text(
            "✓ ",
            style: TextStyle(fontSize: 10, color: kPrimaryBrown),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 10, color: kTextGrey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlineButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: kTextDark),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HELPER FUNCTIONS ---

// AppBar _buildAppBar(BuildContext context) {
//   return AppBar(
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     leading: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: IconButton(
//           icon: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
//           onPressed: () => Navigator.pop(context),
//           padding: EdgeInsets.zero,
//         ),
//       ),
//     ),
//     centerTitle: true,
//     title: Column(
//       children: [
//         Text(
//           "Zakat",
//           style: GoogleFonts.playfairDisplay(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         const Text(
//           "Purify your wealth with ease and accuracy",
//           style: TextStyle(fontSize: 10, color: kTextGrey),
//         ),
//       ],
//     ),
//   );
// }

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

// Widget _buildBottomNav(int index) {
//   return BottomNavigationBar(
//     type: BottomNavigationBarType.fixed,
//     selectedItemColor: kPrimaryBrown,
//     unselectedItemColor: Colors.grey,
//     selectedFontSize: 10,
//     unselectedFontSize: 10,
//     showUnselectedLabels: true,
//     currentIndex: index,
//     items: const [
//       BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.auto_awesome_outlined),
//         label: "AI Murshid",
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.menu_book_outlined),
//         label: "Hadith",
//       ),
//       BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Quran"),
//       BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Prayer"),
//     ],
//   );
// }
