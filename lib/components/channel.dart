import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';

typedef OnSubscribed = bool Function(bool subscribed);

class ChannelThumbnail extends StatefulWidget {
  final Thumbnail thumbnail;
  final String title;
  final int subscribers;
  final bool showSubscribeButton;
  final bool isSubscribed;
  final OnSubscribed onSubscribed;

  const ChannelThumbnail(
      {Key key,
      this.thumbnail,
      this.title,
      this.subscribers,
      this.isSubscribed = false,
      this.showSubscribeButton = false,
      this.onSubscribed})
      : super(key: key);

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
    return Row(
      children: [
        SizedBox(
          width: widget.thumbnail.width.toDouble(),
          height: widget.thumbnail.height.toDouble(),
          child:
              CircleAvatar(backgroundImage: NetworkImage(widget.thumbnail.url)),
        ),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(widget.title),
            subtitle: widget.subscribers != null
                ? Text('${widget.subscribers} subscribers')
                : null,
          ),
        ),
        if (widget.showSubscribeButton)
          Expanded(
            child: RaisedButton.icon(
              color: subscribed ? Colors.grey : Theme.of(context).primaryColor,
              icon: subscribed
                  ? Icon(Icons.notifications_active)
                  : Icon(Icons.notifications),
              label: subscribed
                  ? Text('UNFOLLOW', style: TextStyle(color: Colors.black))
                  : Text('FOLLOW'),
              onPressed: _onPressed,
            ),
          )
      ],
    );
  }

  void _onPressed() {
    if (widget.onSubscribed != null && widget.onSubscribed.call(!subscribed)) {
      setState(() => subscribed = true);
    }
  }
}
