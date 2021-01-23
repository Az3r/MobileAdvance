import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:SingularSight/utilities/type_extension.dart';

/// a Column consisting of an image and a label
class ShortThumbnail extends StatelessWidget {
  final ChannelModel channel;
  const ShortThumbnail({Key key, this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styles = _useStyles(context);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        RouteNames.channelDetails,
        arguments: channel,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Hero(
              tag: channel.id,
              child: ClipOval(
                child: Material(
                  child: CachedNetworkImage(
                    imageUrl: _thumbnail.url,
                    placeholder: (context, url) => Icon(Icons.image),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.warning),
                          Text('Unable to load image'),
                        ],
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            channel.title,
            textAlign: TextAlign.center,
            style: styles['title'],
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            channel.subscriberCount.toSubscirberFormat(context),
            textAlign: TextAlign.center,
            style: styles['subtitle'],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _useStyles(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return {
      'title': TextStyle(fontSize: textTheme.subtitle1.fontSize),
      'subtitle': TextStyle(
        fontSize: textTheme.subtitle2.fontSize,
        color: colorScheme.onPrimary.withAlpha(Colors.white38.alpha),
      ),
    };
  }

  Thumbnail get _thumbnail => channel.thumbnails.medium;
}
