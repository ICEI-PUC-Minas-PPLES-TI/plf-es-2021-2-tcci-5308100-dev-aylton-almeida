import 'package:delivery_manager/app/data/enums/user.dart';

class DeliveryDetailsArgs {
  final String deliveryId;
  User user;

  DeliveryDetailsArgs({required this.deliveryId, required this.user});
}
