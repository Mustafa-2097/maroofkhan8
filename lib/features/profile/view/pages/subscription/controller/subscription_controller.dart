import 'package:get/get.dart';
import '../../../../../../core/network/api_service.dart';
import '../../../../../../core/network/api_endpoints.dart';
import '../model/subscription_plan_model.dart';

class SubscriptionController extends GetxController {
  var isLoading = false.obs;
  var isSingleLoading = false.obs;
  var subscriptionPlans = <SubscriptionPlan>[].obs;
  var selectedPlan = Rxn<SubscriptionPlan>();

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionPlans();
  }

  Future<void> fetchSubscriptionPlans() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(ApiEndpoints.subscriptionPlan);
      if (response['success'] == true) {
        final planResponse = SubscriptionPlanResponse.fromJson(response);
        subscriptionPlans.value = planResponse.data ?? [];
      }
    } catch (e) {
      print("Error fetching subscription plans: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSingleSubscriptionPlan(String id) async {
    isSingleLoading.value = true;
    selectedPlan.value = null; // Clear previous selection
    try {
      final response = await ApiService.get(
        "${ApiEndpoints.subscriptionPlan}/$id",
      );
      if (response['success'] == true) {
        selectedPlan.value = SubscriptionPlan.fromJson(response['data']);
      }
    } catch (e) {
      print("Error fetching single subscription plan: $e");
    } finally {
      isSingleLoading.value = false;
    }
  }

  Future<String?> createCheckoutSession(String planId) async {
    isLoading.value = true;
    try {
      final response = await ApiService.post(
        ApiEndpoints.createCheckoutSession(planId),
        body: {},
        showErrorSnackbar: false,
      );
      if (response['success'] == true) {
        return response['data']['url'];
      }
      return null;
    } catch (e) {
      print("Error creating checkout session: $e");
      rethrow; // Rethrow to let the UI handle the error message
    } finally {
      isLoading.value = false;
    }
  }
}
