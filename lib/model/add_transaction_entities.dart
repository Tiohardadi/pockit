import 'dart:convert';

class AddTransactionEntities {
  final int userId;
  final String date;
  final int transactionType;
  final double amount;
  final String tag;
  final int pocketId;
  final String description;

  AddTransactionEntities({
    required this.userId,
    required this.date,
    required this.transactionType,
    required this.amount,
    required this.tag,
    required this.pocketId,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "date": date,
      "transactionType": transactionType,
      "amount": amount,
      "tag": tag,
      "pocketId": pocketId,
      "description": description,
    };
  }

  factory AddTransactionEntities.fromJson(Map<String, dynamic> json) {
    return AddTransactionEntities(
      userId: json["userId"],
      date: json["date"],
      transactionType: json["transactionType"],
      amount: (json["amount"] as num).toDouble(),
      tag: json["tag"],
      pocketId: json["pocketId"],
      description: json["description"],
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
