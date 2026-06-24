import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/home/widgets/chat_builder.dart';
import 'package:message/features/home/widgets/search_bar_builder.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shadowColor: Colors.black,
            title: Text(
                "Message",
                style: AppTypography.headlineXl
            ),
        ),
        drawer: Drawer(),
        body: Column(
            children: [
                SearchBarBuilder(),
                ChatBuilder(),
            ],
        )
    );
  }
}
