import 'package:flutter/material.dart';
import 'package:message/features/chat/screens/chat_screen.dart';
import 'package:message/features/home/models/chat_list_model.dart';

class HomeScreenWidgets {
  ListView buildListTile(List<ChatList> chats) {
    return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final tile = chats[index];
                    final name = (tile.userName).toString();
                    final avatarImage = tile.profilePic;
                    final subtitle = "Tap to open chat";
                    final time = DateTime.now().toString();
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: avatarImage.isNotEmpty
                            ? NetworkImage(avatarImage)
                            : null,
                        child: avatarImage.isEmpty
                            ? Text(name.isNotEmpty ? name[0].toUpperCase() : "?")
                            : null,
                      ),
                      title: Text(name,
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(subtitle),
                      trailing: Text(time,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      onTap: () {
                        debugPrint("Open chat with $name");
                        Navigator.pushNamed(context, ChatScreen.routeName,
                            arguments: tile);
                      },
                    );
                  },
                );
  }

  Widget buildSearchBar() {
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              focusColor: Colors.transparent,
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              hintText: "Search",
            ),
          ),
        );
  }
}