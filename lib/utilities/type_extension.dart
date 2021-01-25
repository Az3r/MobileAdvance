import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';

extension IntExtension on int {
  String toCountingFormat([BuildContext context]) {
    log.v('Missing mutilingual support');
    var num = this.toString();
    if (this >= 1000000)
      num = '${(this / 1000000).floor()}M';
    else if (this >= 1000) num = '${(this / 1000).floor()}K';
    return '$num subscribers';
  }

  String toVideoViewFormat([BuildContext context]) {
    if (this >= 1000000)
      return '${(this / 1000000).floor()}M views';
    else if (this >= 1000) return '${(this / 1000).floor()}K views';
    return this.toString() + ' views';
  }
}

extension DurationExtension on Duration {
  String toVideoDurationFormat([BuildContext context]) {
    int hours = this.inHours;
    var minutes = this.inMinutes % 60;
    var seconds = this.inSeconds % 60;
    return (hours == 0 ? '' : '$hours:') +
        minutes.toString().padLeft(2, '0') +
        ':' +
        seconds.toString().padLeft(2, '0');
  }

  String toVideoPublishFormat([BuildContext context]) {
    if (this.inDays >= 365)
      return '${(this.inDays / 365).ceil()} years ago';
    else if (this.inDays >= 30)
      return '${(this.inDays / 30).ceil()} months ago';
    else if (this.inDays > 0)
      return '${this.inDays} days ago';
    else if (this.inHours > 0)
      return '${this.inHours} hours ago';
    else if (this.inMinutes > 0)
      return '${this.inMinutes} minutes ago';
    else
      return '${this.inSeconds} seconds ago';
  }
}
