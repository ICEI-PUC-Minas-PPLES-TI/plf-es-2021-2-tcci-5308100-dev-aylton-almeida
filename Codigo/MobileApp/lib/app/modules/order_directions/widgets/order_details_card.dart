import 'package:delivery_manager/app/data/models/order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsCard extends StatelessWidget {
  final bool isOpen;
  final Order order;
  final String estimateTime;
  final void Function() onOpenTap;
  final void Function() onDetailsTap;

  const OrderDetailsCard({
    required this.isOpen,
    required this.order,
    required this.estimateTime,
    required this.onOpenTap,
    required this.onDetailsTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = Get.mediaQuery.size.height;
    final width = Get.mediaQuery.size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isOpen ? height * 0.4 : 56,
      width: isOpen ? 350 : 250,
      decoration: BoxDecoration(
        color: isOpen ? Colors.green : Colors.red,
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        onTap: onOpenTap,
      ),
    );
  }
}
