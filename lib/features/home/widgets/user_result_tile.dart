import 'package:flutter/material.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/theme/app_theme.dart';

class UserResultTile extends StatelessWidget {
  final User user;

  const UserResultTile({super.key, required this.user});

  void onTap(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(user.userName, style: AppTypography.titleSm),
          subtitle: Text(user.email, style: AppTypography.bodySm),
        ),
      ),
    );
  }
}