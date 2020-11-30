# volunteers
[![Build and Deployment](https://github.com/Geovation/volunteers/workflows/Build%20and%20Deployment/badge.svg)](https://github.com/Geovation/volunteers/actions)
[![Code Scanning](https://github.com/Geovation/volunteers/workflows/Code%20Scanning/badge.svg)](https://github.com/Geovation/volunteers/actions)
[![codecov](https://codecov.io/gh/Geovation/volunteers/branch/master/graph/badge.svg?token=CDEMMVA3TY)](https://codecov.io/gh/Geovation/volunteers)

A new Flutter project to show volunteer events on a map as proof of concept.

[`flutter_map`](https://github.com/fleaflet/flutter_map) widget is used in the app to display a Leaflet map provided by raster sources. Potentially swtich to [`flutter-mapbox-gl`](https://github.com/tobrun/flutter-mapbox-gl) widget for vector sources but not until the clustering support is available.

[OS Maps API](https://osdatahub.os.uk/docs/wmts/overview) is applied to request map data. Open data is available from zoom level 0 to 16. For zoom level above 17, please upgrade to Premium plan, or the imagery will become blurry.

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

Check running devices:
```
$ flutter devices
```

Run on a single device (you can find `deviceId` at the result of the second column from the above command):
```
$ flutter run -d <deviceId> -v --dart-define=OS_MAPS_API_KEY=<INSERT_YOUR_API_KEY_HERE> --dart-define=OS_MAP_STYLE=<INSERT_OS_MAP_STYLE_HERE>
```
Press `r` in terminal to perform Hot reload. Change  `deviceId`  to `all` to run on multiple devices.

If you are debugging in VS Code, follow this [flutter wiki page](https://github.com/flutter/flutter/wiki/Multi-device-debugging-in-VS-Code) to create a `launch.json`, and then add [--dart-define](https://dartcode.org/docs/using-dart-define-in-flutter/) values in the `args` field for configurations.

The `launch.json` should look something like this:
```
{
	"version": "0.2.0",
	"configurations": [
		{
			"name": "Current Device",
			"request": "launch",
			"type": "dart"
		},
		{
			"name": "Android",
			"request": "launch",
			"type": "dart",
			"deviceId": "<INSERT_YOUR_DEVICE_ID>",
			"args": [
				"-v",
				"--dart-define",
				"OS_MAPS_API_KEY=<INSERT_YOUR_API_KEY_HERE>",
				"--dart-define",
				"OS_MAP_STYLE=<INSERT_OS_MAP_STYLE_HERE>"
			]
		},
		{
			"name": "iPhone",
			"request": "launch",
			"type": "dart",
			"deviceId": "<INSERT_YOUR_DEVICE_ID>",
			"args": [
				"-v",
				"--dart-define",
				"OS_MAPS_API_KEY=<INSERT_YOUR_API_KEY_HERE>",
				"--dart-define",
				"OS_MAP_STYLE=<INSERT_OS_MAP_STYLE_HERE>"
			]
		},
	],
	"compounds": [
		{
			"name": "All Devices",
			"configurations": ["Android", "iPhone"],
		}
	]
}
```

## Run the web app

Switch to beta channel, use latest version of Flutter SDK, and then enable web support:
```
$ flutter channel beta
$ flutter upgrade
$ flutter config --enable-web
```

To serve your app from `localhost` in Chrome (web):
```
$ flutter run -d chrome --web-hostname 0.0.0.0 --web-port 12345 -v --dart-define=OS_MAPS_API_KEY=<INSERT_YOUR_API_KEY_HERE> --dart-define=OS_MAP_STYLE=<INSERT_OS_MAP_STYLE_HERE> --release
```

If you are debugging in VS Code, add the following snippet to the `launch.json` configurations:
```
{
	"name": "Chrome",
	"request": "launch",
	"type": "dart",
	"deviceId": "chrome",
	"args": [
		"-v",
		"--web-hostname",
		"0.0.0.0",
		"--web-port",
		"12345",
		"--dart-define",
		"OS_MAPS_API_KEY=<INSERT_YOUR_API_KEY_HERE>",
		"--dart-define",
		"OS_MAP_STYLE=<INSERT_OS_MAP_STYLE_HERE>",
		"--release" // Fix: failed to establish connection
	]
},
```
Once saved, the configuration `Chrome` will show up in the drop-down at the top of the Debug side bar.

You can also test the web app on your mobile browser in the same Local Area Network (LAN):
```
$ http://your-local-IP-address:12345
```
In order to access location, use `ngrok` to create a public HTTPS url as `getCurrentPosition()` and `watchPosition()` are deprecated on insecure origins.
```
$ ngrok http 12345
```

## Run the tests

Execute the following command:
```
$ flutter test
```

You can use `--coverage` flag to generate the coverage report for Coveralls or Codecov. If you want to view the report locally, install lcov `$ brew install lcov` and use `genhtml` command:
```
$ genhtml coverage/lcov.info -o coverage/html
```
