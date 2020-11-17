import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:volunteers/config.dart';

void main() {
  runApp(VolunteerApp());
}

class VolunteerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Volunteers',
      home: Map(),
    );
  }
}

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(51.5, -0.09),
        zoom: 12.0,
        maxZoom: 20.0,
        minZoom: 8.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate:
                'https://api.os.uk/maps/raster/v1/zxy/{layerId}_3857/{z}/{x}/{y}.png?key={accessKey}',
            additionalOptions: {
              'layerId': '${EnvironmentConfig.OS_MAP_STYLE}',
              'accessKey': '${EnvironmentConfig.OS_MAPS_API_KEY}',
            }),
      ],
    );
  }
}
