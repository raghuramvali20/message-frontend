class MessageModel {
  String chatId;
  String senderId;
  String receiverId;
  String messageText;
  String time;
  StatusCode statusCode; // ✅ No longer hardcoded
  bool edited; // ✅ No longer hardcoded

  MessageModel({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.time,
    this.statusCode = StatusCode.delivered, // ✅ Default value
    this.edited = false, // ✅ Default value
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      chatId: json["chatId"] ?? "",
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      messageText: json["messageText"],
      time: json["time"].toString(),
      statusCode: _statusFromString(
        json["status"] ?? "delivered",
      ), // ✅ Parse from backend
      edited: json["edited"] ?? false, // ✅ Parse from backend
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "senderId": senderId,
      "receiverId": receiverId,
      "messageText": messageText,
      "time": time,
      "status": statusCode.name, // enum → string
      "edited": edited,
    };
  }

  static StatusCode _statusFromString(String? status) {
    try {
      return StatusCode.values.byName(status!);
    } catch (_) {
      return StatusCode.delivered; // fallback
    }
  }
}

enum StatusCode { sent, delivered, seen }
