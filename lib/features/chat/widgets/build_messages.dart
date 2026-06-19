import 'package:flutter/material.dart';
import 'package:message/features/chat/controllers/chat_controller.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:provider/provider.dart';

class BuildMessages extends StatefulWidget {
  final String chatId;
  const BuildMessages({Key? key, required this.chatId}) : super(key: key);

  @override
  State<BuildMessages> createState() => _BuildMessagesState();
}

class _BuildMessagesState extends State<BuildMessages> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ChatController>().fetchMessages(widget.chatId);
    });
  }

  @override
  void didUpdateWidget(covariant BuildMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
      // Or animate smoothly:
      // _scrollController.animateTo(
      //   _scrollController.position.maxScrollExtent,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeOut,
      // );
    }
  }

  Widget _buildSentMessage(MessageModel message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
         constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message.messageText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(MessageModel message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message.messageText,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payload = context.watch<ChatController>();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        itemCount: payload.messages?.length ?? 0,
        itemBuilder: (context, index) {
          final message = payload.messages![index];
          final isSentByMe = payload.user?.id == message.senderId;

          return isSentByMe
              ? _buildSentMessage(message)
              : _buildReceivedMessage(message);
        },
      ),
    );
  }
}
