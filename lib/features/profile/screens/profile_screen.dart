import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/core/constants/app_constants.dart';
import 'package:message/core/providers/app_state_provider.dart';
import 'package:message/core/widgets/snack_bar_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AppStateProvider _appState;
  late TextEditingController _usernameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _appState = AppStateProvider();
    _usernameController = TextEditingController(
      text: _appState.currentUser?.userName ?? '',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _appState.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(
          child: Text('No user data'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: user.profilePic != null && user.profilePic!.isNotEmpty
                  ? NetworkImage(user.profilePic!)
                  : null,
              child: user.profilePic == null || user.profilePic!.isEmpty
                  ? Text(
                      user.userName.isNotEmpty ? user.userName[0].toUpperCase() : '?',
                      style: AppTypography.headlineLg,
                    )
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            // User Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Information',
                      style: AppTypography.titleMd,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildInfoTile('Username', user.userName),
                    const SizedBox(height: AppSpacing.md),
                    _buildInfoTile('Email', user.email ?? 'N/A'),
                    const SizedBox(height: AppSpacing.md),
                    _buildInfoTile('User ID', user.id),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Edit Mode
            if (_isEditing) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Profile',
                        style: AppTypography.titleMd,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => setState(() => _isEditing = false),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveProfile,
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                onPressed: _logout,
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMd,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.bodyMd,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _saveProfile() {
    SnackBarHelper.showSuccess(context, 'Profile saved');
    setState(() => _isEditing = false);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _appState.logout();
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppConstants.routeGetStarted,
        );
      }
    }
  }
}
