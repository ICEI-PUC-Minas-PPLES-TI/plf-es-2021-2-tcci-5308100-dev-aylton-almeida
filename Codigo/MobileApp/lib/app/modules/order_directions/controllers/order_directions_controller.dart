import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/data/repository/maps_repository.dart';
import 'package:delivery_manager/app/data/repository/position_repository.dart';
import 'package:delivery_manager/app/modules/order_directions/arguments/order_directions_args.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderDirectionsController extends GetxController {
  final DeliveriesRepository _deliveriesRepository;
  final PositionRepository _locationRepository;
  final MapsRepository _mapsRepository;
  final AppController _appController;
  final AuthController _authController;

  late GoogleMapController _mapsController;

  final Delivery _delivery;
  final _currentPosition = Rx<Position?>(null);

  OrderDirectionsController({
    required DeliveriesRepository deliveriesRepository,
    required PositionRepository locationRepository,
    required MapsRepository mapsRepository,
    required AppController appController,
    required AuthController authController,
    Delivery? delivery,
  })  : _delivery =
            (Get.arguments as OrderDirectionsArgs?)?.delivery ?? delivery!,
        _deliveriesRepository = deliveriesRepository,
        _locationRepository = locationRepository,
        _mapsRepository = mapsRepository,
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
    // TODO: test
    final position = await _locationRepository.getCurrentPosition();
    _currentPosition.value = position;
  }
}
