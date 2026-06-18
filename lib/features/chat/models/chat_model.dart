class MessageModel {
  String chatId;
  String senderId;
  String receiverId;
  String cipherTextForSender;
  String cipherTextForReceiver;
  String timeStamp;
  String statusCode;  // ✅ No longer hardcoded
  bool edited;        // ✅ No longer hardcoded

  MessageModel({
    required this.chatId, 
    required this.senderId, 
    required this.receiverId,
    required this.cipherTextForSender, 
    required this.cipherTextForReceiver,
    required this.timeStamp,
    this.statusCode = "delivered",  // ✅ Default value
    this.edited = false             // ✅ Default value
  });

  factory MessageModel.fromJson(Map<String, dynamic> json){
    return MessageModel(
      chatId: json["chatId"] ?? "", 
      senderId: json["senderId"], 
      receiverId: json["receiverId"], 
      cipherTextForSender: json["cipherTextForSender"], 
      cipherTextForReceiver: json["cipherTextForReceiver"],
      timeStamp: json["timeStamp"].toString(),
      statusCode: json["status"] ?? "delivered",  // ✅ Parse from backend
      edited: json["edited"] ?? false              // ✅ Parse from backend
    );
  }
}