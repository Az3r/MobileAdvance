import 'dart:io';

import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../styles/texts.dart' as styles;
import 'dart:math' show Random;

class WatchPlaylist extends StatefulWidget {
  final PlaylistModel playlist;

  const WatchPlaylist({Key key, this.playlist}) : super(key: key);

  @override
  _WatchPlaylistState createState() => _WatchPlaylistState();
}

class _WatchPlaylistState extends State<WatchPlaylist> {
  final youtube = LocatorService().youtube;
  PlaylistModel test;
  YoutubePlayerController _player;
  int _position = 0;
  VideoModel _currentVideo;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<PlaylistModel> load() async {
    final playlists = await LocatorService().playlists;
    test = playlists[Random().nextInt(playlists.length)];

    _player = YoutubePlayerController(
      initialVideoId: test.videos[_position].id,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        forceHD: true,
      ),
    );
    _currentVideo = await youtube.getVideo(test.videos[_position].id);

    return test;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: load(),
          builder: (context, snapshot) {
            Widget child;
            if (snapshot.hasData) {
              child = _buildWidget(snapshot.data);
            } else if (snapshot.hasError)
              child = ErrorWidget(snapshot.error);
            else {
              child = Center(child: CircularProgressIndicator());
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: child,
            );
          },
        ),
      ),
    );
  }

  Widget _buildWidget(PlaylistModel test) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Column(
          children: [
            YoutubePlayer(controller: _player),
            if (orientation == Orientation.portrait)
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 3 / 4,
                                  child: Text(
                                    _currentVideo.title,
                                    style: styles.title(context),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      onPressed: _openDescription,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: videoStatistic,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                videoAction(
                                  icon: Icon(Icons.thumb_up),
                                  label:
                                      Text(_currentVideo.likeCount.toString()),
                                ),
                                videoAction(
                                  icon: Icon(Icons.thumb_down),
                                  label: Text(
                                      _currentVideo.dislikeCount.toString()),
                                ),
                                videoAction(
                                  icon: Icon(Icons.bookmark),
                                  label: Text('Bookmark'),
                                ),
                                videoAction(
                                  icon: Icon(Icons.add),
                                  label: Text('Add'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Divider(color: Colors.white24, thickness: 1),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: ChannelThumbnail.horizontal(
                          onThumbnailTap: () => Navigator.of(context).pushNamed(
                            RouteNames.channelDetails,
                            arguments: test.channel,
                          ),
                          thumbnailRadius: 32,
                          channel: test.channel,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Divider(color: Colors.white24, thickness: 1),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget get videoStatistic {
    final views = '${_currentVideo.viewCount.toString()} views';
    final published = diffFromNow(_currentVideo.publishedAt);
    return Text('$views - $published', style: styles.subtitle(context));
  }

  String diffFromNow(DateTime datetime) {
    final duration = DateTime.now().difference(datetime);
    if (duration.inDays >= 365)
      return '${(duration.inDays / 365).ceil()} years ago';
    else if (duration.inDays >= 30)
      return '${(duration.inDays / 30).ceil()} months ago';
    else if (duration.inDays > 0)
      return '${duration.inDays} days ago';
    else if (duration.inMinutes >= 60)
      return '${(duration.inMinutes / 60).ceil()} hours ago';
    else if (duration.inMinutes > 0)
      return '${duration.inMinutes} minutes ago';
    else
      return '${duration.inSeconds} minutes ago';
  }

  Widget videoAction({Widget icon, Widget label, VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: 8),
          label,
        ],
      ),
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
                  Text(_currentVideo.title, style: styles.headline(context)),
                  SizedBox(height: 16),
                  Text(_currentVideo.description),
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
        '$scheme://www.youtube.com/watch?v=${_currentVideo.id}&list=${test.id}';
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
}
