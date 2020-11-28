import 'package:SingularSight/utilities/constants.dart';
import '../styles/texts.dart' as styles;
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
        if (widget.thumbnail != null) avatar,
        if (widget.thumbnail != null) SizedBox(height: 8),
        title,
        if (widget.subscribers != null) subtitle,
        if (widget.showSubscribeButton) button
      ],
    );
  }

  Widget _buildHorizontal() {
    return Row(
      children: [
        if (widget.thumbnail != null) avatar,
        if (widget.thumbnail != null) SizedBox(width: 8),
        Column(
          children: [
            title,
            if (widget.subscribers != null) subtitle,
          ],
        ),
        SizedBox(width: 8),
        if (widget.showSubscribeButton) Expanded(child: button)
      ],
    );
  }

  Widget get title {
    return Text(
      widget.title,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget get subtitle {
    return Text(
      '${widget.subscribers} subscribers',
      style: TextStyle(color: Colors.white54),
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

class VideoThumbnail extends StatelessWidget {
  final Thumbnail thumbnail;
  final String title;
  final String channelTitle;
  final int viewCount;
  final DateTime publishedAt;

  const VideoThumbnail({
    Key key,
    this.thumbnail,
    this.title,
    this.channelTitle,
    this.viewCount,
    this.publishedAt,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PlaylistThumbnail extends StatelessWidget {
  final Thumbnail thumbnail;
  final String title;
  final String channelTitle;
  final Thumbnail channelThumbnail;
  final int videoCount;
  final bool vertical;

  const PlaylistThumbnail({
    Key key,
    this.thumbnail,
    this.title,
    this.channelTitle,
    this.channelThumbnail,
    this.videoCount,
    this.vertical = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return vertical ? _buildVertical(context) : _buildHorizontal(context);
  }

  Widget _buildHorizontal(BuildContext context) {
    return Row(
      children: [
        image,
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleText(context),
              subtitleText(context),
              if (videoCount != null) videoText(context),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildVertical(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            image,
            Align(
              alignment: Alignment.topRight,
              child: Container(
                alignment: Alignment.center,
                width: 128,
                color: Colors.black.withOpacity(0.5),
                child: Text('${videoCount} videos'),
              ),
            )
          ],
        ),
        ChannelThumbnail(
          showSubscribeButton: false,
          vertical: false,
          title: channelTitle,
          thumbnail: channelThumbnail,
        )
      ],
    );
  }

  Widget titleText(BuildContext context) {
    return Text(title, style: styles.title(context));
  }

  Widget subtitleText(BuildContext context) {
    return Text(channelTitle, style: styles.subtitle(context));
  }

  Widget videoText(BuildContext context) {
    return Text('${videoCount} videos', style: styles.subtitle(context));
  }

  Widget get image {
    return ClipRect(
      child: Align(
        heightFactor: 0.76,
        child: Image.network(
          thumbnail.url,
        ),
      ),
    );
  }
}
