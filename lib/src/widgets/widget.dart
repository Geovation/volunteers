import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String heading;

  Header(this.heading);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: TextStyle(fontSize: 24),
        ),
      );
}

class Paragraph extends StatelessWidget {
  final String content;

  Paragraph(this.content);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          content,
          style: TextStyle(fontSize: 18),
        ),
      );
}

class StyledButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;

  StyledButton({
    @required this.child,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).primaryColor),
          minimumSize: Size(64, 40),
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: onPressed,
        child: child,
      );
}

void showSuccessDialog(BuildContext context, String content) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 85.0,
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(fontSize: 18),
          ),
        ),
        actions: <Widget>[
          StyledButton(
            child: Text(
              'OK',
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showErrorDialog(BuildContext context, String title, Exception e) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontSize: 24),
        ),
        content: SingleChildScrollView(
          child: Text(
            '${(e as dynamic).message}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        actions: <Widget>[
          StyledButton(
            child: Text(
              'OK',
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
