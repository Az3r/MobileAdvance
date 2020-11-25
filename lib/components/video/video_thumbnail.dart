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
    return Center(
      child: Row(
          children: [
            Image.network(
              video.thumbnails.default_.url,
              width: video.thumbnails.default_.width.toDouble(),
              height: video.thumbnails.default_.height.toDouble(),
            ),
            Container(
              child: Text(
                video.title,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
    );
  }
}
