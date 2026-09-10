import 'dart:convert';

import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/services/api.dart';
import 'package:message/core/storage_services/app_storage_services.dart';
import 'package:message/features/home/models/chat_list_model.dart';
import 'package:message/features/home/services/chat_list_service.dart';

class DbChatListServices implements ChatListService {
  @override
  Future<ApiResponse<List<ChatModel>>> fetchChats(String userId) async {
    User? user = await AppStorageService().loadUser();
    String? token = await AppStorageService().loadToken();
    final response = await ApiMethods.get(
      "/chats/by-user/${user?.id}",
      headers: {"Authorization": "Bearer $token"},
    );

    final body = jsonDecode(response.body);
    List<dynamic> data = body["chatList"];

    if (response.statusCode == 200) {
      List<ChatModel> result = data
          .map((chat) => ChatModel.fromJson(chat))
          .toList();
      return SuccessResponse<List<ChatModel>>(result);
    } else {
      return FailureResponse<List<ChatModel>>(
        body["serverMessage"] ?? body["message"] ?? "Unable to load chats",
      );
    }
  }

  @override
  Future<ApiResponse<ChatModel>> ensureChat(String userId) async {
    final token = await AppStorageService().loadToken();
    final response = await ApiMethods.post(
      "/chats/with/$userId",
      {},
      headers: {"Authorization": "Bearer $token"},
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SuccessResponse<ChatModel>(ChatModel.fromJson(body["chat"]));
    }

    return FailureResponse<ChatModel>(
      body["serverMessage"] ?? body["message"] ?? "Unable to open chat",
    );
  }

  @override
  Future<ApiResponse<bool>> acceptChat(String chatId) async {
    return _decideChat(chatId, 'accept');
  }

  @override
  Future<ApiResponse<bool>> blockChat(String chatId) async {
    return _decideChat(chatId, 'block');
  }

  Future<ApiResponse<bool>> _decideChat(String chatId, String action) async {
    final token = await AppStorageService().loadToken();
    final response = await ApiMethods.post(
      "/chats/$chatId/$action",
      {},
      headers: {"Authorization": "Bearer $token"},
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SuccessResponse<bool>(true);
    }

    return FailureResponse<bool>(
      body["serverMessage"] ?? body["message"] ?? "Unable to update chat",
    );
  }
}
