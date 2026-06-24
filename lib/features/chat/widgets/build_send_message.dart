import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/chat/controllers/chat_controller.dart';
import 'package:provider/provider.dart';

class BuildSendMessage extends StatefulWidget {
  final String chatId;
  final String receiverId;
  BuildSendMessage({Key? key, required this.chatId, required this.receiverId})
    : super(key: key);

  @override
  State<BuildSendMessage> createState() => _BuildSendMessageState();
}

class _BuildSendMessageState extends State<BuildSendMessage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _chatController = context.watch<ChatController>();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                color: AppColors.background,
                icon: const Icon(Icons.send),
                onPressed: () {
                  _chatController.sendMessage(
                    _controller.text,
                    widget.chatId,
                    widget.receiverId,
                  );
                  print("Message: ${_controller.text}");
                  _controller.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
