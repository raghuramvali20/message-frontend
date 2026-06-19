import 'package:flutter/material.dart';
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

    @override
  void initState() {
    super.initState();
    Future.microtask((){
        context.read<ChatListController>().fetchChats();
  });
  }

    @override
Widget build(BuildContext context) {
  final chats = context.watch<ChatListController>();

  if (chats.loading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (chats.error != null) {
        SnackBarHelper.showError(context, chats.error!);
  }

  if (chats.chatList == null || chats.chatList!.isEmpty) {
    return const Center(child: Text("No chats available"));
  }

  return Expanded(
    child: ListView.builder(
      itemCount: chats.chatList!.length,
      itemBuilder: (context, index) {
        final chat = chats.chatList![index];
        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(chat.profilePic),
          ),
          title: Text(chat.chatUserName, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(chat.previewChat),
          trailing: Text(
            chat.time.toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          onTap: () {
            debugPrint("Open chat with ${chat.chatUserName}");
            Navigator.pushNamed(
                context, 
                ChatScreen.routeName,
                arguments: ChatArguments(chat.chatId, chat.chatUserId, chat.chatUserName, chat.profilePic)
                );
          },
        );
      },
    ),
  );
}

}