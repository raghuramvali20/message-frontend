class ChatModel {
  String chatId;
  String chatUserName;
  String profilePic;
  String chatUserId;
  String previewChat;
  DateTime lastUpdate;
  int? unreadMessages;


  ChatModel(this.chatId, this.chatUserName, this.profilePic, this.chatUserId, this.previewChat, this.lastUpdate, [this.unreadMessages = 0]);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      json["id"] ?? json["_id"] ?? " ",
      json["userName"] ?? " ",
      json["profilePic"] ?? " ",
      json["receiverId"] ?? json["_id"] ?? " ",
      json["preview"] ?? " ",
      json["lastUpdate"] ?? DateTime.now()
     );
  }
}