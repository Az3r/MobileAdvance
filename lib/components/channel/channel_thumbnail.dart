import 'package:SingularSight/models/channel_model.dart';
import 'package:flutter/material.dart';

class ChannelThumbnail extends StatelessWidget {
  final ChannelModel channel;

  const ChannelThumbnail({Key key, this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      FadeInImage.assetNetwork(
        image: channel.thumbnails.default_.url,
        placeholder: 'assets/icons/icon.jpeg',
        placeholderCacheHeight: channel.thumbnails.default_.height,
        placeholderCacheWidth: channel.thumbnails.default_.width,
      ),
      Text(channel.title),
      Text('${channel.subscriberCount} subscribers'),
    ]);
  }
}
