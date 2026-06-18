// import 'package:flutter/material.dart';
// import 'package:message/core/models/api_response.dart';
// import 'package:message/core/theme/app_theme.dart';
// import 'package:message/core/constants/app_constants.dart';
// import 'package:message/core/widgets/snack_bar_helper.dart';
// import 'package:message/core/widgets/app_loading_error_widgets.dart';
// import 'package:message/features/chat/controllers/chat_controllers.dart';
// import 'package:message/features/chat/models/plain_message_model.dart';
// import 'package:message/features/home/models/chat_list_model.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});
//   static const String routeName = AppConstants.routeChat;

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   late ChatList chatInfo;
//   List<PlainMessageModel> plainMessages = [];
//   bool _initialized = false;
//   bool _isLoading = false;
//   String? _errorMessage;
//   final TextEditingController _messageController = TextEditingController();
//   bool _isSending = false;

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       final args = ModalRoute.of(context)!.settings.arguments;
//       if (args is ChatList) {
//         chatInfo = args;
//         _fetchMessages();
//       } else {
//         chatInfo = ChatList('', 'Unknown', '', '');
//         _errorMessage = 'Invalid chat data';
//       }
//       _initialized = true;
//     }
//   }

//   Future<void> _fetchMessages() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final messages = await ChatControllers().loadChat(chatInfo.chatId);
//       if (!mounted) return;
//       setState(() {
//         plainMessages = messages;
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _sendMessage() async {
//     final text = _messageController.text.trim();
//     if (text.isEmpty) return;

//     setState(() => _isSending = true);

//     try {
//       final response =
//           await ChatControllers().sendMessage(chatInfo.receiverId, text);

//       if (!mounted) return;
//       setState(() => _isSending = false);

//       if (response is Success) {
//         _messageController.clear();
//         final plainMessage = PlainMessageModel(
//           chatId: chatInfo.chatId,
//           plainTextMessage: text,
//           senderId: '',
//           receiverId: chatInfo.receiverId,
//           timeStamp: DateTime.now().toIso8601String(),
//         );
//         // setState(() {
//           plainMessages.add(plainMessage);
//         });
//         SnackBarHelper.showSuccess(context, 'message sent');
//       } else if (response is Failure) {
//         SnackBarHelper.showError(context, response.message);
//       }
//     } catch (e) {
//       if (!mounted) return;
//       SnackBarHelper.showError(context, 'Failed to send message');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(chatInfo.userName.isNotEmpty ? chatInfo.userName : 'Chat'),
//       ),
//       body: Column(
//         children: [
//           // Messages List
//           Expanded(
//             child: _isLoading
//                 ? const AppLoadingWidget(message: 'Loading messages...')
//                 : _errorMessage != null
//                     ? AppErrorWidget(
//                         title: 'Error',
//                         message: _errorMessage ?? 'Failed to load messages',
//                         onRetry: _fetchMessages,
//                       )
//                     : plainMessages.isEmpty
//                         ? const AppEmptyWidget(
//                             title: 'No messages',
//                             message: 'Start a conversation',
//                           )
//                         : _buildMessagesList(),
//           ),

//           // Message Input
//           Container(
//             decoration: BoxDecoration(
//               color: AppColors.surface,
//               border: Border(
//                 top: BorderSide(
//                   color: AppColors.border,
//                   width: 1,
//                 ),
//               ),
//             ),
//             padding: const EdgeInsets.symmetric(
//               horizontal: AppSpacing.md,
//               vertical: AppSpacing.md,
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type a message...',
//                     ),
//                     minLines: 1,
//                     maxLines: 4,
//                     enabled: !_isSending,
//                   ),
//                 ),
//                 const SizedBox(width: AppSpacing.md),
//                 FloatingActionButton(
//                   onPressed: _isSending ? null : _sendMessage,
//                   mini: true,
//                   child: _isSending
//                       ? const SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor:
//                                 AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : const Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessagesList() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(AppSpacing.md),
//       itemCount: plainMessages.length,
//       itemBuilder: (context, index) {
//         final message = plainMessages[index];
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
//           child: Container(
//             padding: const EdgeInsets.all(AppSpacing.md),
//             decoration: BoxDecoration(
//               color: AppColors.surfaceVariant,
//               borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   message.plainTextMessage,
//                   style: AppTypography.bodyMd,
//                 ),
//                 const SizedBox(height: AppSpacing.xs),
//                 Text(
//                   _formatTime(message.timeStamp),
//                   style: AppTypography.bodySm.copyWith(
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatTime(String timestamp) {
//     try {
//       final dateTime = DateTime.parse(timestamp);
//       final now = DateTime.now();
//       final difference = now.difference(dateTime);

//       if (difference.inMinutes < 1) {
//         return 'just now';
//       } else if (difference.inHours < 1) {
//         return '${difference.inMinutes}m ago';
//       } else if (difference.inDays < 1) {
//         return '${difference.inHours}h ago';
//       } else {
//         return dateTime.toString().split(' ')[0];
//       }
//     } catch (e) {
//       return 'unknown';
//     }
//   }
// }


 