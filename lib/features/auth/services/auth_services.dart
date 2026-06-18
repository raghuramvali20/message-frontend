import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';

class AuthServices {
    Future<ApiResponse<User>> login(String email, String password)async{

        await Future.delayed(Duration(milliseconds: 200));

        if(password == "password"){
            return SuccessResponse<User>(
                User(id: "userId", userName: "userName", email: email, blockedUsers: []),
                extras: {"token": "fake-jwt-token"}
            );
        }else{
            return FailureResponse<User>("Email or password is wrong!");
        }
        
    }
    Future<ApiResponse<User>> register(String userName, String email, String password) async{
        await Future.delayed(Duration(milliseconds: 200));

        if(password == "password"){
            return SuccessResponse(
                User(id: "userId", userName: userName, email: email, blockedUsers: [])
                );
        }else{
            return FailureResponse("Email or password is wrong!");
        }
    }
}