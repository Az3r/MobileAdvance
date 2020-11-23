import 'package:SingularSight/models/video_model.dart';
import 'package:flutter/material.dart';

class VideoThumbnail extends StatelessWidget {
  final VideoModel video;

  const VideoThumbnail({
    Key key,
    this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      color: Colors.red,
      child: Text(video.title));
  }
}
