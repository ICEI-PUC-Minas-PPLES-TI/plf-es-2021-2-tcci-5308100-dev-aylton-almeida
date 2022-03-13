import 'package:delivery_manager/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserIcon extends StatelessWidget {
  final String name;

  const UserIcon({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Get.theme.primaryColor,
      child: InkWell(
        onTap: () => Get.toNamed(Routes.SUPPLIER_ACCOUNT),
        borderRadius: BorderRadius.circular(100),
        child: Text(
          name.trim().split(' ').map((l) => l[0]).take(2).join(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
