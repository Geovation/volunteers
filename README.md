# volunteers

A new Flutter project to show volunteer events on a map.

## Enviroment Variables

* `OS_MAPS_API_KEY` - a valid OS DataHub MAPS API key
* `OS_MAP_STYLE` - an OS map style layer, e.g. `Road`, `Outdoor` or `Light`

## Install Flutter

To install and run Flutter development environment, follow the official [online documentation](https://flutter.dev/docs/get-started/install) to get started.

Check if there are any dependencies you need to install to complete the setup:
```
$ flutter doctor -v
```

## Run the mobile app

Install package dependencies:
```
$ flutter pub get
```

Check running devices:
```
$ flutter devices
```

Run on a single device (you can find `deviceId` at the result of the second column from the above command):
```
$ flutter run -d <deviceId>
```

Run on multiple devices (press `r` in terminal to perform Hot reload):
```
$ flutter run -d all --dart-define=OS_MAPS_API_KEY=<INSERT_YOUR_API_KEY_HERE> --dart-define=OS_MAP_STYLE=<INSERT_OS_MAP_STYLE_HERE>
```
If you are debugging in VS Code, follow this [flutter wiki page](https://github.com/flutter/flutter/wiki/Multi-device-debugging-in-VS-Code) to create a `launch.json` with [--dart-define](https://dartcode.org/docs/using-dart-define-in-flutter/) for configurations.

## Run the web app

Switch to beta channel, use latest version of Flutter SDK, and then enable web support:
```
$ flutter channel beta
$ flutter upgrade
$ flutter config --enable-web
```

To serve your app from `localhost` in Chrome (web):
```
$ flutter run -d chrome --web-hostname 0.0.0.0 --web-port 12345 --dart-define=OS_MAPS_API_KEY=<INSERT_YOUR_API_KEY_HERE> --dart-define=OS_MAP_STYLE=<INSERT_OS_MAP_STYLE_HERE> --release
```

If you are debugging in VS Code, add the following snippet to the `launch.json` configurations:
```
{
	"name": "Chrome",
	"request": "launch",
	"type": "dart",
	"deviceId": "chrome",
	"args": [
		"--web-hostname",
		"0.0.0.0",
		"--web-port",
		"12345",
		"--dart-define",
		"OS_MAPS_API_KEY=<INSERT_YOUR_API_KEY_HERE>",
		"--dart-define",
		"OS_MAP_STYLE=<INSERT_OS_MAP_STYLE_HERE>"
	]
},
```

You can also test the web app on your mobile browser in the same Local Area Network (LAN). It might take a while to load in debug mode:
```
$ http://your-local-IP-address:12345
```
