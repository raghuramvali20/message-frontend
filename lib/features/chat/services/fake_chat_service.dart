import 'package:message/core/models/api_response.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:message/features/chat/services/chat_services.dart';

class FakeChatServices implements ChatServices{
  Future<ApiResponse<List<MessageModel>>> getChatsByChatId(String chatId) async {
    await Future.delayed(Duration(milliseconds: 200));
    if (chatId != "") {
      List<MessageModel> messages = [
  // Last year
  MessageModel(chatId: "20", senderId: "userId", receiverId: "senderId", messageText: "done", time: "2025-01-10T21:55:00.000Z"),
  MessageModel(chatId: "19", senderId: "senderId", receiverId: "userId", messageText: "later", time: "2025-02-01T07:10:00.000Z"),
  MessageModel(chatId: "18", senderId: "userId", receiverId: "senderId", messageText: "sure", time: "2025-03-15T18:25:00.000Z"),
  MessageModel(chatId: "17", senderId: "senderId", receiverId: "userId", messageText: "ping me", time: "2025-04-02T12:00:00.000Z"),
  MessageModel(chatId: "16", senderId: "userId", receiverId: "senderId", messageText: "welcome", time: "2025-05-10T15:40:00.000Z"),
  MessageModel(chatId: "15", senderId: "senderId", receiverId: "userId", messageText: "thanks", time: "2025-06-21T09:25:00.000Z"),
  MessageModel(chatId: "14", senderId: "userId", receiverId: "senderId", messageText: "take care", time: "2025-07-01T13:00:00.000Z"),
  MessageModel(chatId: "13", senderId: "senderId", receiverId: "userId", messageText: "bye", time: "2025-08-05T06:50:00.000Z"),
  MessageModel(chatId: "12", senderId: "userId", receiverId: "senderId", messageText: "see you", time: "2025-11-10T22:15:00.000Z"),
  MessageModel(chatId: "11", senderId: "senderId", receiverId: "userId", messageText: "cool", time: "2025-12-25T10:30:00.000Z"),

  // Earlier this year
  MessageModel(chatId: "10", senderId: "userId", receiverId: "senderId", messageText: "park", time: "2026-02-15T20:45:00.000Z"),
  MessageModel(chatId: "9", senderId: "senderId", receiverId: "userId", messageText: "where?", time: "2026-03-01T08:00:00.000Z"),

  // Last week
  MessageModel(chatId: "8", senderId: "userId", receiverId: "senderId", messageText: "okay", time: "2026-06-13T11:05:00.000Z"),
  MessageModel(chatId: "7", senderId: "senderId", receiverId: "userId", messageText: "let’s meet", time: "2026-06-14T16:20:00.000Z"),

  // Earlier this week
  MessageModel(chatId: "6", senderId: "userId", receiverId: "senderId", messageText: "nothing much", time: "2026-06-18T09:15:00.000Z"),
  MessageModel(chatId: "5", senderId: "senderId", receiverId: "userId", messageText: "what’s up?", time: "2026-06-19T14:00:00.000Z"),

  // Yesterday
  MessageModel(chatId: "4", senderId: "userId", receiverId: "senderId", messageText: "fine", time: "2026-06-20T19:30:00.000Z"),
  MessageModel(chatId: "3", senderId: "senderId", receiverId: "userId", messageText: "how are you?", time: "2026-06-20T18:45:00.000Z"),

  // Today
  MessageModel(chatId: "2", senderId: "userId", receiverId: "senderId", messageText: "hi", time: "2026-06-21T07:10:12.120Z"),
  MessageModel(chatId: "1", senderId: "senderId", receiverId: "userId", messageText: "hello", time: "2026-06-21T06:25:59.835Z"),
];

      return SuccessResponse(messages);
    } else {
      return FailureResponse("No messages");
    }
  }
}
