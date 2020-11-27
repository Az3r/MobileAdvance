import 'package:SingularSight/models/channel_model.dart';
import 'package:flutter/material.dart';

class ChannelHeader extends StatefulWidget {
  final ChannelModel channel;

  const ChannelHeader({Key key, this.channel}) : super(key: key);

  @override
  _ChannelHeaderState createState() => _ChannelHeaderState();
}

class _ChannelHeaderState extends State<ChannelHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Row(
            children: [
              avatar,
              SizedBox(width: 16),
              info,
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(widget.channel.description),
      ],
    );
  }

  Widget get avatar {
    return Hero(
      tag: widget.channel.id,
      child: CircleAvatar(
        radius: 48,
        backgroundImage: NetworkImage(widget.channel.thumbnails.high.url),
      ),
    );
  }

  Widget get info {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.channel.title,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headline6.fontSize,
          ),
        ),
        Text(
          '${widget.channel.subscriberCount} subcribers',
          style: TextStyle(
            color: Colors.white54,
          ),
        ),
        SizedBox(height: 8),
        RaisedButton(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('FOLLOW'),
          ),
          onPressed: () {},
          padding: EdgeInsets.zero,
        )
      ],
    );
  }
}
