class ChatList {
  String chatId;
  String userName;
  String profilePic;
  String receiverId;

  ChatList(this.chatId, this.userName, this.profilePic, this.receiverId);

  factory ChatList.fromJson(Map<String, dynamic> json) {
    return ChatList(
      json["id"] ?? json["_id"] ?? " ",
      json["userName"] ?? " ",
      json["profilePic"] ?? " ",
      json["receiverId"] ?? json["_id"] ?? " "
     );
  }
}