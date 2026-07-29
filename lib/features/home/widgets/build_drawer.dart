import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/home/controllers/home_screen_controller.dart';
import 'package:message/features/home/state/home_screen_state.dart';
import 'package:message/features/profile/screens/profile_screen.dart';
import 'package:message/features/settings/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class BuildDrawer extends StatefulWidget {
  const BuildDrawer({super.key});

  @override
  State<BuildDrawer> createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {

    @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<HomeScreenState>();

    return Drawer(
        child: ListView(
            children: [
                DrawerHeader(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage("https://tse2.mm.bing.net/th/id/OIP.7M38MNjxmTr0STEo5j_Z_wHaIs?r=0&rs=1&pid=ImgDetMain&o=7&rm=3"),
                        ),
                        Text(data.user!.userName, style: AppTypography.headlineLg),
                      ],
                    )
                ),
                InkWell(
                    onTap: (){
                        Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                  child: ListTile(
                      title: Text("Profile", style: AppTypography.headlineMd,),
                      trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                InkWell(
                    onTap: (){
                        Navigator.pushNamed(context, SettingsScreen.routeName);
                    },
                  child: ListTile(
                      title: Text("Settings", style: AppTypography.headlineMd,),
                      trailing: Icon(Icons.arrow_forward_ios),
                  ),
                )
            ],
        ),
    );
    }
}