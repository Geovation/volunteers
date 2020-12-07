import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:volunteers/src/config.dart';
import 'package:volunteers/src/widgets/map_control_plugin.dart';
import 'package:volunteers/src/widgets/attribution_plugin.dart';
import 'package:volunteers/src/utils/helpers/scaffold_helper.dart';
import 'package:volunteers/src/core/viewmodels/app_state.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteers'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => RootScaffold.openDrawer(context)),
        actions: <Widget>[
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Log out',
                onPressed: () => context.read<AppState>().signOut())
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.5, -0.09),
          zoom: 12.0,
          minZoom: 8.0,
          maxZoom: 20.0,
          plugins: [
            MapControlPlugin(),
            AttributionPlugin(),
          ],
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            // urlTemplate:
            //     'https://api.os.uk/maps/raster/v1/zxy/{layerId}_3857/{z}/{x}/{y}.png?key={accessKey}',
            // additionalOptions: {
            //   'layerId': '${EnvironmentConfig.OS_MAP_STYLE}',
            //   'accessKey': '${EnvironmentConfig.OS_MAPS_API_KEY}',
            // },
            maxZoom: 20.0,
          ),
          MapControlPluginOption(),
          AttributionPluginOption(
              logoIcon: IconAsset.OS_LOGO,
              logoLabel: 'OS Logo',
              width: 90.0,
              height: 24.0,
              copyrightTitle: 'OS Maps',
              copyrightContent:
                  'Contains OS data © Crown copyright and database rights 2020'),
        ],
      ),
    );
  }
}
