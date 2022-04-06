import 'dart:async';

import 'package:geolocator/geolocator.dart';

class PositionRepository {
  Future<Position> getCurrentPosition() async {
    // TODO: test

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, so prompt the user to enable them.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If after 2 tries the user still has not granted
        // the permission, then we raise a new error
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Return current position since all permissions were granted
    return await Geolocator.getCurrentPosition();
  }

  StreamSubscription<Position> getPositionStream({
    required Function(Position position) onPosition,
    LocationAccuracy accuracy = LocationAccuracy.bestForNavigation,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    ).listen(onPosition);
  }
}
