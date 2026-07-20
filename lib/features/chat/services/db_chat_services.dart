import 'dart:convert';
import 'package:message/core/models/api_response.dart';
import 'package:message/core/services/api.dart';
import 'package:message/core/storage_services/app_storage_services.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:message/features/chat/services/chat_services.dart';

class DbChatServices implements ChatServices{
    @override
  Future<ApiResponse<List<MessageModel>>> getChatsByChatId(String chatId) async{

    String? token = await AppStorageService().loadToken(); 

    final response = await ApiMethods.get("/chats/by-chat/$chatId", headers: {"token": "Bearer $token"});
    if(response.statusCode == 200){
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> messagesFromResponse = body["messages"];
        List<MessageModel> messages = messagesFromResponse.map((m) => MessageModel.fromJson(m)) as List;
    }
  }
}