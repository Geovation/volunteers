# volunteers

A new Flutter project to show volunteer events on a map.

## Enviroment Variables

* `OS_MAPS_API_KEY` - a valid OS DataHub MAPS API key
* `OS_MAP_STYLE` - an OS map style, e.g. `Road`, `Outdoor` or `Light`

## Install Flutter

To install and run Flutter development environment, follow the official [online documentation](https://flutter.dev/docs/get-started/install) to get started.

## Run the app

Install package dependencies:
```
flutter pub get
```

Check running devices:
```
flutter devices
```

Run on a single device (you can find `deviceId` at the result of the second column from the above command):
```
flutter run -d <deviceId>
```

Run on multiple devices (press `r` in terminal to perform Hot reload):
```
flutter run --dart-define=OS_MAPS_API_KEY=INSERT_API_KEY_HERE --dart-define=OS_MAP_STYLE=Road -d all
```
If you are debugging in VS Code, follow this [flutter wiki page](https://github.com/flutter/flutter/wiki/Multi-device-debugging-in-VS-Code) to create a `launch.json` with [--dart-define](https://dartcode.org/docs/using-dart-define-in-flutter/) for configurations.
