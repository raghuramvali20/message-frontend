import 'package:message/core/models/api_response.dart';
import 'package:message/features/chat/models/message_model.dart';

abstract class ChatServices{
    Future<ApiResponse<List<MessageModel>>> getChatsByChatId(String chatId);
    Future<ApiResponse<MessageModel>> sendMessage(String message, String receiverId, String chatId);
}