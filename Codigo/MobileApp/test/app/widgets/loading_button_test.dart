import 'package:delivery_manager/app/widgets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../utils/create_test_material_widget.dart';
import '../../utils/function_mock.dart';

void main() {
  group('Loading Button Widget Tests', () {
    testWidgets('Testing when its not loading or disabled',
        (WidgetTester tester) async {
      // when
      const key = Key('test_button_key');
      const isLoading = false;
      const isDisabled = false;
      const child = Text('test');

      // mock
      final onPressed = FunctionMock();

      // then
      await tester.pumpWidget(
        createTestMaterialWidget(
          LoadingButton(
            key: key,
            onPressed: onPressed,
            child: child,
            isLoading: isLoading,
            isDisabled: isDisabled,
          ),
        ),
      );

      // assert
      expect(find.text('test'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        tester.widget<LoadingButton>(find.byKey(key)).onPressed,
        isNotNull,
        reason: 'Expect submit button to be enabled',
      );
    });

    testWidgets('Testing when onPressed is called',
        (WidgetTester tester) async {
      // when
      const key = Key('test_button_key');
      const isLoading = false;
      const isDisabled = false;
      const child = Text('test');

      // mock
      final onPressed = FunctionMock();

      // then
      await tester.pumpWidget(
        createTestMaterialWidget(
          LoadingButton(
            key: key,
            onPressed: onPressed,
            child: child,
            isLoading: isLoading,
            isDisabled: isDisabled,
          ),
        ),
      );
      await tester.tap(find.byKey(key));

      // assert
      verify(onPressed()).called(1);
    });

    testWidgets('Testing when button is loading', (WidgetTester tester) async {
      // when
      const key = Key('test_button_key');
      const isLoading = true;
      const isDisabled = false;
      const child = Text('test');

      // mock
      final onPressed = FunctionMock();

      // then
      await tester.pumpWidget(
        createTestMaterialWidget(
          LoadingButton(
            key: key,
            onPressed: onPressed,
            child: child,
            isLoading: isLoading,
            isDisabled: isDisabled,
          ),
        ),
      );

      // assert
      expect(find.text('test'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<LoadingButton>(find.byKey(key)).onPressed,
        isNull,
        reason: 'Expect submit button to be disabled',
      );
    });

    testWidgets('Testing when button is disabled', (WidgetTester tester) async {
      // when
      const key = Key('test_button_key');
      const isLoading = false;
      const isDisabled = true;
      const child = Text('test');

      // mock
      final onPressed = FunctionMock();

      // then
      await tester.pumpWidget(
        createTestMaterialWidget(
          LoadingButton(
            key: key,
            onPressed: onPressed,
            child: child,
            isLoading: isLoading,
            isDisabled: isDisabled,
          ),
        ),
      );

      // assert
      expect(find.text('test'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        tester.widget<LoadingButton>(find.byKey(key)).onPressed,
        isNull,
        reason: 'Expect submit button to be disabled',
      );
    });
  });
}
