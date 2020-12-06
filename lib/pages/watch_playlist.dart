import 'dart:async';
import 'dart:io';

import 'package:SingularSight/components/animations.dart';
import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/components/video_playlist.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../styles/texts.dart' as styles;

class WatchPlaylist extends StatefulWidget {
  final PlaylistModel playlist;
  final VideoModel initialVideo;

  const WatchPlaylist({
    Key key,
    this.playlist,
    this.initialVideo,
  }) : super(key: key);

  @override
  _WatchPlaylistState createState() => _WatchPlaylistState();
}

class _WatchPlaylistState extends State<WatchPlaylist> {
  final youtube = LocatorService().youtube;
  final _list = GlobalKey<SliverVideoPlaylistState>();

  YoutubePlayerController _player;
  VideoModel _video;

  @override
  void initState() {
    super.initState();
    _video = widget.initialVideo;
    _player = YoutubePlayerController(
      initialVideoId: _video.id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        forceHD: true,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              // enter full screen mode
              SystemChrome.setEnabledSystemUIOverlays([]);
              return YoutubePlayer(controller: _player);
            }
            // exit full screen mode
            SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
            return Column(
              children: [
                YoutubePlayer(controller: _player),
                Expanded(
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (notification) {
                      _list.currentState.loadNext();
                      return true;
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate.fixed(
                            [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: videoTitle),
                                    descButton,
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: videoStatistic,
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  like,
                                  dislike,
                                  bookmark,
                                  addChannel,
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: youtubeButton,
                                width: 480,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: channelThumbnail),
                                    ElevatedButton(
                                      child: Text('SUBSCRIBE'),
                                      onPressed: _openYoutubeChannel,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        playlists,
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget get channelThumbnail {
    return ChannelThumbnail.horizontal(
      onThumbnailTap: () => Navigator.of(context).pushNamed(
        RouteNames.channelDetails,
        arguments: widget.playlist.channel,
      ),
      thumbnailRadius: 24,
      channel: widget.playlist.channel,
    );
  }

  Widget get playlists {
    return SliverVideoPlaylist(
      playlist: widget.playlist,
      key: _list,
      onSelected: (i, video) => setState(() {
        _video = video;
        _player.load(video.id);
      }),
    );
  }

  Widget get videoTitle {
    return Text(
      _video.title,
      style: styles.title(context),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget get youtubeButton {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
        onPrimary: Colors.white,
      ),
      label: Text('WATCH ON YOUTUBE'),
      icon: Icon(FontAwesomeIcons.youtube),
      onPressed: _openYoutubeVideo,
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

  String get views => count(_video.viewCount) + ' views';

  String get publishedAt {
    final duration = DateTime.now().difference(_video.publishedAt);
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
          '${count(_video.likeCount)}',
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
          '${count(_video.dislikeCount)}',
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(_video.title, style: styles.headline(context)),
                  SizedBox(height: 16),
                  Text(_video.description),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
    ;
  }

  void _openYoutubeVideo() async {
    final scheme = Platform.isIOS ? 'youtube' : 'https';
    final url =
        '$scheme://www.youtube.com/watch?v=${_video.id}&list=${widget.playlist.id}';
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

  void _openYoutubeChannel() async {
    final scheme = Platform.isIOS ? 'youtube' : 'https';
    final url =
        '$scheme://www.youtube.com/channel/${widget.playlist.channel.id}';
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
}
