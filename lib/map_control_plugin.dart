import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class MapControlPluginOption extends LayerOptions {
  final int minZoom;
  final int maxZoom;
  final Alignment alignment;

  MapControlPluginOption({
    Key key,
    this.minZoom = 1,
    this.maxZoom = 20,
    this.alignment = Alignment.topRight,
    rebuild,
  }) : super(key: key, rebuild: rebuild);
}

class MapControlPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is MapControlPluginOption) {
      return MapControl(options, mapState, stream);
    }
    throw Exception('Unknown options type for MapControlPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is MapControlPluginOption;
  }
}

class MapControl extends StatefulWidget {
  static const String route = 'map_controller';
  final MapControlPluginOption mapControlOpts;
  final MapState map;
  final Stream<Null> stream;

  MapControl(this.mapControlOpts, this.map, this.stream)
      : super(key: mapControlOpts.key);

  @override
  MapControlState createState() {
    return MapControlState();
  }
}

class MapControlState extends State<MapControl> {
  final FitBoundsOptions options = const FitBoundsOptions(maxZoom: 20.0);
  final Location location = Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _currentLocation;

  @override
  void initState() {
    super.initState();
    initLocationService();
  }

  void initLocationService() async {
    try {
      // Workaround for Flutter Web on iOS browser
      if (!kIsWeb) {
        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            return;
          }
        }

        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            return;
          }
        }
      }
      // Listen to the change of location
      location.onLocationChanged.listen((LocationData result) {
        print('Current Location: $result');
        setState(() {
          _currentLocation = result;
        });
      });
    } on PlatformException catch (e) {
      print('${e.code}: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.mapControlOpts.alignment,
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'zoomInButton',
              mini: true,
              backgroundColor: Colors.grey[100],
              elevation: 4.0,
              onPressed: () {
                var bounds = widget.map.getBounds();
                var centerZoom =
                    widget.map.getBoundsCenterZoom(bounds, options);
                print(centerZoom);
                var zoom = centerZoom.zoom + 1;
                if (zoom > widget.mapControlOpts.maxZoom) {
                  zoom = widget.mapControlOpts.maxZoom as double;
                } else {
                  widget.map.move(centerZoom.center, zoom);
                }
              },
              child: Icon(Icons.add, color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: FloatingActionButton(
                heroTag: 'zoomOutButton',
                mini: true,
                backgroundColor: Colors.grey[100],
                elevation: 4.0,
                onPressed: () {
                  var bounds = widget.map.getBounds();
                  var centerZoom =
                      widget.map.getBoundsCenterZoom(bounds, options);
                  print(centerZoom);
                  var zoom = centerZoom.zoom - 1;
                  if (zoom < widget.mapControlOpts.minZoom) {
                    zoom = widget.mapControlOpts.minZoom as double;
                  } else {
                    widget.map.move(centerZoom.center, zoom);
                  }
                },
                child: Icon(Icons.remove, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: FloatingActionButton(
                heroTag: 'GeolocateButton',
                mini: true,
                backgroundColor: Colors.grey[100],
                elevation: 4.0,
                onPressed: () {
                  widget.map.move(
                      LatLng(_currentLocation.latitude,
                          _currentLocation.longitude),
                      18);
                },
                child: Icon(Icons.gps_fixed, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
