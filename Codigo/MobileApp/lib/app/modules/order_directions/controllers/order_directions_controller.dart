import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/data/repository/position_repository.dart';
import 'package:delivery_manager/app/modules/order_directions/arguments/order_directions_args.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderDirectionsController extends GetxController {
  late DeliveriesRepository _deliveriesRepository;
  late PositionRepository _locationRepository;
  late AppController _appController;
  late AuthController _authController;

  late GoogleMapController _mapsController;

  final Delivery _delivery;
  final _currentPosition = Rx<Position?>(null);

  OrderDirectionsController({
    required DeliveriesRepository deliveriesRepository,
    required PositionRepository locationRepository,
    required AppController appController,
    required AuthController authController,
    Delivery? delivery,
  })  : _delivery =
            (Get.arguments as OrderDirectionsArgs?)?.delivery ?? delivery!,
        _deliveriesRepository = deliveriesRepository,
        _locationRepository = locationRepository,
        _appController = appController,
        _authController = authController;

  @override
  void onInit() {
    super.onInit();

    getInitialPosition();
  }

  LatLng? get currentPosition => _currentPosition.value != null
      ? LatLng(
          _currentPosition.value!.latitude, _currentPosition.value!.longitude)
      : null;

  void onMapCreated(GoogleMapController controller) {
    _mapsController = controller;
    _locationRepository.getPositionStream(onPosition: (position) {
      if (position != _currentPosition.value) {
        _currentPosition.value = position;
        _mapsController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ));
      }
    });
  }

  Future<void> getInitialPosition() async {
    final position = await _locationRepository.getCurrentPosition();
    _currentPosition.value = position;
  }
}
