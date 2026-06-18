import 'package:flutter/material.dart';
import 'package:message/core/models/api_response.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/core/constants/app_constants.dart';
import 'package:message/core/widgets/snack_bar_helper.dart';
import 'package:message/core/providers/app_state_provider.dart';
import 'package:message/features/auth/screens/login_screen.dart';
import 'package:message/features/home/controllers/list_tiles_controller.dart';
import 'package:message/features/home/models/chat_list_model.dart';
import 'package:message/features/home/widgets/home_screen_widgets.dart';
import 'package:message/features/chat/controllers/chat_controllers.dart';
import 'package:message/core/widgets/my_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = AppConstants.routeHome;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatList> chats = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final user = AppStateProvider().currentUser;
    if (user == null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      });
    } else {
      await _fetchChats();
    }
  }

  Future<void> _fetchChats() async {
    setState(() => isLoading = true);
    try {
      final response = await ListTilesController().fetchChatTileItems();
      if (!mounted) return;
      if (response is Failure<List<ChatList>>) {
        SnackBarHelper.showError(context, response.message);
      } else if (response is Success<List<ChatList>>) {
        setState(() => chats = response.data);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Failed to load chats');
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _showNewMessageDialog() async {
    final receiverController = TextEditingController();
    final messageController = TextEditingController();

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New message'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: receiverController,
                  decoration: const InputDecoration(
                    labelText: 'Receiver ID',
                    hintText: 'Enter the receiver user id',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: messageController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    hintText: 'Type your message',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final receiverId = receiverController.text.trim();
                final messageText = messageController.text.trim();
                if (receiverId.isEmpty || messageText.isEmpty) {
                  SnackBarHelper.showError(
                    context,
                    'Receiver ID and message are required',
                  );
                  return;
                }

                Navigator.of(context).pop();
                final result = await ChatControllers()
                    .sendMessage(receiverId, messageText);
                if (!mounted) return;

                if (result is Success) {
                  SnackBarHelper.showSuccess(context, 'Message sent');
                  await _fetchChats();
                } else if (result is Failure) {
                  SnackBarHelper.showError(context, result.message);
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: AppTypography.headlineMd,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(
              context,
              AppConstants.routeProfile,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(
              context,
              AppConstants.routeSettings,
            ),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search chats...',
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusXl),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : chats.isEmpty
                    ? const Center(
                        child: Text('No chats yet. Start a new conversation!'),
                      )
                    : _buildChatList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewMessageDialog,
        tooltip: 'Message a new person',
        child: const Icon(Icons.message),
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: chat.profilePic.isNotEmpty
                    ? NetworkImage(chat.profilePic)
                    : null,
                child: chat.profilePic.isEmpty
                    ? Text(
                        chat.userName.isNotEmpty
                            ? chat.userName[0].toUpperCase()
                            : '?',
                        style: AppTypography.titleMd,
                      )
                    : null,
              ),
              title: Text(
                chat.userName.isNotEmpty ? chat.userName : 'Unknown',
                style: AppTypography.titleSm,
              ),
              subtitle: const Text('Tap to open chat'),
              onTap: () => Navigator.pushNamed(
                context,
                AppConstants.routeChat,
                arguments: chat,
              ),
            ),
          ),
        );
      },
    );
  }
}

