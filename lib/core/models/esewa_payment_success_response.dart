/// Model for eSewa transaction verification API response
class EsewaPaymentSuccessResponse {
  final List<EsewaTransactionData> data;

  EsewaPaymentSuccessResponse({required this.data});

  factory EsewaPaymentSuccessResponse.fromJson(Map<String, dynamic> json) {
    return EsewaPaymentSuccessResponse(
      data: (json['data'] as List)
          .map((item) => EsewaTransactionData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.map((item) => item.toJson()).toList()};
  }
}

class EsewaTransactionData {
  final String productId;
  final String productName;
  final String totalAmount;
  final String code;
  final EsewaMessage message;
  final EsewaTransactionDetails transactionDetails;
  final String merchantName;
  final String? refId;

  EsewaTransactionData({
    required this.productId,
    required this.productName,
    required this.totalAmount,
    required this.code,
    required this.message,
    required this.transactionDetails,
    required this.merchantName,
    this.refId,
  });

  factory EsewaTransactionData.fromJson(Map<String, dynamic> json) {
    return EsewaTransactionData(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      totalAmount: json['totalAmount'] ?? '',
      code: json['code'] ?? '',
      message: EsewaMessage.fromJson(json['message'] ?? {}),
      transactionDetails: EsewaTransactionDetails.fromJson(
        json['transactionDetails'] ?? {},
      ),
      merchantName: json['merchantName'] ?? '',
      refId: json['referenceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'totalAmount': totalAmount,
      'code': code,
      'message': message.toJson(),
      'transactionDetails': transactionDetails.toJson(),
      'merchantName': merchantName,
      if (refId != null) 'referenceId': refId,
    };
  }
}

class EsewaMessage {
  final String technicalSuccessMessage;
  final String successMessage;

  EsewaMessage({
    required this.technicalSuccessMessage,
    required this.successMessage,
  });

  factory EsewaMessage.fromJson(Map<String, dynamic> json) {
    return EsewaMessage(
      technicalSuccessMessage: json['technicalSuccessMessage'] ?? '',
      successMessage: json['successMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'technicalSuccessMessage': technicalSuccessMessage,
      'successMessage': successMessage,
    };
  }
}

class EsewaTransactionDetails {
  final String date;
  final String referenceId;
  final String status;

  EsewaTransactionDetails({
    required this.date,
    required this.referenceId,
    required this.status,
  });

  factory EsewaTransactionDetails.fromJson(Map<String, dynamic> json) {
    return EsewaTransactionDetails(
      date: json['date'] ?? '',
      referenceId: json['referenceId'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'referenceId': referenceId, 'status': status};
  }
}
