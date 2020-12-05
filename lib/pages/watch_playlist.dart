import 'dart:async';
import 'dart:io';

import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../styles/texts.dart' as styles;

class WatchPlaylist extends StatefulWidget {
  final PlaylistModel playlist;

  const WatchPlaylist({Key key, this.playlist}) : super(key: key);

  @override
  _WatchPlaylistState createState() => _WatchPlaylistState();
}

class _WatchPlaylistState extends State<WatchPlaylist> {
  final youtube = LocatorService().youtube;

  YoutubePlayerController _player;
  StreamController<List<VideoModel>> _videoList;

  ApiResult<VideoModel> _prev;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _videoList = StreamController();
    loadPlayer();
  }

  Future<void> loadPlayer() async {
    // get all videos of a playlist
    await loadNext();
    _player = YoutubePlayerController(
      initialVideoId: video.id,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        forceHD: true,
      ),
    );
    return widget.playlist;
  }

  Future<void> loadNext() async {
    if (_prev == null || _prev.nextToken != null) {
      final result = await youtube.getVideosFromPlaylist(
        widget.playlist,
        nextToken: _prev?.nextToken,
      );
      _prev = result;
      _videoList.add(result.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) return player;
            return Column(
              children: [
                player,
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      videoDetails,
                      SliverToBoxAdapter(
                        child: Divider(color: Colors.white24, thickness: 1),
                      ),
                      channelThumbnail,
                      SliverToBoxAdapter(
                        child: Divider(color: Colors.white24, thickness: 1),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget get player {
    return StreamBuilder<VideoModel>(
      stream: null,
      builder: (context, snapshot) => YoutubePlayer(controller: _player),
    );
  }

  Widget get videoDetails {
    return SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Row(
              children: [
                Expanded(child: videoTitle),
                descButton,
              ],
            ),
            videoStatistic,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                like,
                dislike,
                bookmark,
                addChannel,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get channelThumbnail {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8,
        ),
        child: ChannelThumbnail.horizontal(
          onThumbnailTap: () => Navigator.of(context).pushNamed(
            RouteNames.channelDetails,
            arguments: widget.playlist.channel,
          ),
          thumbnailRadius: 32,
          channel: widget.playlist.channel,
        ),
      ),
    );
  }

  Widget get playlists {}

  Widget get videoTitle {
    return Text(
      video.title,
      style: styles.title(context),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget get descButton {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.keyboard_arrow_down),
      onPressed: _openDescription,
    );
  }

  Widget get videoStatistic {
    return Text('$views - $publishedAt', style: styles.subtitle(context));
  }

  String get views => count(video.viewCount) + ' views';

  String get publishedAt {
    final duration = DateTime.now().difference(video.publishedAt);
    if (duration.inDays >= 365)
      return '${(duration.inDays / 365).ceil()} years ago';
    else if (duration.inDays >= 30)
      return '${(duration.inDays / 30).ceil()} months ago';
    else if (duration.inDays > 0)
      return '${duration.inDays} days ago';
    else if (duration.inHours > 0)
      return '${duration.inHours} hours ago';
    else if (duration.inMinutes > 0)
      return '${duration.inMinutes} minutes ago';
    else
      return '${duration.inSeconds} seconds ago';
  }

  Widget get like {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.thumb_up),
        SizedBox(height: 8),
        Text(
          '${count(video.likeCount)}',
          style: styles.subtitle(context),
        )
      ],
    );
  }

  Widget get dislike {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.thumb_down),
        SizedBox(height: 8),
        Text(
          '${count(video.dislikeCount)}',
          style: styles.subtitle(context),
        )
      ],
    );
  }

  Widget get addChannel {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.add),
        SizedBox(height: 8),
        Text(
          'Add channel',
          style: styles.subtitle(context),
        )
      ],
    );
  }

  Widget get bookmark {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.bookmark),
        SizedBox(height: 8),
        Text(
          'bookmark',
          style: styles.subtitle(context),
        )
      ],
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _openDescription() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Description'),
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(video.title, style: styles.headline(context)),
                  SizedBox(height: 16),
                  Text(video.description),
                  SizedBox(height: 32),
                  RaisedButton.icon(
                      color: Colors.white,
                      textColor: Colors.red,
                      label: Text('OPEN YOUTUBE'),
                      icon: Icon(
                        FontAwesomeIcons.youtube,
                        color: Colors.red,
                      ),
                      onPressed: _openYoutubeApp)
                ],
              ),
            ),
          ),
        );
      },
    );
    ;
  }

  void _openYoutubeApp() async {
    final scheme = Platform.isIOS ? 'youtube' : 'https';
    final url =
        '$scheme://www.youtube.com/watch?v=${video.id}&list=${widget.playlist.id}';
    launch(url).catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Oopise!'),
            content: Text('Unable to open youtube app'),
            actions: [
              TextButton(
                child: Text("That's sad!"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });
  }

  String count(int n) {
    if (n >= 1000000)
      return '${(n / 1000000).floor()}M';
    else if (n >= 1000) return '${(n / 1000).floor()}K';
    return n.toString();
  }

  VideoModel get video => widget.playlist.videos[_current];
}
