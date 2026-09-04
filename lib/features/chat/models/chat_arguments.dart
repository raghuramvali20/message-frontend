class ChatArguments {
  String chatId;
  String chatUserName;
  String profilePic;
  String chatUserId;
  bool online;
  DateTime? lastSeen;

  ChatArguments(
    this.chatId,
    this.chatUserId,
    this.chatUserName,
    this.profilePic, {
    this.online = false,
    this.lastSeen,
  });
}
