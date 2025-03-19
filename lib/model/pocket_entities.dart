class PocketEntity {
  final int id;
  final String name;
  final String accountNumber;
  final double balance;

  PocketEntity({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.balance,
  });

  factory PocketEntity.fromJson(Map<String, dynamic> json) {
    return PocketEntity(
      id: json['id'],
      name: json['name'],
      accountNumber: json['account_number'],
      balance: json['balance'],
    );
  }

  static List<PocketEntity> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PocketEntity.fromJson(json)).toList();
  }
}

class PocketData {
  final int userId;
  final int page;
  final int size;
  final List<PocketEntity> pockets;

  PocketData({
    required this.userId,
    required this.page,
    required this.size,
    required this.pockets,
  });

  factory PocketData.fromJson(Map<String, dynamic> json) {
    return PocketData(
      userId: json['userId'],
      page: json['page'],
      size: json['size'],
      pockets: PocketEntity.fromJsonList(json['pockets']),
    );
  }
}

class PocketResponse {
  final bool success;
  final String message;
  final PocketData data;

  PocketResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PocketResponse.fromJson(Map<String, dynamic> json) {
    return PocketResponse(
      success: json['success'],
      message: json['message'],
      data: PocketData.fromJson(json['data']),
    );
  }
}