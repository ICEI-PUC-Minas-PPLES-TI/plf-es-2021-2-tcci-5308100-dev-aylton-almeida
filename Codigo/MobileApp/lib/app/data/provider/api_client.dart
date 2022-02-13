import 'dart:convert';

import 'package:http/http.dart';

// TODO: add correct url
const baseUrl = 'http://gerador-nomes.herokuapp.com';

class ApiClient {
  final Client httpClient;

  ApiClient({required this.httpClient});

  Future<Iterable> getAll(String path) async {
    // TODO: test

    try {
      final uri = Uri.parse('$baseUrl/$path');
      final response = await httpClient.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed request with error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
