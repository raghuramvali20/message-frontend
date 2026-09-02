import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/home/models/chat_list_model.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chat;
  final bool isUnread;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ChatTile({
    super.key,
    required this.chat,
    required this.isUnread,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final timeLabel = chat.formattedDate ?? chat.displayLabel ?? 'Recently';

    return Card(
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(chat.profilePic),
          ),
          title: Text(chat.chatUserName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(chat.previewChat),
          trailing: isUnread
              ? _UnreadBadge(
                  time: chat.formattedTime ?? 'Now',
                  dateLabel: timeLabel,
                )
              : Text(
                  timeLabel,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final String time;
  final String dateLabel;

  const _UnreadBadge({required this.time, required this.dateLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$dateLabel $time',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
