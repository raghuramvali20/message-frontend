import 'package:flutter/material.dart';
import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/core/storage_services/storage_services.dart';
import 'package:message/features/auth/services/auth_services.dart';
import 'package:message/features/auth/state/auth_state.dart';

class AuthController{
    final AuthServices _service;
    final UserStorageService _userStorage;
    final SecureStorageService _secureStorage;
    final AuthState _state;
    AuthController(this._service, this._userStorage, this._secureStorage, this._state);

    User? _user;
    String? _token;
    String? _error;
    bool _loading = false;

    User? get user => _state.user;
    String? get error => _state.error;
    bool get loading => _state.loading;
    String? get token => _state.token;

    Future<void> login(String email, String password) async{
        _state.setLoading(true);
        _state.setError(null);

        final response = await _service.login(email, password);

        if(response is SuccessResponse<User>){
            _state.setUser(response.data);
            _state.setToken(response.extras?["token"]);
            await _userStorage.saveUser(response.data);
            await _userStorage.setAuthenticated(true);
            if (_state.token != null) {
              await _secureStorage.saveToken(_state.token!);
            }
        }else if(response is FailureResponse<User>){
            _state.setError(response.serverMessage);
        }

        _state.setLoading(false);
    }

    Future<void> register(String userName, String email, String password) async {
      _state.setLoading(true);
      _state.setError(null);

      final response = await _service.register(userName, email, password);

      if (response is SuccessResponse<User>) {
        _state.setUser(response.data);
        _state.setToken(response.extras?["token"]);
        await _userStorage.saveUser(response.data);
        await _userStorage.setAuthenticated(true);
        if (_state.token != null) {
          await _secureStorage.saveToken(_state.token!);
        }
      } else if (response is FailureResponse<User>) {
        _state.setError(response.serverMessage);
      }

      _state.setLoading(false);
    }

}