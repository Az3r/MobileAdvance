import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';

extension IntExtension on int {
  String toSubscirberFormat([BuildContext context]) {
    log.v('Missing mutilingual support');
    var num = this.toString();
    if (this >= 1000000)
      num = '${(this / 1000000).floor()}M';
    else if (this >= 1000) num = '${(this / 1000).floor()}K';
    return '$num subscribers';
  }
}
