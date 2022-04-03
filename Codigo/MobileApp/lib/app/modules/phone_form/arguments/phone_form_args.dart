import 'package:delivery_manager/app/data/enums/user.dart';

class PhoneFormArgs {
  User user;
  String? deliveryId;

  PhoneFormArgs({
    required this.user,
    this.deliveryId,
  });
}
