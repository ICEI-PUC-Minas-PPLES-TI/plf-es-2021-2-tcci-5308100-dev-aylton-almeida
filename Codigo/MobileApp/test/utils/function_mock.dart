import 'package:mockito/mockito.dart';

abstract class MyFunction {
  void call();
}

class FunctionMock extends Mock implements MyFunction {}
