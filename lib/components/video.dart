import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';

class VideoThumbnail extends StatelessWidget {
  final Thumbnail thumbnail;
  final String title;

  const VideoThumbnail({Key key, this.thumbnail, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
