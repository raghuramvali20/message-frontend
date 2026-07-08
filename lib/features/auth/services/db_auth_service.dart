import 'dart:convert';

import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/services/api.dart';
import 'package:message/features/auth/services/auth_services.dart';

class DbAuthServices extends AuthServices{
    @override
  Future<ApiResponse<User>> login(String email, String password) async{
    
    Map<String, dynamic> body = {
        "email": email,
        "password": password
    };

    final response = await ApiMethods.post("/auth/login", body);
    final Map<String, dynamic> data = jsonDecode(response.body);

    if(response.statusCode == 200){
        User user = User.fromJson(data["user"]);
        return SuccessResponse<User>(user, extras: {"token": data["token"]});
    }else{
        return FailureResponse<User>(data["serverMessage"]);
    }

  }
  @override
  Future<ApiResponse<User>> register(String userName, String email, String password) async {
    
    Map<String, dynamic> body = {
        "userName": userName,
        "email": email,
        "password": password
    };

    final response = await ApiMethods.post("/auth/register", body);

    final Map<String, dynamic> data = jsonDecode(response.body);

    if(response.statusCode == 201){
        User user = User.fromJson(data["user"]);
        return SuccessResponse<User>(user, extras: {"token": data["token"]});
    }
    else { 
        return FailureResponse<User>(data["serverMessage"]);
    }
  }
}