import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGLoader extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;
  final BoxFit fit = BoxFit.contain;
  final Color color;
  final alignment = Alignment.center;
  final String semanticsLabel;

  SVGLoader({
    Key key,
    @required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.semanticsLabel,
  })  : assert(assetPath != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use `Image.network` as a workaround for Web.
    // Use `SvgPicture` from flutter_svg for iOS and Andriod.
    if (kIsWeb) {
      return Image.network(assetPath,
          width: width,
          height: height,
          fit: fit,
          color: color,
          alignment: alignment,
          semanticLabel: semanticsLabel);
    } else {
      return SvgPicture.asset(assetPath,
          width: width,
          height: height,
          fit: fit,
          color: color,
          alignment: alignment,
          semanticsLabel: semanticsLabel);
    }
  }
}
