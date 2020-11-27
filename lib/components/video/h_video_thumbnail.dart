import 'package:SingularSight/models/video_model.dart';
import 'package:flutter/material.dart';

class HVideoThumbnail extends StatelessWidget {
  final VideoModel video;

  const HVideoThumbnail({
    Key key,
    this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: video.thumbnails.default_.width.toDouble(),
              height: video.thumbnails.default_.height.toDouble(),
              child: Image.network(
                video.thumbnails.default_.url,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ListTile(
                isThreeLine: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                title: Text(
                  video.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle:
                    Text('${video.channelTitle}\n${video.viewCount} views'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
