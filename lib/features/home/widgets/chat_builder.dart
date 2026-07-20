import 'package:flutter/material.dart';
import 'package:message/core/widgets/snack_bar_helper.dart';
import 'package:message/features/chat/models/chat_arguments.dart';
import 'package:message/features/chat/screens/chat_screen.dart';
import 'package:message/features/home/controllers/home_screen_controller.dart';
import 'package:message/features/home/widgets/chat_tile_builder.dart';
import 'package:provider/provider.dart';

class ChatBuilder extends StatefulWidget {
  const ChatBuilder({super.key});

  @override
  State<ChatBuilder> createState() => _ChatBuilderState();
}

class _ChatBuilderState extends State<ChatBuilder> {
  bool _hasShownError = false;
  final Set<String> _selectedChats = {}; // track selected chatIds

  @override
  void initState() {
    super.initState();
    // Future.microtask(() {
    //   context.read<ChatListController>().fetchChats();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final chats = context.watch<HomeScreenController>();
    final readChats = chats.readChatList ?? [];
    final unreadChats = chats.unreadChatList ?? [];

    if (chats.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chats.error != null && !_hasShownError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackBarHelper.showError(context, chats.error!);
      });
      _hasShownError = true;
    } else if (chats.error == null) {
      _hasShownError = false;
    }

    if (readChats.isEmpty && unreadChats.isEmpty) {
      return const Center(child: Text("No chats available"));
    }

    final totalChats = unreadChats.length + readChats.length;

    return Expanded(
      child: ListView.builder(
        itemCount: totalChats,
        itemBuilder: (context, index) {
          final isUnread = index < unreadChats.length;
          final chat = isUnread
              ? unreadChats[index]
              : readChats[index - unreadChats.length];

          return ChatTile(
            chat: chat,
            isUnread: isUnread,
            onTap: () {
              debugPrint("Open chat with ${chat.chatUserName}");
              Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: ChatArguments(
                  chat.chatId,
                  chat.chatUserId,
                  chat.chatUserName,
                  chat.profilePic,
                ),
              );
            },
            onLongPress: () {
              print("long pressed ${chat.chatId}");
            }
          );
        },
      ),
    );
  }
}
