import 'dart:async';

import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/chat/controllers/chat_controller.dart';
import 'package:message/features/chat/state/chat_screen_state.dart';
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
  Timer? _typingTimer;

  @override
  void dispose() {
    _typingTimer?.cancel();
    _sendTypingEvent(false);
    _controller.dispose();
    super.dispose();
  }

  void _sendTypingEvent(bool isTyping) {
    final socketService = context.read<ChatController>().socketService;
    if (socketService.socket == null) return;
    final currentUserId = context.read<ChatScreenState>().user?.id ?? '';
    if (currentUserId.isEmpty) return;

    socketService.emitTyping(
      chatId: widget.chatId,
      senderId: currentUserId,
      receiverId: widget.receiverId,
      isTyping: isTyping,
    );
  }

  void _handleTextChanged(String value) {
    _typingTimer?.cancel();

    if (value.trim().isEmpty) {
      _sendTypingEvent(false);
      return;
    }

    _sendTypingEvent(true);
    _typingTimer = Timer(const Duration(milliseconds: 1200), () {
      _sendTypingEvent(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatController = context.watch<ChatController>();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _handleTextChanged,
              onSubmitted: (_) {
                _typingTimer?.cancel();
                _sendTypingEvent(false);
              },
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
                  if (_controller.text.trim().isEmpty) return;
                  _typingTimer?.cancel();
                  _sendTypingEvent(false);
                  chatController.sendMessage(
                    _controller.text,
                    widget.chatId,
                    widget.receiverId,
                  );
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
