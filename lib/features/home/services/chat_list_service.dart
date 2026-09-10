import 'package:message/core/models/api_response.dart';
import 'package:message/features/home/models/chat_list_model.dart';

abstract class ChatListService {
  Future<ApiResponse<List<ChatModel>>> fetchChats(String userId);
  Future<ApiResponse<ChatModel>> ensureChat(String userId);
  Future<ApiResponse<bool>> acceptChat(String chatId);
  Future<ApiResponse<bool>> blockChat(String chatId);
}
