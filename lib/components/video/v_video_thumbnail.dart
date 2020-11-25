import 'package:SingularSight/models/video_model.dart';
import 'package:flutter/material.dart';

class VVideoThumbnail extends StatelessWidget {
  final VideoModel video;

  const VVideoThumbnail({
    Key key,
    this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              video.thumbnails.high.url,
              fit: BoxFit.contain,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  video.creator,
                  style: TextStyle(color: Colors.white54),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${video.viewCount} views - ${video.publishedAt.toLocal()}',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
