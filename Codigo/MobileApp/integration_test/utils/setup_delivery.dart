import 'dart:convert';

import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

Future<Delivery> setupDelivery() async {
  final apiClient = Client();
  final baseUrl = dotenv.env['API_URL'];

  final response =
      await apiClient.post(Uri.parse('$baseUrl/integration-setup'));

  if (response.statusCode != 200) {
    throw Exception('Failed request with error ${response.statusCode}');
  }

  final parsedDelivery = jsonDecode(response.body);
  return Delivery.fromJson(parsedDelivery);
}
