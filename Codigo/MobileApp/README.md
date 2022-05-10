# Delivery Manager

The delivery manager client app

## Structure

- _controllers:_ Global controllers go here
- _data:_ Communication with external APIs and data classes go here
- _modules:_ Business logic related to each domain go here, such as views, controllers and bindings
- _routes:_ Routing logic go here
- _theme:_ Theme files go here
- _translations:_ Files for each available language should go here
- _utils:_ All your utils files go here
- _widgets:_ Global widgets go here

## Running

- Setup flutter in your machine and run the following

```bash
  flutter pub get && flutter pub run build_runner build && flutter run
```

- On VScode you can simply press `F5` after installing the flutter extension
- The command `flutter pub run build_runner build` is used to generate the following files:
  - Mockito mocks
  - Freezed classes

## Testing

```bash
  # Run unit tests
  flutter test

  # Run integration tests
  flutter test integration_test
```
