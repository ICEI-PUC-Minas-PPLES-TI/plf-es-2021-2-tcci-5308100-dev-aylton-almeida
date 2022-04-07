import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/models/address.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/models/directions.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/data/repository/maps_repository.dart';
import 'package:delivery_manager/app/data/repository/position_repository.dart';
import 'package:delivery_manager/app/modules/order_directions/arguments/order_directions_args.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';

class OrderDirectionsController extends GetxController {
  final defaultZoom = 18.0;

  final DeliveriesRepository _deliveriesRepository;
  final PositionRepository _locationRepository;
  final MapsRepository _mapsRepository;
  final AppController _appController;
  final AuthController _authController;

  late GoogleMapController _mapsController;

  final Delivery _delivery;

  final _currentPosition = Rx<Position?>(null);
  final _directions = Rx<Directions?>(null);
  final _markers = Rx<Set<Marker>>({});

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

  Directions? get directions => _directions.value;

  Set<Marker> get markers => _markers.value;

  void onMapCreated(GoogleMapController controller) {
    _mapsController = controller;

    // Listen to location changes
    _locationRepository.getPositionStream(onPosition: (position) async {
      _currentPosition.value = position;
      _mapsController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: defaultZoom,
          bearing: position.heading,
          tilt: 45,
        ),
      ));
    });
  }

  Future<void> getInitialPosition() async {
    // TODO: test

    try {
      final position = await _locationRepository.getCurrentPosition();
      _currentPosition.value = position;
    } catch (e) {
      _appController.showAlert(
          text: 'location_permission_error'.tr, type: AlertType.error);
    }

    await setOriginMarker(
      LatLng(
          _currentPosition.value!.latitude, _currentPosition.value!.longitude),
    );

    try {
      await getNextDirection();
    } catch (e) {
      _appController.showAlert(
          text: 'generic_error_msg'.tr, type: AlertType.error);
    }
  }

  Future<void> setOriginMarker(LatLng origin) async {
    // TODO :test
    _markers.value = {
      Marker(
        markerId: const MarkerId('origin_marker'),
        position: origin,
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 3.2),
          "assets/images/outline_gps_not_fixed_black.png",
        ),
      ),
    };
  }

  void setDestinationMarker(Address destination) {
    // TODO: test
    _markers.value.add(
      Marker(
        markerId: const MarkerId('destination_marker'),
        position: LatLng(
          destination.lat,
          destination.lng,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        ),
      ),
    );
  }

  Future<void> getNextDirection() async {
    // TODO: test

    final nextDirection = _delivery.route!.addresses
        .map(
          (address) => Tuple2(
            _delivery.orders!.firstWhere(
                (order) => order.shippingAddressId == address.addressId),
            address,
          ),
        )
        .firstWhere((element) => (!element.item1.delivered));

    setDestinationMarker(nextDirection.item2.address);

    _directions.value = await _mapsRepository.getDirections(
        origin: LatLng(
          _currentPosition.value!.latitude,
          _currentPosition.value!.longitude,
        ),
        destination: LatLng(
          nextDirection.item2.address.lat,
          nextDirection.item2.address.lng,
        ));
  }

  void centerCurrentLocation() {
    // TODO: test

    _mapsController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          _currentPosition.value!.latitude,
          _currentPosition.value!.longitude,
        ),
        zoom: defaultZoom,
        bearing: _currentPosition.value!.heading,
      ),
    ));
  }
}
