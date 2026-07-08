import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';

abstract class AuthServices {
    Future<ApiResponse<User>> login(String email, String password);
    Future<ApiResponse<User>> register(String userName, String email, String password);
}