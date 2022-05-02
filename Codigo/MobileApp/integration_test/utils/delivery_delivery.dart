import 'package:delivery_manager/app/data/models/delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> deliverDelivery(
    {required WidgetTester tester, required Delivery delivery}) async {
  // when
  const orderDetailsCardKey = Key('order_details_card_ink_well');

  // check if the delivery details are showing, including list of products and orders
  expect(find.text(delivery.name!), findsOneWidget);
  expect(
    find.text(
      'delivery_initial_address'.tr.replaceAll(
            ':address',
            delivery.orders![0].shippingAddress.formatted,
          ),
    ),
    findsOneWidget,
  );
  expect(find.byType(GoogleMap), findsOneWidget);
  expect(find.text('start_delivery'.tr), findsOneWidget);
  expect(find.text('cancel_delivery'.tr), findsOneWidget);
  expect(find.text('products'.tr), findsOneWidget);
  expect(find.text('orders'.tr), findsOneWidget);
  expect(
    find.text(delivery.orders![0].orderProducts[0].name),
    findsOneWidget,
  );

  // click on the orders tab and expect all orders to be shown
  await tester.tap(find.text('orders'.tr));
  await tester.pumpAndSettle();
  expect(
    find.text(delivery.orders![0].buyerName),
    findsOneWidget,
  );

  // click on start button and check if dialog appear
  await tester.tap(find.text('start_delivery'.tr));
  await tester.pumpAndSettle();
  expect(find.text('start_delivery_dialog_title'.tr), findsOneWidget);

  // tap confirm button and check if order directions is shown
  await tester.tap(find.text('confirm'.tr));
  await tester.pumpAndSettle();
  expect(find.byType(GoogleMap), findsOneWidget);

  // deliver first order
  await tester.tap(find.byKey(orderDetailsCardKey));
  await tester.pumpAndSettle();
  expect(find.text('next_delivery'.tr), findsOneWidget);
  await tester.tap(find.text('view_details'.tr));
  await tester.pumpAndSettle();
  expect(find.text('order_details'.tr), findsOneWidget);
  await tester.tap(find.text('confirm_delivery'.tr));
  await tester.pumpAndSettle();
  expect(find.text('delivery_confirmed'.tr), findsOneWidget);

  // register problem for second one
  await tester.tap(find.byKey(orderDetailsCardKey));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 5)); // Wait snackbar to disappear
  expect(find.text('next_delivery'.tr), findsOneWidget);
  await tester.tap(find.text('view_details'.tr));
  await tester.pumpAndSettle();
  expect(find.text('order_details'.tr), findsOneWidget);
  await tester.tap(find.text('register_problem'.tr));
  await tester.pumpAndSettle();
  expect(find.text('order_problem_header'.tr), findsOneWidget);
  expect(find.text('order_problem_subheader'.tr), findsOneWidget);
  await tester.tap(find.text('order_problem_select_hint'.tr));
  await tester.pumpAndSettle();
  await tester.tap(find.text('absent_receiver'.tr).first, warnIfMissed: false);
  await tester.pumpAndSettle();
  await tester.tap(find.text('send_problem'.tr));
  await tester.pumpAndSettle();
  expect(find.text('problem_registered'.tr), findsOneWidget);

  // deliver third one
  await tester.tap(find.byKey(orderDetailsCardKey));
  await tester.pumpAndSettle();
  await tester.pump(const Duration(seconds: 5)); // Wait snackbar to disappear
  expect(find.text('next_delivery'.tr), findsOneWidget);
  await tester.tap(find.text('view_details'.tr));
  await tester.pumpAndSettle();
  expect(find.text('order_details'.tr), findsOneWidget);
  await tester.tap(find.text('confirm_delivery'.tr));
  await tester.pumpAndSettle();
  expect(find.text('delivery_confirmed'.tr), findsOneWidget);

  // expect thank you and going back to start
  expect(find.text('delivery_complete_header'.tr), findsOneWidget);
  await tester.tap(find.text('go_back_to_start'.tr));
  await tester.pumpAndSettle();
  expect(find.text('delivery_code_form_header'.tr), findsOneWidget);
}
