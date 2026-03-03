import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZakatController extends GetxController {
  // Input controllers for the fields
  final cashController = TextEditingController(text: "0.00");
  final goldPriceController = TextEditingController(text: "0.00");
  final goldGramsController = TextEditingController(text: "0.00");
  final silverPriceController = TextEditingController(text: "0.85");
  final silverGramsController = TextEditingController(text: "0.00");
  final businessAssetsController = TextEditingController(text: "0.00");
  final savingsInvestmentsController = TextEditingController(text: "0.00");
  final liabilitiesController = TextEditingController(text: "0.00");

  // Observables for the summary
  final totalAssets = 0.0.obs;
  final zakatPayable = 0.0.obs;
  final nisabThreshold = 520.51.obs; // Default based on silver
  final status = "Below Nisab".obs;
  final isAboveNisab = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to all controllers to update calculations in real-time
    cashController.addListener(calculateZakat);
    goldPriceController.addListener(calculateZakat);
    goldGramsController.addListener(calculateZakat);
    silverPriceController.addListener(calculateZakat);
    silverGramsController.addListener(calculateZakat);
    businessAssetsController.addListener(calculateZakat);
    savingsInvestmentsController.addListener(calculateZakat);
    liabilitiesController.addListener(calculateZakat);

    calculateZakat();
  }

  void calculateZakat() {
    double cash = double.tryParse(cashController.text) ?? 0.0;
    double goldPrice = double.tryParse(goldPriceController.text) ?? 0.0;
    double goldGrams = double.tryParse(goldGramsController.text) ?? 0.0;
    double silverPrice = double.tryParse(silverPriceController.text) ?? 0.0;
    double silverGrams = double.tryParse(silverGramsController.text) ?? 0.0;
    double businessAssets =
        double.tryParse(businessAssetsController.text) ?? 0.0;
    double savings = double.tryParse(savingsInvestmentsController.text) ?? 0.0;
    double liabilities = double.tryParse(liabilitiesController.text) ?? 0.0;

    double totalGoldValue = goldPrice * goldGrams;
    double totalSilverValue = silverPrice * silverGrams;

    double total =
        cash +
        totalGoldValue +
        totalSilverValue +
        businessAssets +
        savings -
        liabilities;
    totalAssets.value = total > 0 ? total : 0.0;

    // Calculate Nisab Threshold (Silver is often the standard for lower threshold)
    // silver nisab = 612.36g
    nisabThreshold.value = silverPrice * 612.36;

    if (totalAssets.value >= nisabThreshold.value) {
      zakatPayable.value = totalAssets.value * 0.025;
      status.value = "Above Nisab";
      isAboveNisab.value = true;
    } else {
      zakatPayable.value = 0.0;
      status.value = "Below Nisab";
      isAboveNisab.value = false;
    }
  }

  @override
  void onClose() {
    cashController.dispose();
    goldPriceController.dispose();
    goldGramsController.dispose();
    silverPriceController.dispose();
    silverGramsController.dispose();
    businessAssetsController.dispose();
    savingsInvestmentsController.dispose();
    liabilitiesController.dispose();
    super.onClose();
  }
}
