import 'package:message/core/models/api_response.dart';

abstract class UsersSearchService{
    Future<ApiResponse> searchUsers(String searchString);
}