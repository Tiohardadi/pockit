class Transaction {
  final int id;
  final String tag;
  final String description;
  final double amount;
  final String transactionType;
  final String transactionDate;
  final String pocket;

  Transaction({
    required this.id,
    required this.tag,
    required this.description,
    required this.amount,
    required this.transactionType,
    required this.transactionDate,
    required this.pocket,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      tag: json['tag'],
      description: json['description'],
      amount: json['amount'],
      transactionType: json['transactionType'],
      transactionDate: json['transactionDate'],
      pocket: json['pocket'],
    );
  }
}

class TransactionResponse {
  final bool success;
  final String message;
  final int userId;
  final int page;
  final int size;
  final List<Transaction> transactions;

  TransactionResponse({
    required this.success,
    required this.message,
    required this.userId,
    required this.page,
    required this.size,
    required this.transactions,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      success: json['success'],
      message: json['message'],
      userId: json['data']['userId'],
      page: json['data']['page'],
      size: json['data']['size'],
      transactions: (json['data']['transactions'] as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList(),
    );
  }
}