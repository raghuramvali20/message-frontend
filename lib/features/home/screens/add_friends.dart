import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddFriends extends StatefulWidget {   
    static final String routeName = "add-friends-screen";
  const AddFriends({super.key});

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Add Friend")),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Enter user name to add",
                            suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.search))
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 100,
                          itemBuilder:(context, index) {
                              return Card(
                                child: ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text("Naveen nallarammoorthi ${index+1}"),
                                    subtitle: Text("Pilla Koti"),
                                ),
                              );
                        },),
                      )
                  ],
              ),
            ),
    );
  }
}