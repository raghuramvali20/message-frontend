import 'package:flutter/material.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/home/controllers/home_screen_controller.dart';
import 'package:message/features/home/services/chat_navigation_service.dart';
import 'package:provider/provider.dart';

class UserResultTile extends StatelessWidget {
  final User user;

  const UserResultTile({super.key, required this.user});

  Future<void> _onTap(BuildContext context) async {
    final chat = await context.read<HomeScreenController>().ensureChatForUser(
      user,
    );
    if (context.mounted && chat != null) {
      openChat(context, chat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _onTap(context),
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(user.userName, style: AppTypography.titleSm),
          subtitle: Text(user.email, style: AppTypography.bodySm),
        ),
      ),
    );
  }
}
