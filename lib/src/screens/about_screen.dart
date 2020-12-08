import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:volunteers/src/widgets/app_bar.dart';
import 'package:volunteers/src/widgets/widget.dart';
import 'package:volunteers/src/utils/helpers/svg_loader_helper.dart';
import 'package:volunteers/src/config.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'About'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
                width: 350,
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset('assets/images/hand-in-hand.jpg'),
                    ),
                    SizedBox(height: 30.0),
                    Header('What is this?'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        'A new and experimental Flutter project to show volunteer information.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 15),
                      child: Text(
                        'Built and supported by',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => launch('https://geovation.uk/'),
                      child: SVGLoader(
                        assetPath: IconAsset.GEOVATION_LOGO,
                        height: 30.0,
                        semanticsLabel: 'Geovation Logo',
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
