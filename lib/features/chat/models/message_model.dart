class MessageModel {
  String? id;
  String chatId;
  String senderId;
  String receiverId;
  String messageText;
  String time;
  StatusCode statusCode;
  bool edited;
  String? formattedTime;
  String? formattedDate;
  String? dateGroup;
  String? displayLabel;

  MessageModel({
    this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.time,
    this.statusCode = StatusCode.sent,
    this.edited = false,
    this.formattedTime,
    this.formattedDate,
    this.dateGroup,
    this.displayLabel,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["_id"] ?? json["id"],
      chatId: json["chatId"] ?? "",
      senderId: json["senderId"] ?? "",
      receiverId: json["receiverId"] ?? "",
      messageText: json["messageText"] ?? "",
      time: json["time"] ?? "",
      statusCode: _statusFromString(json["status"] ?? "sent"),
      edited: json["edited"] ?? false,
      formattedTime: json["formattedTime"],
      formattedDate: json["formattedDate"],
      dateGroup: json["dateGroup"],
      displayLabel: json["displayLabel"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "chatId": chatId,
      "senderId": senderId,
      "receiverId": receiverId,
      "messageText": messageText,
      "time": time,
      "status": statusCode.name,
      "edited": edited,
      "formattedTime": formattedTime,
      "formattedDate": formattedDate,
      "dateGroup": dateGroup,
      "displayLabel": displayLabel,
    };
  }

  static StatusCode _statusFromString(String? status) {
    final normalized = (status ?? 'sent').toLowerCase();

    if (normalized == 'received') {
      return StatusCode.received;
    }
    if (normalized == 'seen') {
      return StatusCode.seen;
    }
    if (normalized == 'sent') {
      return StatusCode.sent;
    }

    return StatusCode.sent;
  }
}

enum StatusCode { sent, received, seen }
