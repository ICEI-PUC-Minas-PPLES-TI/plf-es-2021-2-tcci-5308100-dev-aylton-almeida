import 'dart:async';
import 'dart:convert';

import 'package:delivery_manager/app/data/models/directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final mapsApi = dotenv.env['MAPS_API_KEY'];

class MapsRepository {
  static const _basePath = 'maps.googleapis.com';

  final Client _client;

  MapsRepository({Client? client}) : _client = client ?? Client();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    // TODO: Test

    final uri = Uri.https(_basePath, '/maps/api/directions/json', {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': mapsApi,
    });

    final response = await _client.get(uri);

    // Check if response is successful and return directions
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return Directions.fromMap(parsed);
    }
    return null;
  }
}
