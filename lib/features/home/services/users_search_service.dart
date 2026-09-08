import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';

abstract class UsersSearchService {
  Future<ApiResponse<List<User>>> searchUsers(String searchString);
}
