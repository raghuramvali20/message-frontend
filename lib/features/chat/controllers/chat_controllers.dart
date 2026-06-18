import 'package:message/core/models/api_response.dart';
import 'package:message/core/storage_services/hive_db.dart';
import 'package:message/core/utils/rsa_helper.dart';
import 'package:message/features/chat/models/chat_model.dart';
import 'package:message/features/chat/models/plain_message_model.dart';
import 'package:message/features/chat/services/chat_services.dart';

class ChatControllers {
  Future<List<PlainMessageModel>> loadChat(String chatId) async {
    final response = await ChatServices().fetchChatByChatId(chatId);

    if (response is Success<List<MessageModel>>) {
      final encryptedMessages = response.data;

      final plainMessages = await Future.wait(
        encryptedMessages.map((encryptedMessage) async {
          final plainText = await _decryptMessage(
            encryptedMessage.cipherTextForReceiver,
            encryptedMessage.cipherTextForSender,
            encryptedMessage.senderId,
            encryptedMessage.receiverId,
          );

          return PlainMessageModel(
            chatId: encryptedMessage.chatId,
            plainTextMessage: plainText,
            senderId: encryptedMessage.senderId,
            receiverId: encryptedMessage.receiverId,
            timeStamp: encryptedMessage.timeStamp,
          );
        }),
      );

      return plainMessages;
    }

    return [];
  }

  Future<ApiResponse> sendMessage(String receiverId, String plainText) async {
    return await ChatServices().sendMessage(receiverId, plainText);
  }

  Future<String> _decryptMessage(
    String cipherTextForReceiver,
    String cipherTextForSender,
    String senderId,
    String receiverId,
  ) async {
    final user = await HiveDB().getUserData();

    if (user?.id == senderId) {
      return await RsaHelper().decryptBase64(cipherTextForSender);
    } else if (user?.id == receiverId) {
      return await RsaHelper().decryptBase64(cipherTextForReceiver);
    }

    return "";
  }
}