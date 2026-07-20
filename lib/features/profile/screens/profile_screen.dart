import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
    static final String routeName = "profile-screen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Profile"),
            elevation: 0,
        ),
        body: Container(
            width: double.infinity,
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                    SizedBox(height: 30),
                    Column(
                      children: [
                        ClipRect(
                          child: CircleAvatar(
                              radius: 75,
                              backgroundImage: NetworkImage("https://tse2.mm.bing.net/th/id/OIP.7M38MNjxmTr0STEo5j_Z_wHaIs?r=0&rs=1&pid=ImgDetMain&o=7&rm=3"),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text("Raghu Ram", style: AppTypography.headlineLg,),
                        SizedBox(height: 8),
                        Text("@raghuram", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            children: [
                                Card(
                                  child: ListTile(
                                      leading: Icon(Icons.person, color: AppColors.primary),
                                      title: Text("User Name"),
                                      subtitle: Text("Raghu Ram"),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                      leading: Icon(Icons.email, color: AppColors.primary),
                                      title: Text("Email"),
                                      subtitle: Text("raghu@gmail.com"),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text("Edit Profile", style: TextStyle(color: Colors.white, fontSize: 16)),
                                  ),
                                )
                            ],
                        ),
                      ),
                    )
                ]
              ),
            )
        ),
    );
  }
}