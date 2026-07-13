import 'dart:convert';

import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/services/api.dart';
import 'package:message/core/storage_services/app_storage_services.dart';
import 'package:message/features/home/models/chat_list_model.dart';
import 'package:message/features/home/services/chat_list_service.dart';

class DbChatListServices implements ChatListService{
    @override
    Future<ApiResponse<List<ChatModel>>> fetchChats(String userId) async{
        User? user = await AppStorageService().loadUser();
        String? token = await AppStorageService().loadToken();
        final response = await ApiMethods.get("/chats/by-user/${user?.id}", headers: {"Authorization": "Bearer $token"});

        print(response.body+" hellowwwwwwwwwwwwww");

        final body = jsonDecode(response.body);
        List<dynamic> data = body["chatList"];

        if(response.statusCode == 200){
            List<ChatModel> result = data.map((chat) => ChatModel.fromJson(chat)).toList();
            return SuccessResponse<List<ChatModel>>(result);
        }else {
            print(body["serverMessage"]);
            return FailureResponse<List<ChatModel>>(body["serverMessage"]);
        }
  }
}