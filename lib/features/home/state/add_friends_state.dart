import 'package:flutter/foundation.dart';
import 'package:message/core/models/user_model.dart';

class AddFriendsState extends ChangeNotifier {
  List<User> _usersList = [];
  bool _isLoading = false;
  String? _error;

  List<User> get usersList => List.unmodifiable(_usersList);
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setUsersList(List<User> usersList) {
    _usersList = List.of(usersList);
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void reset() {
    _usersList = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
