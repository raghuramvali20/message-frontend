import 'package:message/core/models/api_response.dart';
import 'package:message/features/home/models/chat_list_model.dart';
import 'package:message/features/home/services/chat_list_service.dart';

class FakeChatListService implements ChatListService{
    @override
    Future<ApiResponse<List<ChatModel>>> fetchChats(String userId) async{
        await Future.delayed(Duration(milliseconds: 200));
        if(userId == "userId"){
            return SuccessResponse(
                List.of([
                     ChatModel("chatId1", "chatUser2", "https://i.pinimg.com/236x/b4/07/9b/b4079bd8f8b8b1272f4c66f420a5fe07.jpg", "chatUserId1", "hello", DateTime.now()),
                     ChatModel("chatId2", "chatUser3", "https://i.pinimg.com/236x/b4/07/9b/b4079bd8f8b8b1272f4c66f420a5fe07.jpg", "chatUserId2", "hello", DateTime.now()),
                     ChatModel("chatId3", "chatUser4", "https://i.pinimg.com/236x/b4/07/9b/b4079bd8f8b8b1272f4c66f420a5fe07.jpg", "chatUserId3", "hello", DateTime.now()),
                     ChatModel("chatId4", "chatUser5", "https://i.pinimg.com/236x/b4/07/9b/b4079bd8f8b8b1272f4c66f420a5fe07.jpg", "chatUserId4", "hello", DateTime.now()),
                     ChatModel("chatId5", "chatUser6", "https://i.pinimg.com/236x/b4/07/9b/b4079bd8f8b8b1272f4c66f420a5fe07.jpg", "chatUserId5", "hello", DateTime.now()),
                     ChatModel("chatId6", "chatUser7", "https://i.pinimg.com/236x/b4/07/9b/b4079bd8f8b8b1272f4c66f420a5fe07.jpg", "chatUserId6", "hello", DateTime.now()),
                     ChatModel("chatId7", "chatUser8", "https://i.pinimg.com/236x/b4/07/9b/b4079bd8f8b8b1272f4c66f420a5fe07.jpg", "chatUserId7", "hello", DateTime.now()),
                     ChatModel("chatId8", "chatUser9", "https://i.pinimg.com/236x/b4/07/9b/b4079bd8f8b8b1272f4c66f420a5fe07.jpg", "chatUserId8", "hello", DateTime.now()),
                ])
            );
        }else {
            return FailureResponse("No chats");
        }
    }
}