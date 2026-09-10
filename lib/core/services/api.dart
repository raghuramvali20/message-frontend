import "package:http/http.dart" as http;
import "dart:convert";
import "package:message/core/config/app_environment.dart";

class ApiMethods {
  static const String baseUrl = AppEnvironment.apiBaseUrl;

  // GET request with optional headers
  static Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl$endpoint");
    return await http.get(url, headers: headers);
  }

  // POST request with optional headers
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final url = Uri.parse("$baseUrl$endpoint");
    return await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        ...?headers, // merge custom headers
      },
      body: jsonEncode(body),
    );
  }
}
