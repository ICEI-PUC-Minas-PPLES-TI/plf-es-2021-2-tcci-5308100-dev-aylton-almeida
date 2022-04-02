import 'dart:convert';

import 'package:delivery_manager/app/data/repository/storage_repository.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['API_URL'];

class ApiClient {
  final Client _httpClient;
  final StorageRepository _storageRepository;

  ApiClient(
      {required Client httpClient,
      required StorageRepository storageRepository})
      : _httpClient = httpClient,
        _storageRepository = storageRepository;

  getHeaders() async {
    final authToken = await _storageRepository.getAuthToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authToken != null ? 'Bearer $authToken' : ''
    };
  }

  handleApiResponse(Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed request with error ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _httpClient.get(uri, headers: await getHeaders());

    return handleApiResponse(response);
  }

  Future<dynamic> post<T>(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _httpClient.post(
      uri,
      body: jsonEncode(body),
      headers: await getHeaders(),
    );

    return handleApiResponse(response);
  }
}
