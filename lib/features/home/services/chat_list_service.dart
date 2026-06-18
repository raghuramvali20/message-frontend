import 'dart:convert';

import 'package:message/core/services/api.dart';
import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/storage_services/hive_db.dart';
import 'package:message/core/storage_services/secure_storage_service.dart';
import 'package:message/features/home/models/chat_list_model.dart';

class ChatListService{
  Future<ApiResponse<List<ChatList>>> getChatsByUserId() async {
    String? token = await StorageService().loadJwt();
    if(token == "" || token == null){
      return Failure("Authentication failed");
    }
    User? user = await HiveDB().getUserData();
    if(user != null && user.id != ""){
      final response  = await Api.get("/chats/by-user/${user.id}", headers: {"Authorization" : "Bearer $token"});
      Map<String, dynamic> data = jsonDecode(response.body);
      if(!data['chatList'].isEmpty){
        List<ChatList> chatLists = (data["chatList"] as List).map((chatListItem) => ChatList.fromJson(chatListItem)).toList();
        return Success<List<ChatList>>(chatLists, data["message"]);
      }
      return Success([], data["message"] ?? "No chats");
      }
      return Failure("No user data available to search");
  }
}