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

  Widget _buildOpenCard() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'next_delivery'.tr,
                style: Get.textTheme.subtitle2,
              ),
              const SizedBox(height: 8.0),
              Text(
                order.buyerName,
                style: Get.textTheme.headline6,
              ),
              const SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'address'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      order.shippingAddress.formatted,
                      softWrap: true,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'delivery_time'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(estimateTime),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onDetailsTap,
                  child: Text(
                    'view_details'.tr,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClosedCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          order.buyerName,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          estimateTime,
          style: TextStyle(fontSize: 16, color: Get.theme.primaryColor),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.mediaQuery.size.height;
    final width = Get.mediaQuery.size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isOpen ? height * 0.4 : 56,
      width: isOpen ? width * 0.9 : width * 0.7,
      child: InkWell(
        key: const Key('order_details_card_ink_well'),
        onTap: isOpen ? null : onOpenTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isOpen ? _buildOpenCard() : _buildClosedCard(),
        ),
      ),
    );
  }
}
