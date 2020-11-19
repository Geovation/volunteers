import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

class ZoomControlPluginOption extends LayerOptions {
  final int minZoom;
  final int maxZoom;
  final bool mini;
  final Alignment alignment;
  final Color zoomInColor;
  final Color zoomOutColor;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;

  ZoomControlPluginOption({
    Key key,
    this.minZoom = 1,
    this.maxZoom = 18,
    this.mini = true,
    this.alignment = Alignment.topRight,
    this.zoomInColor,
    this.zoomInIcon = Icons.add,
    this.zoomOutColor,
    this.zoomOutIcon = Icons.remove,
    rebuild,
  }) : super(key: key, rebuild: rebuild);
}

class ZoomControlPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is ZoomControlPluginOption) {
      return ZoomControl(options, mapState, stream);
    }
    throw Exception('Unknown options type for ZoomControlPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is ZoomControlPluginOption;
  }
}

class ZoomControl extends StatelessWidget {
  final ZoomControlPluginOption zoomControlOpts;
  final MapState map;
  final Stream<Null> stream;
  final FitBoundsOptions options = const FitBoundsOptions(maxZoom: 20.0);

  ZoomControl(this.zoomControlOpts, this.map, this.stream)
      : super(key: zoomControlOpts.key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: zoomControlOpts.alignment,
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'zoomInButton',
              mini: zoomControlOpts.mini,
              backgroundColor:
                  zoomControlOpts.zoomInColor ?? Theme.of(context).primaryColor,
              elevation: 4.0,
              onPressed: () {
                var bounds = map.getBounds();
                var centerZoom = map.getBoundsCenterZoom(bounds, options);
                var zoom = centerZoom.zoom + 1;
                if (zoom > zoomControlOpts.maxZoom) {
                  zoom = zoomControlOpts.maxZoom as double;
                } else {
                  map.move(centerZoom.center, zoom);
                }
              },
              child: Icon(zoomControlOpts.zoomInIcon, color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: FloatingActionButton(
                heroTag: 'zoomOutButton',
                mini: zoomControlOpts.mini,
                backgroundColor: zoomControlOpts.zoomOutColor ??
                    Theme.of(context).primaryColor,
                elevation: 4.0,
                onPressed: () {
                  var bounds = map.getBounds();
                  var centerZoom = map.getBoundsCenterZoom(bounds, options);
                  var zoom = centerZoom.zoom - 1;
                  if (zoom < zoomControlOpts.minZoom) {
                    zoom = zoomControlOpts.minZoom as double;
                  } else {
                    map.move(centerZoom.center, zoom);
                  }
                },
                child: Icon(zoomControlOpts.zoomOutIcon, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
