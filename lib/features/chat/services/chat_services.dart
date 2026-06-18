// import 'dart:convert';

// import 'package:message/core/models/api_response.dart';
// import 'package:message/core/services/api.dart';
// import 'package:message/core/storage_services/secure_storage_service.dart';
// import 'package:message/features/chat/models/chat_model.dart';

// class ChatServices {
//   Future<ApiResponse<List<MessageModel>>> fetchChatByChatId(String chatId) async{
//     final String? jwt = await StorageService().loadJwt();
//     final response = await Api.get("/chats/by-chat/$chatId", headers: {"Authorization": "Bearer $jwt"});
//     Map<String, dynamic> data = jsonDecode(response.body);
//     dynamic messageList = data["messages"];
//     if(response.statusCode == 200 ){
//       if(data.isNotEmpty){
//         List<MessageModel> messages = messageList.map((message) => MessageModel.fromJson(message)).toList();
//         return Success(messages, data["message"] ?? "messages fetched");
//       }
//       else {
//         return Failure(data["message"]);
//       }
//     }else {
//       return Failure(data["message"]);
//     }
//   }

//   Future<ApiResponse> sendMessage(String receiverId, String plainText) async{
//     final String? jwt = await StorageService().loadJwt();
//     Map<String, dynamic> body = {
//       "text": plainText,
//       "date": DateTime.now().toIso8601String()  // ✅ Convert to ISO string
//     };
//     final response = await Api.post("/message/send/$receiverId", body, headers: {"authorization": "Bearer $jwt"});  // ✅ Fixed path
//     if(response.statusCode == 201){
//         Map<String, dynamic> data = json.decode(response.body);
//         return Success(data['messageDoc'], data['message']);
//     } else {  // ✅ Added error handling
//         try {
//             Map<String, dynamic> data = json.decode(response.body);
//             return Failure(data['message'] ?? 'Failed to send message');
//         } catch(e) {
//             return Failure('Network error or invalid response');
//         }
//     }
//   }

// }