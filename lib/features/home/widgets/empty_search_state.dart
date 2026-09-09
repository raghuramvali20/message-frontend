import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';

class EmptySearchState extends StatelessWidget {
  final bool hasQuery;

  const EmptySearchState({super.key, required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        hasQuery ? 'No users found' : 'Search for a username to find people',
        style: AppTypography.bodyMd,
        textAlign: TextAlign.center,
      ),
    );
  }
}