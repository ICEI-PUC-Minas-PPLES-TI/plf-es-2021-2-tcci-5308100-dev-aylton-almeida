import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/controllers/auth_controller.dart';
import 'package:delivery_manager/app/data/enums/alert_type.dart';
import 'package:delivery_manager/app/data/models/address.dart';
import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:delivery_manager/app/data/models/directions.dart';
import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/data/models/route_address.dart';
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

  final PositionRepository _positionRepository;
  final MapsRepository _mapsRepository;
  final AppController _appController;

  late GoogleMapController _mapsController;

  final Delivery _delivery;

  final _currentPosition = Rx<Position?>(null);
  final _currentOrder = Rx<Order?>(null);
  final _directions = Rx<Directions?>(null);
  final _markers = Rx<Set<Marker>>({});
  final _areOrderDetailsOpen = false.obs;

  OrderDirectionsController({
    required DeliveriesRepository deliveriesRepository,
    required PositionRepository positionRepository,
    required MapsRepository mapsRepository,
    required AppController appController,
    required AuthController authController,
    Delivery? delivery,
  })  : _delivery =
            (Get.arguments as OrderDirectionsArgs?)?.delivery ?? delivery!,
        _positionRepository = positionRepository,
        _mapsRepository = mapsRepository,
        _appController = appController;

  @override
  void onInit() {
    super.onInit();

    getInitialPosition();
  }

  @override
  void onClose() {
    _mapsController.dispose();

    super.dispose();
  }

  bool get isLoading =>
      _currentPosition.value == null ||
      _currentOrder.value == null ||
      _directions.value == null;

  LatLng? get currentPosition => _currentPosition.value != null
      ? LatLng(
          _currentPosition.value!.latitude, _currentPosition.value!.longitude)
      : null;

  Order? get currentOrder => _currentOrder.value;

  Directions? get directions => _directions.value;

  Set<Marker> get markers => _markers.value;

  bool get showFab => !_areOrderDetailsOpen.value;

  bool get areOrderDetailsOpen => _areOrderDetailsOpen.value;

  void onOrderDetailsOpen() {
    _areOrderDetailsOpen.value = !_areOrderDetailsOpen.value;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapsController = controller;

    // Listen to location changes
    _positionRepository.getPositionStream(onPosition: (position) async {
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
    try {
      final position = await _positionRepository.getCurrentPosition();
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

    _currentOrder.value = nextDirection.item1;
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
