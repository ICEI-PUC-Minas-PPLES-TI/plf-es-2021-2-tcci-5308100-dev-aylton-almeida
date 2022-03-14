import 'package:delivery_manager/app/utils/legal_id_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing Legal Id Parser', () {
    test('Format legal id when its a CPF', () async {
      // when
      const legalId = '12345678910';

      // then
      final response = formatLegalId(legalId);

      // assert
      expect(response, equals('123.456.789-10'));
    });

    test('Format legal id when its a CNPJ', () async {
      // when
      const legalId = '47671756000126';

      // then
      final response = formatLegalId(legalId);

      // assert
      expect(response, equals('47.671.756/0001-26'));
    });
  });
}
