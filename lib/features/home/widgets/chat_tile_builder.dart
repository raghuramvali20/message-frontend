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
    return InkWell(
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
            ? _UnreadBadge(count: chat.unreadMessages, time: chat.time)
            : Text(chat.time.toString(),
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int? count;
  final DateTime time;

  const _UnreadBadge({this.count, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            (count ?? 0).toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(time.toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
