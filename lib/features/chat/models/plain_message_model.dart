class PlainMessageModel {
  String chatId;
  String plainTextMessage;
  String senderId;
  String receiverId;
  String timeStamp;
  String status = "delivered";
  bool edited = false;
  
  PlainMessageModel({
    required this.chatId,
    required this.plainTextMessage,
    required this.senderId,
    required this.receiverId,
    required this.timeStamp,
  });
}