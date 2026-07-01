class ChatModel {
  String chatId;
  String chatUserName;
  String profilePic;
  String chatUserId;
  String previewChat;
  DateTime time;
  int? unreadMessages;


  ChatModel(this.chatId, this.chatUserName, this.profilePic, this.chatUserId, this.previewChat, this.time, [this.unreadMessages = 0]);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      json["id"] ?? json["_id"] ?? " ",
      json["chatUserName"] ?? " ",
      json["profilePic"] ?? " ",
      json["chatUserId"] ?? json["_id"] ?? " ",
      json["previewChat"] ?? " ",
      json["time"] ?? DateTime.now()
     );
  }
}