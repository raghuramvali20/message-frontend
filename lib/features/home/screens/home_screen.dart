import 'package:flutter/material.dart';
import 'package:message/core/controllers/socket_controller.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/home/controllers/home_screen_controller.dart';
import 'package:message/features/home/screens/add_friends.dart';
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
    Future.microtask(() async{
        await context.read<HomeScreenController>().fetchChats();
        await context.read<HomeScreenController>().initSocket();
        context.read<SocketController>();
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
                Expanded(child: ChatBuilder())
            ],
        ),
        floatingActionButton: Container(
            padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: AppColors.primary,
          ),
            child: IconButton(onPressed: (){Navigator.pushNamed(context, AddFriends.routeName);}, icon: Icon(Icons.add, color: AppColors.background,))
            ),
    );
  }
}
