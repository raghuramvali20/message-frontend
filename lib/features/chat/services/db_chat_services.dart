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
    final response = await ApiMethods.get("/chats/by-chat/$chatId", headers: {"Authorization": "Bearer $token"});

    final body = jsonDecode(response.body);
    

    if(response.statusCode == 200){
        final messagesFromResponse = body["messages"] as List<dynamic>? ?? [];

        List<MessageModel> messages = messagesFromResponse.map((m) => MessageModel.fromJson(m)).toList();
        return SuccessResponse<List<MessageModel>>(messages);
    }else{
        return FailureResponse(body["serverMessage"]);
    }
  }

  Future<ApiResponse<MessageModel>> sendMessage(String message, String receiverId, String chatId)async{

    String? token = await AppStorageService().loadToken();
    Map<String, dynamic> body = {
        "messageText" : message,
        "time": DateTime.now().toUtc().toIso8601String()
    };
    final response = await ApiMethods.post("/message/send/$receiverId", body, headers: {"Authorization": "Bearer $token"});
    print(response.body);
    final result = jsonDecode(response.body);
    if(response.statusCode == 201){
        return SuccessResponse<MessageModel>(MessageModel.fromJson(result["messageDoc"]));
    }else{
        return FailureResponse(result["serverMessage"]);
    }
    
  }
}