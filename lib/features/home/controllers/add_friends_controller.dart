import 'package:message/core/models/api_response.dart';
import 'package:message/core/models/user_model.dart';
import 'package:message/features/home/services/users_search_service.dart';
import 'package:message/features/home/state/add_friends_state.dart';

class AddFriendsController {
  final UsersSearchService _service;
  final AddFriendsState _state;

  AddFriendsController(this._service, this._state);

  Future<void> fetchUsersList(String searchString) async {
    final query = searchString.trim();
    _state.setLoading(true);
    _state.setError(null);

    if (query.length < 3) {
      _state.setUsersList([]);
      _state.setLoading(false);
      return;
    }

    final response = await _service.searchUsers(query);
    if (response is SuccessResponse<List<User>>) {
      _state.setUsersList(response.data);
    } else if (response is FailureResponse<List<User>>) {
      _state.setUsersList([]);
      _state.setError(response.serverMessage);
    }
    _state.setLoading(false);
  }
}
