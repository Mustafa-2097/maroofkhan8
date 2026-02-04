import 'package:get/get.dart';

class PaymentHistoryController extends GetxController {
  // Mock data for payments
  final List<Map<String, dynamic>> transactions = [
    {
      "method": "Stripe",
      "id": "123456789",
      "amount": "\$9.00",
      "status": "Confirmed",
      "date": "16 Sep 2026 11:21 AM",
      "logo": "assets/images/stripe.png"
    },
    {
      "method": "Stripe",
      "id": "12345678",
      "amount": "\$9.00",
      "status": "Confirmed",
      "date": "16 Sep 2026 11:21 AM",
      "logo": "assets/images/stripe.png"
    },
    {
      "method": "Stripe",
      "id": "12345679",
      "amount": "\$9.00",
      "status": "Confirmed",
      "date": "16 Sep 2026 11:21 AM",
      "logo": "assets/images/stripe.png"
    },
    {
      "method": "Stripe",
      "id": "12345689",
      "amount": "\$9.00",
      "status": "Confirmed",
      "date": "16 Sep 2026 11:21 AM",
      "logo": "assets/images/stripe.png"
    },
    // Add more mock items here
  ].obs;
}