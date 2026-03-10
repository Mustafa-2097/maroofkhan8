import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controller/payment_history_controller.dart';
import '../../model/payment_history_model.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentHistoryController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr("payment_history").toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.transactions.isEmpty) {
            return Center(child: Text(tr("no_transactions")));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            itemCount: controller.transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final tx = controller.transactions[index];
              return _TransactionCard(tx: tx, isDark: isDark);
            },
          );
        }),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final PaymentTransaction tx;
  final bool isDark;

  const _TransactionCard({required this.tx, required this.isDark});

  String _formatDate(String dateStr) {
    try {
      DateTime dateTime = DateTime.parse(dateStr).toLocal();
      return DateFormat('d MMM yyyy, h:mm a').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Row(
        children: [
          /// Method Logo
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: tx.logo != null && tx.logo!.startsWith('assets')
                  ? Image.asset(tx.logo!, fit: BoxFit.contain)
                  : tx.logo != null
                  ? Image.network(tx.logo!, fit: BoxFit.contain)
                  : const Icon(Icons.payment),
            ),
          ),
          const SizedBox(width: 12),

          /// Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${tr("transfer_via")} ${tx.method ?? 'Stripe'}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "${tr("transaction_id")}: ${tx.id ?? 'N/A'}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),

          /// Amount and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tx.amount != null
                    ? (tx.amount!.contains('\$')
                          ? tx.amount!
                          : '\$${tx.amount}')
                    : '\$0.00',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color:
                      (tx.status?.toLowerCase() == 'confirmed' ||
                          tx.status?.toLowerCase() == 'succeeded' ||
                          tx.status?.toLowerCase() == 'active' ||
                          tx.status?.toLowerCase() == 'completed' ||
                          tx.status?.toLowerCase() == 'paid')
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                ),
                child: Text(
                  tr(tx.status?.toLowerCase() ?? 'pending'),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color:
                        (tx.status?.toLowerCase() == 'confirmed' ||
                            tx.status?.toLowerCase() == 'succeeded' ||
                            tx.status?.toLowerCase() == 'active' ||
                            tx.status?.toLowerCase() == 'completed' ||
                            tx.status?.toLowerCase() == 'paid')
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                tx.date != null ? _formatDate(tx.date!) : tr("no_date"),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
