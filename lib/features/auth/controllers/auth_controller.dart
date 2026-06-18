import 'package:flutter/material.dart';
import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/auth/services/auth_services.dart';

class AuthController with ChangeNotifier{
    final AuthServices _service;
    final UserStorageService _userStorage;
    final SecureStorageService _secureStorage;
    AuthController(this._service, this._userStorage, this._secureStorage);

    User? _user;
    String? _token;
    String? _error;
    bool _loading = false;

    User? get user => _user;
    String? get error => _error;
    bool get loading => _loading;

    Future<void> login(String email, String password) async{
        _loading = true;
        _error = null;
        notifyListeners();

        final response = await _service.login(email, password);

        if(response is SuccessResponse<User>){
            _user = response.data;
            _token = response.extras?["token"];
            await _userStorage.saveUser(_user!);
            await _userStorage.setAuthenticated(true);
            await _secureStorage.saveToken(_token!);

        }else if(response is FailureResponse<User>){
            _error = response.serverMessage;
        }

        _loading = false;
        notifyListeners();
    }

    Future<void> register(String userName, String email, String password) async{
        _loading = true;
        _error = null;
        notifyListeners();

        final response = await _service.register(userName, email, password);

        if(response is SuccessResponse<User>){
            _user = response.data;
            _token = response.extras?["token"];
            await _userStorage.saveUser(_user!);
            await _userStorage.setAuthenticated(true);
            await _secureStorage.saveToken(_token!);
            
        }else if(response is FailureResponse<User>){
            _error = response.serverMessage;
        }
        
        _loading = false;
        notifyListeners();
    }

}