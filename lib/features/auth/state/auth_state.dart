import 'package:flutter/material.dart';
import 'package:message/core/models/user_model.dart';

class AuthState extends ChangeNotifier{
    User? _user;
    String? _token;
    String? _error;
    bool _loading = false;

    User? get user => _user;
    String? get error => _error;
    bool get loading => _loading;
    String? get token => _token;

    void setUser(User? user){
        _user = user;
        notifyListeners();
    }
    void setToken(String? token){
        _token = token;
        notifyListeners();
    }
    void setError(String? error){
        _error = error;
        notifyListeners();
    }
    void setLoading(bool loading){
        _loading = loading;
        notifyListeners();
    }
}