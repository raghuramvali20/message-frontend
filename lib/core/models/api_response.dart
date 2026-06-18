class ApiResponse<T> {
  const ApiResponse();
}

class SuccessResponse<T> extends ApiResponse<T> {
  final T data;
  final Map<String, dynamic>? extras;
  const SuccessResponse(this.data, {this.extras});
}

class FailureResponse<T> extends ApiResponse<T> {
  final String serverMessage;
  const FailureResponse(this.serverMessage);
}

