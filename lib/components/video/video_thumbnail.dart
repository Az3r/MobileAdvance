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
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 128,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white10),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 128,
              child: Image.network(
                video.thumbnails.default_.url,
                width: video.thumbnails.default_.width.toDouble(),
                height: video.thumbnails.default_.height.toDouble(),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 4),
            Expanded(
              child: SizedBox(
                height: video.thumbnails.default_.height.toDouble(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      video.creator,
                      style: TextStyle(color: Colors.white54),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${video.viewCount} views - ${video.publishedAt.toLocal()}',
                          style: TextStyle(color: Colors.white54),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
