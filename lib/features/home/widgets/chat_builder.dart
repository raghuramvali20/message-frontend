import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/core/widgets/snack_bar_helper.dart';
import 'package:message/features/chat/models/chat_arguments.dart';
import 'package:message/features/chat/screens/chat_screen.dart';
import 'package:message/features/home/controllers/chat_list_controller.dart';
import 'package:provider/provider.dart';

class ChatBuilder extends StatefulWidget {
  const ChatBuilder({super.key});

  @override
  State<ChatBuilder> createState() => _ChatBuilderState();
}

class _ChatBuilderState extends State<ChatBuilder> {
  bool _hasShownError = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ChatListController>().fetchChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chats = context.watch<ChatListController>();
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

          return InkWell(
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
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(chat.profilePic),
              ),
              title: Text(
                chat.chatUserName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(chat.previewChat),
              trailing: isUnread
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chat.unreadMessages?.toString() ?? '0',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat.time.toString(),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    )
                  : Text(
                      chat.time.toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
            ),
          );
        },
      ),
    );
  }
}
