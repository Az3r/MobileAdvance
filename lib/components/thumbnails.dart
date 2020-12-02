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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            SizedBox(height: 4),
            if (widget.subscribers != null) subtitle,
          ],
        ),
        SizedBox(width: 8),
        if (widget.showSubscribeButton)
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: button,
            ),
          )
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
    return RaisedButton(
      color: subscribed ? Colors.grey[800] : Theme.of(context).primaryColor,
      child: subscribed
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
  final Duration duration;
  final DateTime publishedAt;

  const VideoThumbnail({
    Key key,
    this.thumbnail,
    this.title,
    this.channelTitle,
    this.viewCount,
    this.duration,
    this.publishedAt,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          fit: StackFit.expand,
          children: [
            Image.network(thumbnail.url),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                alignment: Alignment.center,
                height: thumbnail.height.toDouble(),
                child: Text(
                  '${duration.toString()}',
                  style: styles.title(context),
                ),
                color: Colors.black.withOpacity(0.8),
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: styles.title(context)),
            SizedBox(height: 4),
            Text(channelTitle, style: styles.subtitle(context)),
            if (viewCount != null)
              Text('$viewCount views', style: styles.subtitle(context)),
          ],
        )
      ],
    );
  }
}

class PlaylistThumbnail extends StatelessWidget {
  final Thumbnail thumbnail;
  final String title;
  final String channelTitle;
  final Thumbnail channelThumbnail;
  final int videoCount;
  final bool vertical;
  final VoidCallback onThumbnailTap;
  final VoidCallback onChannelThumbnailTap;

  const PlaylistThumbnail({
    Key key,
    this.thumbnail,
    this.title,
    this.channelTitle,
    this.channelThumbnail,
    this.videoCount,
    this.vertical = false,
    this.onThumbnailTap,
    this.onChannelThumbnailTap,
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
              Text(title, style: styles.title(context)),
              SizedBox(height: 4),
              Text(channelTitle, style: styles.subtitle(context)),
              if (videoCount != null)
                Text('${videoCount} videos', style: styles.subtitle(context)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildVertical(BuildContext context) {
    return Column(
      children: [
        Container(
          height: thumbnail.height.toDouble(),
          width: thumbnail.width.toDouble(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              image,
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  alignment: Alignment.center,
                  height: thumbnail.height.toDouble(),
                  width: 96,
                  child: Text(
                    '$videoCount videos',
                    style: styles.title(context),
                  ),
                  color: Colors.black.withOpacity(0.8),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Material(
                child: InkWell(
                  onTap: onChannelThumbnailTap,
                  child: Hero(
                    tag: channelTitle,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(channelThumbnail.url),
                        radius: 24),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(channelTitle, style: styles.title(context)),
          ],
        ),
      ],
    );
  }

  Widget get image {
    return InkWell(
      onTap: onThumbnailTap,
      child: ClipRect(
        child: Align(
          heightFactor: vertical ? 1 : 0.76,
          child: Image.network(
            thumbnail.url,
          ),
        ),
      ),
    );
  }
}
