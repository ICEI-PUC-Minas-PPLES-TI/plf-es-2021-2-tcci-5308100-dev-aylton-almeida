import 'package:delivery_manager/app/controllers/app_controller.dart';
import 'package:delivery_manager/app/data/enums/problem_type.dart';
import 'package:delivery_manager/app/data/models/order.dart';
import 'package:delivery_manager/app/data/repository/deliveries_repository.dart';
import 'package:delivery_manager/app/modules/order_problems/controllers/order_problems_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/samples/order_sample.dart';
import './order_problemas_controller_test.mocks.dart';

@GenerateMocks([
  TextEditingController,
  GlobalKey,
  DeliveriesRepository,
  AppController,
])
void main() {
  group('Testing Order Problems Controller', () {
    // Mock
    late MockGlobalKey<FormState> mockGlobalKey;
    late MockTextEditingController mockTextEditingController;
    late MockDeliveriesRepository mockDeliveriesRepository;
    late MockAppController mockAppController;
    late Order mockOrder;

    createController() {
      return OrderProblemsController(
        formKey: mockGlobalKey,
        appController: mockAppController,
        deliveriesRepository: mockDeliveriesRepository,
        order: mockOrder,
      );
    }

    setUp(() {
      mockGlobalKey = MockGlobalKey<FormState>();
      mockAppController = MockAppController();
      mockTextEditingController = MockTextEditingController();
      mockDeliveriesRepository = MockDeliveriesRepository();

      mockOrder = orderSample.copyWith();
    });

    tearDown(() {
      reset(mockGlobalKey);
      reset(mockAppController);
      reset(mockTextEditingController);
      reset(mockDeliveriesRepository);
    });

    test('Controller onInit', () {
      // when
      final controller = createController();

      // then
      Get.put(controller);

      // assert
      expect(
        controller.descriptionController,
        isInstanceOf<TextEditingController>(),
      );
      expect(controller.order, mockOrder);
      expect(controller.isLoading, isFalse);
      expect(controller.isValid, isFalse);
    });

    test('Handle type change', () {
      // when
      final controller = createController();
      const problemType = ProblemType.absent_receiver;

      // then
      controller.handleTypeChange(problemType);

      // assert
      expect(controller.problemType, problemType);
    });
  });
}
