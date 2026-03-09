import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maroofkhan8/core/constant/app_colors.dart';
import 'package:maroofkhan8/core/network/api_service.dart';
import 'package:maroofkhan8/core/network/api_endpoints.dart';
import 'package:maroofkhan8/core/utils/snackbar_utils.dart';
import 'package:maroofkhan8/features/profile/view/pages/subscription/view/PaymentWebView.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  String selectedDonationType = 'Sadaqah (Voluntary Charity)';
  double selectedAmount = 200.0;
  final TextEditingController _customAmountController = TextEditingController(
    text: '0',
  );

  final List<double> suggestedAmounts = [50, 100, 200, 500, 1000];

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Donation',
          style: GoogleFonts.playfairDisplay(
            color: isDark ? Colors.white : AppColors.blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: Image.asset(
                      'assets/images/donation.png',
                      width: double.infinity,
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Your charity can change a life',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Give sincerely for Allah\'s pleasure',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  // Donation Type Section
                  SizedBox(height: 20.h),

                  // Choose Amount Section
                  Text(
                    'Choose Amount',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: suggestedAmounts.map((amount) {
                        bool isSelected = selectedAmount == amount;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAmount = amount;
                              _customAmountController.text = '0';
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(20.r),
                              border: isSelected
                                  ? Border.all(
                                      color: AppColors.primaryColorLight,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Text(
                              amount.toInt().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Or Enter Custom Amount Section
                  Text(
                    'Or Enter Custom Amount',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: _customAmountController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        selectedAmount = double.tryParse(val) ?? 0;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 15.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: AppColors.primaryColorLight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Donation',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            selectedAmount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'JazakAllahu Khairan',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: isDark ? Colors.blue.shade500 : Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedAmount < 50) {
                          Get.snackbar(
                            "Minimum Amount Required",
                            "The minimum donation amount is 50 to process the payment.",
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // Show loading indicator
                        Get.dialog(
                          const Center(child: CircularProgressIndicator()),
                          barrierDismissible: false,
                        );

                        try {
                          final response = await ApiService.post(
                            ApiEndpoints.createDonationSession,
                            body: {"amount": selectedAmount.toInt()},
                            showErrorSnackbar: false,
                          );

                          if (Get.isDialogOpen ?? false)
                            Get.back(); // Close loading dialog

                          if (response['success'] == true &&
                              response['data'] != null &&
                              response['data']['url'] != null) {
                            final sessionUrl = response['data']['url'];
                            final result = await Get.to(
                              () => PaymentWebView(url: sessionUrl),
                            );
                            if (result == true) {
                              setState(() {
                                _customAmountController.text = '0';
                                selectedAmount = 200.0;
                              });
                            }
                          } else {
                            Get.snackbar(
                              "Error",
                              "Could not create donation session",
                              backgroundColor: AppColors.redColor.withOpacity(
                                0.9,
                              ),
                              colorText: Colors.white,
                            );
                          }
                        } catch (e) {
                          if (Get.isDialogOpen ?? false) {
                            Get.back(); // Close loading dialog
                          }
                          // Show error snackbar manually after dialog closes
                          SnackbarUtils.showSnackbar(
                            "Error",
                            e.toString(),
                            isError: true,
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pay & Donate ',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ],
                      ),
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
}
