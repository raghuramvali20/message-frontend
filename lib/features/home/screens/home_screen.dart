import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/home/controllers/chat_list_controller.dart';
import 'package:message/features/home/widgets/build_drawer.dart';
import 'package:message/features/home/widgets/chat_builder.dart';
import 'package:message/features/home/widgets/search_bar_builder.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


    @override
  void initState() {
    super.initState();
    Future.microtask((){
        context.read<ChatListController>().fetchChats();
    });
  }

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
        drawer: BuildDrawer(),
        body: Column(
            children: [
                const SearchBarBuilder(),
                const Expanded(child: ChatBuilder()),
            ],
        ),
        floatingActionButton: IconButton(onPressed: (){}, icon: Icon(Icons.add)),
    );
  }
}
