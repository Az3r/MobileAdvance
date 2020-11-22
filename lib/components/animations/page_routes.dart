import 'package:flutter/material.dart';

class LongerMaterialPageRoute extends MaterialPageRoute {
  final Duration duration;
  final WidgetBuilder builder;

  LongerMaterialPageRoute({
    this.builder,
    this.duration,
  }) : super(builder: builder);
  @override
  Duration get transitionDuration => duration;
}
