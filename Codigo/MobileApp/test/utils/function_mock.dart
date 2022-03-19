import 'package:mockito/mockito.dart';

abstract class MyFunction {
  void call();
}

class FunctionMock extends Mock implements MyFunction {}

abstract class MyFutureFunction {
  Future<void> call() async {}
}

class FutureFunctionMock extends Mock implements MyFutureFunction {}

abstract class MySingleParamFunction<T> {
  void call(T param);
}

class SingleParamFunctionMock<T> extends Mock
    implements MySingleParamFunction<T> {}
