class PaymentHistoryResponse {
  bool? success;
  int? statusCode;
  String? message;
  List<PaymentTransaction>? data;

  PaymentHistoryResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryResponse(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((i) => PaymentTransaction.fromJson(i))
                .toList()
          : null,
    );
  }
}

class PaymentTransaction {
  String? id;
  String? amount;
  String? status;
  String? date;
  String? method;
  String? logo;

  PaymentTransaction({
    this.id,
    this.amount,
    this.status,
    this.date,
    this.method,
    this.logo,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    // Attempt to extract amount using multiple common keys and nested objects
    var amountVal =
        json['amount'] ??
        json['price'] ??
        json['totalAmount'] ??
        json['paidAmount'] ??
        json['total'];

    // Fallback to nested objects if raw amount is null
    if (amountVal == null) {
      if (json['subscription'] != null) {
        amountVal =
            json['subscription']['price'] ?? json['subscription']['amount'];
      } else if (json['donation'] != null) {
        amountVal =
            json['donation']['amount'] ?? json['donation']['totalAmount'];
      } else if (json['plan'] != null) {
        amountVal = json['plan']['price'] ?? json['plan']['amount'];
      }
    }

    return PaymentTransaction(
      id:
          json['transactionId'] ??
          json['id']?.toString() ??
          json['_id']?.toString() ??
          json['paymentIntentId'],
      amount: amountVal?.toString(),
      status:
          json['status'] ?? json['paymentStatus'] ?? json['subscriptionStatus'],
      date:
          json['date'] ??
          json['createdAt'] ??
          json['startDate'] ??
          json['updatedAt'] ??
          json['endDate'] ??
          json['transactionDate'],
      method: json['method'] ?? json['paymentMethod'] ?? 'Stripe',
      logo: json['logo'] ?? 'assets/images/stripe.png',
    );
  }
}
