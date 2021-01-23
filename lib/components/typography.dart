import 'package:flutter/material.dart';

class Title extends StatelessWidget {
  final String text;
  const Title({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.subtitle1);
  }
}

class Subtitle extends StatelessWidget {
  final String text;
  const Subtitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}
