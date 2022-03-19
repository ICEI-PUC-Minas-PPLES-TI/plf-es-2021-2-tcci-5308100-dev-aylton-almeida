import 'package:delivery_manager/app/utils/flatten.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing List Flatten', () {
    test('Flatten list when default behavior', () async {
      // when
      const list = [
        [1, 3],
        [2, 4],
        [5, 6]
      ];

      // then
      final response = flatten(list);

      // assert
      expect(response, equals([1, 3, 2, 4, 5, 6]));
    });
  });
}
