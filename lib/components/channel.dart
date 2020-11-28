import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';

typedef OnSubscribed = bool Function(bool subscribed);

class ChannelThumbnail extends StatefulWidget {
  final Thumbnail thumbnail;
  final String title;
  final int subscribers;
  final double thumbnailRadius;
  final bool showSubscribeButton;
  final bool isSubscribed;
  final OnSubscribed onSubscribed;
  final bool vertical;
  final VoidCallback onThumbnailTap;

  const ChannelThumbnail({
    Key key,
    this.thumbnail,
    this.thumbnailRadius = 40,
    this.title,
    this.subscribers,
    this.isSubscribed = false,
    this.showSubscribeButton = false,
    this.vertical = false,
    this.onThumbnailTap,
    this.onSubscribed,
  }) : super(key: key);

  @override
  _ChannelThumbnailState createState() => _ChannelThumbnailState();
}

class _ChannelThumbnailState extends State<ChannelThumbnail> {
  var subscribed;

  @override
  void initState() {
    super.initState();
    subscribed = widget.isSubscribed;
  }

  @override
  Widget build(BuildContext context) {
    return widget.vertical ? _buildVertical() : _buildHorizontal();
  }

  Widget _buildVertical() {
    return Column(
      children: [
        avatar,
        SizedBox(height: 8),
        Text(
          widget.title,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.subscribers != null)
          Text(
            '${widget.subscribers} subscribers',
            style: TextStyle(color: Colors.white54),
          ),
        if (widget.showSubscribeButton) button
      ],
    );
  }

  Widget _buildHorizontal() {
    return Row(
      children: [
        avatar,
        SizedBox(width: 8),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(widget.title),
            subtitle: widget.subscribers != null
                ? Text('${widget.subscribers} subscribers')
                : null,
          ),
        ),
        if (widget.showSubscribeButton) Expanded(child: button)
      ],
    );
  }

  Widget get avatar {
    return ClipOval(
      child: Material(
        child: InkWell(
          onTap: widget.onThumbnailTap,
          child: Hero(
            tag: widget.title,
            child: CircleAvatar(
              radius: widget.thumbnailRadius,
              backgroundImage: NetworkImage(widget.thumbnail.url),
            ),
          ),
        ),
      ),
    );
  }

  Widget get button {
    return RaisedButton.icon(
      color: subscribed ? Colors.grey[800] : Theme.of(context).primaryColor,
      icon: subscribed
          ? Icon(Icons.notifications_active)
          : Icon(Icons.notifications),
      label: subscribed
          ? Text('UNFOLLOW', style: TextStyle(color: Colors.black))
          : Text('FOLLOW'),
      onPressed: _onPressed,
    );
  }

  void _onPressed() {
    if (widget.onSubscribed != null && widget.onSubscribed.call(!subscribed)) {
      setState(() => subscribed = true);
    }
  }
}
