class TagEntities {
  final int id;
  final String name;

  TagEntities({required this.id, required this.name});

  factory TagEntities.fromJson(Map<String, dynamic> json) {
    return TagEntities(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<TagEntities> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TagEntities.fromJson(json)).toList();
  }
}

class TagResponse {
  final bool success;
  final String message;
  final List<TagEntities> data;

  TagResponse({required this.success, required this.message, required this.data});

  factory TagResponse.fromJson(Map<String, dynamic> json) {
    return TagResponse(
      success: json['success'],
      message: json['message'],
      data: TagEntities.fromJsonList(json['data']),
    );
  }
}
