// Attribution Plugin to add custom logo and copyright info.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:volunteers/svg_loader.dart';

class AttributionPluginOption extends LayerOptions {
  final String logoIcon;
  final String logoLabel;
  final double width;
  final double height;
  final String copyrightTitle;
  final String copyrightContent;

  AttributionPluginOption({
    Key key,
    @required this.logoIcon,
    this.logoLabel,
    this.width,
    this.height,
    @required this.copyrightTitle,
    @required this.copyrightContent,
    rebuild,
  })  : assert(logoIcon != null),
        assert(copyrightTitle != null),
        assert(copyrightContent != null),
        super(key: key, rebuild: rebuild);
}

class AttributionPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is AttributionPluginOption) {
      return AttributionLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for AttributionPlugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is AttributionPluginOption;
  }
}

class AttributionLayer extends StatelessWidget {
  final AttributionPluginOption attributionLayerOpts;
  final MapState map;
  final Stream<void> stream;

  AttributionLayer(this.attributionLayerOpts, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            SVGLoader(
              assetPath: attributionLayerOpts.logoIcon,
              width: attributionLayerOpts.width,
              height: attributionLayerOpts.height,
              semanticsLabel: attributionLayerOpts.logoLabel,
            ),
            Spacer(),
            Material(
              type: MaterialType.circle,
              color: Colors.transparent,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.info_outlined, color: Colors.black54),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(attributionLayerOpts.copyrightTitle),
                              content:
                                  Text(attributionLayerOpts.copyrightContent),
                              actions: [
                                FlatButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
