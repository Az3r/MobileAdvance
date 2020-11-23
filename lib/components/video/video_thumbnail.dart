import 'package:SingularSight/models/video.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';

class VideoThumbnail extends StatelessWidget {
  final VideoModel video;

  const VideoThumbnail({
    Key key,
    this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {}

  Future<VideoModel> load() async {
  }
}
