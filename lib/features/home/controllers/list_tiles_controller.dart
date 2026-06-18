import 'package:message/core/models/api_response.dart';
import 'package:message/features/home/models/chat_list_model.dart';
import 'package:message/features/home/services/chat_list_service.dart';

class ListTilesController {
  Future<ApiResponse<List<ChatList>>> fetchChatTileItems() async{
    final response = await ChatListService().getChatsByUserId();
    return response;
  }
}