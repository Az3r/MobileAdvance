import 'package:SingularSight/components/errors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';

class ThumbnailImage extends StatelessWidget {
  final Thumbnail thumbnail;
  const ThumbnailImage({
    Key key,
    this.thumbnail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: thumbnail.url,
      placeholder: (context, url) => Icon(Icons.image),
      errorWidget: (context, url, error) => Container(
        child: NetworkImageError(error: error),
      ),
      fit: BoxFit.cover,
    );
  }
}
