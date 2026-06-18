import 'package:message/core/models/user_model.dart';

class ViewModel {
  final bool success;
  final String message;
  final User? user;
  ViewModel({
    required this.message, 
    required this.success, 
    this.user
    });
}