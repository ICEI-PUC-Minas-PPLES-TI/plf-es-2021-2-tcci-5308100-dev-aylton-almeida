import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['API_URL'];

class ApiClient {
  final Client httpClient;

  ApiClient({required this.httpClient});

  handleApiResponse(Response response) {
    // TODO: test

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed request with error ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    // TODO: test

    final uri = Uri.parse('$baseUrl/$path');
    final response = await httpClient.get(uri);

    return handleApiResponse(response);
  }
}
