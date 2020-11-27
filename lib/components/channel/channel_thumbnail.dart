import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';

class ChannelThumbnail extends StatelessWidget {
  final ChannelModel channel;

  const ChannelThumbnail({Key key, this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                RouteNames.channelDetails,
                arguments: channel,
              ),
              child: Hero(
                tag: channel.id,
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(channel.thumbnails.medium.url),
                ),
              ),
            ),
          ),
        ),
        Text(channel.title),
        Text('${channel.subscriberCount} subscribers'),
      ],
    );
  }
}
