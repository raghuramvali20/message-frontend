import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
    static final String routeName = "settings-screen";
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications Section
            Text(
              'Notifications',
              style: AppTypography.titleMd,
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: ListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Get notified about new messages'),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Display Section
            Text(
              'Display',
              style: AppTypography.titleMd,
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: ListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Coming soon'),
                trailing: Switch(
                  value: _darkModeEnabled,
                  onChanged: null, // Disabled for now
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Privacy Section
            Text(
              'Privacy & Security',
              style: AppTypography.titleMd,
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Block List'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Block list coming soon')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy policy coming soon')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text(
                        "Logout",  
                        style: TextStyle(
                            color: Colors.red
                            )
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                                return AlertDialog(
                                    title: const Text("Are you sure you want to log out?"),
                                    actions: [
                                        TextButton(
                                            onPressed: (){
                                                Navigator.pop(context);
                                            }, 
                                            child: Text("Cancel")
                                        ),
                                        TextButton(
                                            onPressed: (){
                                                Navigator.pop(context);
                                            }, 
                                            child: Text(
                                                "Logout", 
                                                style: TextStyle(
                                                    color: Colors.red
                                                )
                                            )
                                        )
                                    ],
                                );
                            });
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // About Section
            Text(
              'About',
              style: AppTypography.titleMd,
            ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('App Version'),
                    subtitle: const Text('1.0.0'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Build Number'),
                    subtitle: const Text('1'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
