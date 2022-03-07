import 'package:delivery_manager/app/modules/phone_form/arguments/phone_form_user.dart';

class PhoneFormArgs {
  PhoneFormUser user;
  String? deliveryId;

  PhoneFormArgs({
    required this.user,
    this.deliveryId,
  });
}
