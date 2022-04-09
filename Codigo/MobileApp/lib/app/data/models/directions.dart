import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

part 'directions.freezed.dart';

@Freezed()
class Directions with _$Directions {
  const factory Directions({
    required List<PointLatLng> polylinePoints,
    required String totalDistance,
    required String totalDuration,
  }) = _Directions;

  factory Directions.fromMap(Map<String, dynamic> map) {
    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
