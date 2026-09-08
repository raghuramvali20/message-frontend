import 'dart:convert';

import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/services/api.dart';
import 'package:message/core/storage_services/app_storage_services.dart';
import 'package:message/features/home/services/users_search_service.dart';

class DbUsersSearchService extends UsersSearchService {
  @override
  Future<ApiResponse<List<User>>> searchUsers(String searchString) async {
    try {
      final token = await AppStorageService().loadToken();
      final response = await ApiMethods.get(
        "/user/search/${Uri.encodeComponent(searchString)}",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Parse the list of users from the response
        final List<dynamic> usersJson = data['users'] ?? [];
        final List<User> usersList = usersJson
            .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
            .toList();

        return SuccessResponse<List<User>>(usersList);
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['serverMessage'] ??
            errorData['message'] ??
            'Failed to search users';
        return FailureResponse<List<User>>(errorMessage.toString());
      }
    } catch (e) {
      return FailureResponse<List<User>>('Error: ${e.toString()}');
    }
  }
}
