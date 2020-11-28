import 'package:flutter/material.dart';

TextStyle title(BuildContext context) {
  return TextStyle(
    fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
    fontWeight: FontWeight.bold,
  );
}

TextStyle subtitle(BuildContext context) {
  return TextStyle(
    fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
    color: Colors.white54,
  );
}
