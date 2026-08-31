import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/chat/models/message_model.dart';
import 'package:message/features/chat/state/chat_screen_state.dart';
import 'package:provider/provider.dart';

class BuildMessages extends StatefulWidget {
  final String chatId;
  const BuildMessages({Key? key, required this.chatId}) : super(key: key);

  @override
  State<BuildMessages> createState() => _BuildMessagesState();
}

class _BuildMessagesState extends State<BuildMessages> {

  @override
  void initState() {
    super.initState();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message.messageText, style: AppTypography.bodyLg),
            SizedBox(height: 4),
            Text(
              message.formattedTime ?? "",
              style: AppTypography.bodySm.copyWith(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(MessageModel message) {
    if(mounted){
        message.statusCode = StatusCode.seen;
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.messageText, style: AppTypography.bodyLg),
            SizedBox(height: 4),
            Text(
              message.formattedTime ?? "",
              style: AppTypography.bodySm.copyWith(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(String date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          date,
          style: AppTypography.bodySm,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payload = context.watch<ChatScreenState>();

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        reverse: true,
        itemCount: payload.messages.length,
        itemBuilder: (context, index) {
          final message = payload.messages[payload.messages.length - 1 - index];
          final isSentByMe = payload.user?.id == message.senderId;

          // Insert date separator when date changes
          final showDateSeparator = payload.messages.length - 1 - index == 0 ||
              message.formattedDate !=
                  payload.messages[payload.messages.length - index - 2].formattedDate;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showDateSeparator && message.formattedDate != null)
                _buildDateSeparator(message.formattedDate!),
              isSentByMe
                  ? _buildSentMessage(message)
                  : _buildReceivedMessage(message),
            ],
          );
        },
      ),
    );
  }
}
