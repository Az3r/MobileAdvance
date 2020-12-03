import 'package:flutter/material.dart';

extension SnackBarUtils on SnackBar {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
      BuildContext context) {
    Scaffold.of(context).removeCurrentSnackBar();
    return Scaffold.of(context).showSnackBar(this);
  }
}
