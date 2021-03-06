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
import 'package:delivery_manager/app/modules/order_details/arguments/order_details_args.dart';
import 'package:delivery_manager/app/modules/order_directions/arguments/order_directions_args.dart';
import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:delivery_manager/app/utils/lifecycle_event_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter/material.dart';

class OrderDirectionsController extends GetxController {
  final defaultZoom = 18.0;

  final DeliveriesRepository _deliveriesRepository;
  final PositionRepository _positionRepository;
  final MapsRepository _mapsRepository;
  final AppController _appController;

  late GoogleMapController _mapsController;

  Delivery _delivery;

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
        _deliveriesRepository = deliveriesRepository,
        _positionRepository = positionRepository,
        _mapsRepository = mapsRepository,
        _appController = appController;

  @override
  void onInit() {
    super.onInit();

    getInitialPosition();

    ///To listen onResume method
    WidgetsBinding.instance?.addObserver(
      LifecycleEventHandler(
        resumeCallBack: refreshDirections,
      ),
    );
  }

  @override
  void onClose() {
    _mapsController.dispose();

    super.dispose();
  }

  Future<void> refreshDirections() async {
    _delivery = await _deliveriesRepository.getDelivery(_delivery.deliveryId!);

    getInitialPosition();
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

  void onOrderCardTap() =>
      _areOrderDetailsOpen.value = !_areOrderDetailsOpen.value;

  void onOrderDetailsTap() {
    _areOrderDetailsOpen.value = false;

    Get.toNamed(
      Routes.ORDER_DETAILS,
      arguments: OrderDetailsArgs(order: _currentOrder.value!),
    );
  }

  bool shouldRefreshDirections(Position currentPosition) {
    if (_directions.value == null) {
      return true;
    }

    // Get distance between current position and all polyline points
    final distances = _directions.value!.polylinePoints
        .map((point) => Geolocator.distanceBetween(currentPosition.latitude,
            currentPosition.longitude, point.latitude, point.longitude))
        .toList();

    // Get the smallest distance and return true if it's greater than 50 meters
    distances.sort();
    final smallestDistance = distances.first;
    return smallestDistance > 80;
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

      if (shouldRefreshDirections(position)) {
        _appController.showAlert(
            text: 'refresh_directions'.tr, type: AlertType.warning);
        await getNextDirection();
      }
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
    await setOriginMarker(
      LatLng(
          _currentPosition.value!.latitude, _currentPosition.value!.longitude),
    );

    final nextDirection = _delivery.route!.addresses
        .map<Tuple2<Order, RouteAddress>?>(
          (address) => Tuple2(
            _delivery.orders!.firstWhere(
                (order) => order.shippingAddressId == address.addressId),
            address,
          ),
        )
        .firstWhere(
          (element) => (element?.item1 != null && !element!.item1.delivered),
          orElse: () => null,
        );

    if (nextDirection != null) {
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
    } else {
      Get.offAllNamed(Routes.DELIVERY_COMPLETE);
    }
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
