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

    final body = jsonDecode(response.body);
    final List<dynamic> messagesFromResponse = body["messages"];

    if(response.statusCode == 200){
        List<MessageModel> messages = messagesFromResponse.map((m) => MessageModel.fromJson(m)).toList();
        return SuccessResponse<List<MessageModel>>(messages);
    }else{
        return FailureResponse(body["serverMessage"]);
    }
  }
}