import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Track which method is selected
  String selectedMethod = 'Stripe';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sw = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Subscription',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Select the payment method you want to use.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 30),

            // Payment Options
            _buildPaymentOption(
              'Stripe',
              Icons.api,
              imagePath: 'assets/images/stripe.png',
            ),

            // const SizedBox(height: 16),
            // _buildPaymentOption('PayPal', Icons.payment),
            // const SizedBox(height: 16),
            // _buildPaymentOption('Card', Icons.credit_card),
            const Spacer(),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF8D401E,
                  ), // Deep brown/rust color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, {String? imagePath}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = selectedMethod == title;

    return GestureDetector(
      onTap: () => setState(() => selectedMethod = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          // Change color based on selection
          color: isSelected
              ? const Color(0xFF8D401E)
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            imagePath != null
                ? Image.asset(
                    imagePath,
                    width: 24,
                    height: 24,
                    color: isSelected
                        ? const Color.fromARGB(255, 216, 214, 236)
                        : null,
                  )
                : Icon(
                    icon,
                    color: isSelected
                        ? Colors.white
                        : const Color.fromARGB(255, 4, 92, 192),
                  ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            // Custom Radio Circle
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.orangeAccent
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: Colors.orangeAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
