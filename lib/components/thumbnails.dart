import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import '../styles/texts.dart' as styles;
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';

typedef OnSubscribed = bool Function(bool subscribed);

class ChannelThumbnail extends StatefulWidget {
  final ChannelModel channel;
  final double thumbnailRadius;
  final bool vertical;
  final VoidCallback onThumbnailTap;

  const ChannelThumbnail.vertical({
    Key key,
    this.channel,
    this.thumbnailRadius = 40,
    this.onThumbnailTap,
  })  : vertical = true,
        super(key: key);

  const ChannelThumbnail.horizontal({
    Key key,
    this.channel,
    this.thumbnailRadius = 40,
    this.onThumbnailTap,
  })  : vertical = false,
        super(key: key);

  @override
  _ChannelThumbnailState createState() => _ChannelThumbnailState();
}

class _ChannelThumbnailState extends State<ChannelThumbnail> {
  @override
  Widget build(BuildContext context) {
    return widget.vertical ? _buildVertical() : _buildHorizontal();
  }

  Widget _buildVertical() {
    return Column(
      children: [
        avatar,
        SizedBox(height: 8),
        title,
        if (widget.channel.subscriberCount != null) subtitle,
      ],
    );
  }

  Widget _buildHorizontal() {
    return Row(
      children: [
        avatar,
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            SizedBox(height: 4),
            if (widget.channel.subscriberCount != null) subtitle,
          ],
        ),
      ],
    );
  }

  Widget get title {
    return Text(
      widget.channel.title,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget get subtitle {
    return Text(
      '$subscribers subscribers',
      style: TextStyle(color: Colors.white54),
    );
  }

  String get subscribers {
    final count = widget.channel.subscriberCount;
    if (count >= 1000000)
      return '${(count / 1000000).floor()}M';
    else if (count >= 1000) return '${(count / 1000).floor()}K';
    return count.toString();
  }

  Widget get avatar {
    return ClipOval(
      child: Material(
        child: InkWell(
          onTap: widget.onThumbnailTap,
          child: Hero(
            tag: widget.channel.id,
            child: CircleAvatar(
              radius: widget.thumbnailRadius,
              backgroundImage: NetworkImage(
                widget.channel.thumbnails.medium.url,
              ),
            ),
          ),
        ),
      ),
    );
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

class PlaylistThumbnail extends StatefulWidget {
  final PlaylistModel playlist;
  final bool vertical;
  final VoidCallback onThumbnailTap;
  final VoidCallback onChannelThumbnailTap;

  const PlaylistThumbnail.vertical({
    Key key,
    this.playlist,
    this.onThumbnailTap,
    this.onChannelThumbnailTap,
  })  : vertical = true,
        super(key: key);

  const PlaylistThumbnail.horizontal({
    Key key,
    this.playlist,
    this.onThumbnailTap,
    this.onChannelThumbnailTap,
  })  : vertical = false,
        super(key: key);

  @override
  _PlaylistThumbnailState createState() => _PlaylistThumbnailState();
}

class _PlaylistThumbnailState extends State<PlaylistThumbnail> {
  @override
  Widget build(BuildContext context) {
    return widget.vertical
        ? _buildVertical(context)
        : _buildHorizontal(context);
  }

  Widget _buildHorizontal(BuildContext context) {
    return Row(
      children: [
        playlistThumbnail,
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              SizedBox(height: 4),
              channelTitle,
              if (widget.playlist.videoCount != null) videoCount
            ],
          ),
        ),
        actionButton,
      ],
    );
  }

  Widget _buildVertical(BuildContext context) {
    final thumbnail = widget.playlist.thumbnails.medium;
    return Column(
      children: [
        Container(
          height: thumbnail.height.toDouble(),
          width: thumbnail.width.toDouble(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              playlistThumbnail,
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  alignment: Alignment.center,
                  height: thumbnail.height.toDouble(),
                  width: 96,
                  child: videoCount,
                  color: Colors.black.withOpacity(0.8),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: thumbnail.width.toDouble(),
          child: Row(
            children: [
              Expanded(child: title),
              SizedBox(width: 8),
              actionButton,
            ],
          ),
        ),
        SizedBox(
          width: thumbnail.width.toDouble(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              channelThumbnail,
              SizedBox(width: 8),
              channelTitle,
            ],
          ),
        ),
      ],
    );
  }

  TextStyle get style {
    return widget.vertical ? styles.title(context) : styles.subtitle(context);
  }

  Widget get actionButton {
    return IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () {},
    );
  }

  Widget get title {
    return Text(
      widget.playlist.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: style.copyWith(color: Colors.white),
    );
  }

  Widget get channelTitle {
    return Text(
      widget.playlist.channel.title,
      style: style,
    );
  }

  Widget get videoCount {
    return Text(
      '${widget.playlist.videoCount} videos',
      style: style,
    );
  }

  Widget get channelThumbnail {
    final thumbnail = widget.playlist.channel.thumbnails.medium;
    return ClipOval(
      child: Material(
        child: InkWell(
          onTap: widget.onChannelThumbnailTap,
          child: Hero(
            tag: widget.playlist.channel.id,
            child: CircleAvatar(
              backgroundImage: NetworkImage(thumbnail.url),
              radius: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget get playlistThumbnail {
    final thumbnail = widget.vertical
        ? widget.playlist.thumbnails.medium
        : widget.playlist.thumbnails.default_;
    return InkWell(
      onTap: widget.onThumbnailTap,
      child: ClipRect(
        child: Align(
          heightFactor: widget.vertical ? 1 : 0.76,
          child: Image.network(
            thumbnail.url,
            fit: BoxFit.fill,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return SizedBox(
                width: thumbnail.width.toDouble(),
                height: thumbnail.height.toDouble(),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
