import 'package:message/core/models/api_response.dart';
import 'package:message/features/chat/models/message_model.dart';

class ChatServices {
    Future<ApiResponse<List<MessageModel>>> getChatsByChatId(String chatId) async{
        await Future.delayed(Duration(milliseconds: 200));
        if(chatId != ""){
            List<MessageModel> messages = [
                MessageModel(chatId: "1", senderId: "senderId", receiverId: "userId", messageText: "hello", time: "12/02/34"),
                MessageModel(chatId: "2", senderId: "userId", receiverId: "senderId", messageText: "hi", time: "12/02/35"),
                MessageModel(chatId: "3", senderId: "senderId", receiverId: "userId", messageText: "how are you?", time: "12/02/36"),
                MessageModel(chatId: "4", senderId: "userId", receiverId: "senderId", messageText: "fine", time: "12/02/37"),
                MessageModel(chatId: "5", senderId: "senderId", receiverId: "userId", messageText: "what’s up?", time: "12/02/38"),
                MessageModel(chatId: "6", senderId: "userId", receiverId: "senderId", messageText: "nothing much", time: "12/02/39"),
                MessageModel(chatId: "7", senderId: "senderId", receiverId: "userId", messageText: "let’s meet", time: "12/02/40"),
                MessageModel(chatId: "8", senderId: "userId", receiverId: "senderId", messageText: "okay", time: "12/02/41"),
                MessageModel(chatId: "9", senderId: "senderId", receiverId: "userId", messageText: "where? afbhd hgye egrt rhet dgf htr trhbg gfgg erhthtr fggf ggf", time: "12/02/42"),
                MessageModel(chatId: "10", senderId: "userId", receiverId: "senderId", messageText: "park", time: "12/02/43"),
                MessageModel(chatId: "11", senderId: "senderId", receiverId: "userId", messageText: "cool", time: "12/02/44"),
                MessageModel(chatId: "12", senderId: "userId", receiverId: "senderId", messageText: "see you", time: "12/02/45"),
                MessageModel(chatId: "13", senderId: "senderId", receiverId: "userId", messageText: "bye", time: "12/02/46"),
                MessageModel(chatId: "14", senderId: "userId", receiverId: "senderId", messageText: "take care", time: "12/02/47"),
                MessageModel(chatId: "15", senderId: "senderId", receiverId: "userId", messageText: "thanks", time: "12/02/48"),
                MessageModel(chatId: "16", senderId: "userId", receiverId: "senderId", messageText: "welcome", time: "12/02/49"),
                MessageModel(chatId: "17", senderId: "senderId", receiverId: "userId", messageText: "ping me", time: "12/02/50"),
                MessageModel(chatId: "18", senderId: "userId", receiverId: "senderId", messageText: "sure", time: "12/02/51"),
                MessageModel(chatId: "19", senderId: "senderId", receiverId: "userId", messageText: "later", time: "12/02/52"),
                MessageModel(chatId: "20", senderId: "userId", receiverId: "senderId", messageText: "done", time: "12/02/53"),
              ];

            return SuccessResponse(messages);
        }
        else{
            return FailureResponse("No messages");
        }
    }
}