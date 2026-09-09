import 'package:flutter/material.dart';
import 'package:message/core/theme/app_theme.dart';
import 'package:message/features/home/controllers/add_friends_controller.dart';
import 'package:message/features/home/state/add_friends_state.dart';
import 'package:message/features/home/widgets/empty_search_state.dart';
import 'package:message/features/home/widgets/user_result_tile.dart';
import 'package:message/core/widgets/snack_bar_helper.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class AddFriends extends StatefulWidget {
  static final String routeName = "add-friends-screen";
  const AddFriends({super.key});

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _search(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      context.read<AddFriendsController>().fetchUsersList(value);
    });
  }

  void _submitSearch() {
    _searchDebounce?.cancel();
    context.read<AddFriendsController>().fetchUsersList(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AddFriendsState>();

    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && state.error != null) {
          SnackBarHelper.showError(context, state.error!);
          context.read<AddFriendsState>().setError(null);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Friends')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: _search,
              onSubmitted: (_) => _submitSearch(),
              decoration: InputDecoration(
                hintText: 'Search by username',
                prefixIcon: const Icon(Icons.person_search),
                suffixIcon: IconButton(
                  tooltip: 'Search',
                  onPressed: _submitSearch,
                  icon: const Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.usersList.isEmpty
                  ? EmptySearchState(
                      hasQuery: _searchController.text.trim().isNotEmpty,
                    )
                  : ListView.separated(
                      itemCount: state.usersList.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) =>
                          UserResultTile(user: state.usersList[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
