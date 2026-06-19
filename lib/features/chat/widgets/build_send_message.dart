import 'package:flutter/material.dart';

class BuildSendMessage extends StatefulWidget {
  const BuildSendMessage({super.key});

  @override
  State<BuildSendMessage> createState() => _BuildSendMessageState();
}

class _BuildSendMessageState extends State<BuildSendMessage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded( // ✅ only the TextField expands
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // handle send
              print("Message: ${_controller.text}");
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
