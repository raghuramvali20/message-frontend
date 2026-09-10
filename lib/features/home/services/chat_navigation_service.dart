import 'package:flutter/material.dart';
import 'package:message/features/chat/models/chat_arguments.dart';
import 'package:message/features/chat/screens/chat_screen.dart';
import 'package:message/features/home/models/chat_list_model.dart';

void openChat(BuildContext context, ChatModel chat) {
  Navigator.pushNamed(
    context,
    ChatScreen.routeName,
    arguments: ChatArguments(
      chat.chatId,
      chat.chatUserId,
      chat.chatUserName,
      chat.profilePic,
      online: chat.online,
      lastSeen: chat.lastSeen,
    ),
  );
}
