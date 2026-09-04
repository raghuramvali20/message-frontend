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
  bool hasUnread;
  bool online;
  DateTime? lastSeen;

  ChatModel(
    this.chatId,
    this.chatUserName,
    this.profilePic,
    this.chatUserId,
    this.previewChat,
    this.lastUpdate, [
    this.hasUnread = false,
    this.formattedTime,
    this.formattedDate,
    this.dateGroup,
    this.displayLabel,
    this.online = false,
    this.lastSeen,
  ]);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final lastUpdateValue =
        json["lastUpdate"] ?? DateTime.now().toIso8601String();
    final rawUnread = json["hasUnread"] ?? json["unreadMessages"] ?? false;
    final bool unreadValue;

    if (rawUnread is bool) {
      unreadValue = rawUnread;
    } else if (rawUnread is num) {
      unreadValue = rawUnread > 0;
    } else if (rawUnread is String) {
      unreadValue =
          rawUnread.toLowerCase() == 'true' ||
          int.tryParse(rawUnread) != null && int.parse(rawUnread) > 0;
    } else {
      unreadValue = false;
    }

    return ChatModel(
      json["id"] ?? json["_id"] ?? " ",
      json["userName"] ?? " ",
      json["profilePic"] ?? " ",
      json["receiverId"] ?? json["_id"] ?? " ",
      json["preview"] ?? " ",
      lastUpdateValue is String
          ? DateTime.tryParse(lastUpdateValue)
          : lastUpdateValue,
      unreadValue,
      json["formattedTime"],
      json["formattedDate"],
      json["dateGroup"],
      json["displayLabel"],
      json["online"] == true,
      json["lastSeen"] is String ? DateTime.tryParse(json["lastSeen"]) : null,
    );
  }
}
