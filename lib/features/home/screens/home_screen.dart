import 'package:flutter/material.dart';
import 'package:message/core/controllers/socket_controller.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/home/controllers/home_screen_controller.dart';
import 'package:message/features/home/screens/add_friends.dart';
import 'package:message/features/home/models/chat_list_model.dart';
import 'package:message/features/home/services/chat_navigation_service.dart';
import 'package:message/features/home/state/home_screen_state.dart';
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
    final homeController = context.read<HomeScreenController>();
    context.read<SocketController>();
    Future.microtask(() async{
        await homeController.fetchChats();
      if (!mounted) return;
        await homeController.initSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<HomeScreenState>();
    final request = homeState.pendingChatRequest;

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
            if (request != null) _buildMessageRequest(request),
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

  Widget _buildMessageRequest(Map<String, dynamic> request) {
    final sender = request['sender'] is Map
        ? Map<String, dynamic>.from(request['sender'])
        : <String, dynamic>{};
    final senderName = sender['userName']?.toString() ?? 'Someone';
    final chatId = request['chatId']?.toString();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$senderName sent you a message', style: AppTypography.titleSm),
          const SizedBox(height: 4),
          const Text('Accept the request to continue the conversation.'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: chatId == null ? null : () => _blockRequest(chatId),
                icon: const Icon(Icons.block),
                label: const Text('Block'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: chatId == null ? null : () => _acceptRequest(request),
                icon: const Icon(Icons.chat_outlined),
                label: const Text('Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _acceptRequest(Map<String, dynamic> request) async {
    final chatId = request['chatId']?.toString();
    final sender = request['sender'] is Map
        ? Map<String, dynamic>.from(request['sender'])
        : <String, dynamic>{};
    if (chatId == null) return;

    final accepted = await context.read<HomeScreenController>().acceptChat(chatId);
    if (!mounted || !accepted) return;

    context.read<HomeScreenState>().clearPendingChatRequest();
    final chat = ChatModel(
      chatId,
      sender['userName']?.toString() ?? 'Unknown user',
      sender['profilePic']?.toString() ?? '',
      sender['id']?.toString() ?? '',
      request['preview']?.toString() ?? '',
      DateTime.tryParse(request['lastUpdate']?.toString() ?? ''),
    );
    openChat(context, chat);
  }

  Future<void> _blockRequest(String chatId) async {
    final blocked = await context.read<HomeScreenController>().blockChat(chatId);
    if (mounted && blocked) {
      context.read<HomeScreenState>().clearPendingChatRequest();
    }
  }
}
