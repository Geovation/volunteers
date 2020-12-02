import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String heading;

  const Header(this.heading);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: TextStyle(fontSize: 24),
        ),
      );
}

class StyledButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;

  const StyledButton({
    @required this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).primaryColor),
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: onPressed,
        child: child,
      );
}
