class ChatModel {
  String chatId;
  String chatUserName;
  String profilePic;
  String chatUserId;
  String previewChat;
  DateTime? lastUpdate;
  String? formattedTime;
  String? formattedDate;
  String? dateGroup;
  String? displayLabel;
  int? unreadMessages;

  ChatModel(
    this.chatId,
    this.chatUserName,
    this.profilePic,
    this.chatUserId,
    this.previewChat,
    this.lastUpdate, [
    this.unreadMessages = 0,
    this.formattedTime,
    this.formattedDate,
    this.dateGroup,
    this.displayLabel,
  ]);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final lastUpdateValue = json["lastUpdate"] ?? DateTime.now().toIso8601String();

    return ChatModel(
      json["id"] ?? json["_id"] ?? " ",
      json["userName"] ?? " ",
      json["profilePic"] ?? " ",
      json["receiverId"] ?? json["_id"] ?? " ",
      json["preview"] ?? " ",
      lastUpdateValue is String ? DateTime.tryParse(lastUpdateValue) : lastUpdateValue,
      0,
      json["formattedTime"],
      json["formattedDate"],
      json["dateGroup"],
      json["displayLabel"],
    );
  }
}