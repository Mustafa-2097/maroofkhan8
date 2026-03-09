import 'package:get/get.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../model/payment_history_model.dart';

class PaymentHistoryController extends GetxController {
  var isLoading = false.obs;
  var transactions = <PaymentTransaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.paymentHistory);
      if (response['success'] == true) {
        final historyResponse = PaymentHistoryResponse.fromJson(response);
        transactions.value = historyResponse.data ?? [];
      }
    } catch (e) {
      print("Error fetching payment history: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
