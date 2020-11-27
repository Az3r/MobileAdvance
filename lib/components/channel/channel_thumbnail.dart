import 'package:SingularSight/models/channel_model.dart';
import 'package:flutter/material.dart';

class ChannelThumbnail extends StatelessWidget {
  final ChannelModel channel;

  const ChannelThumbnail({Key key, this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage(channel.thumbnails.medium.url),
        ),
        Text(channel.title),
        Text('${channel.subscriberCount} subscribers'),
      ],
    );
  }
}
