import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
    await youtube.findVideoIdsByPlaylist(test.id).forEach((element) {
      test.videoIds.add(element);
    });

    _player = YoutubePlayerController(
      initialVideoId: test.videoIds[_position],
      flags: YoutubePlayerFlags(
        autoPlay: false,
        forceHD: true,
      ),
    );
    _currentVideo = await youtube.getVideoDetails(test.videoIds[_position]);

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
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Text(_currentVideo.title),
                          Row(
                            children: [
                              Text(
                                  '${_currentVideo.viewCount.toString()} views'),
                              Text(_currentVideo.publishedAt
                                  .toLocal()
                                  .toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.thumb_up),
                                if (_currentVideo.likeCount != null)
                                  Text(_currentVideo.likeCount.toString()),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.thumb_down),
                                if (_currentVideo.dislikeCount != null)
                                  Text(_currentVideo.likeCount.toString()),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bookmark),
                                Text('Bookmark'),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_box),
                                Text('Add channel'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                                test.channel.thumbnails.default_.url),
                          ),
                          Expanded(
                            child: ListTile(
                              isThreeLine: true,
                              dense: true,
                              title: Text(test.channel.title),
                              subtitle: Text(
                                test.channel.subscriberCount == null
                                    ? ''
                                    : '${test.channel.subscriberCount} subscribers',
                              ),
                              trailing: ElevatedButton(
                                  child: Text("FOLLOW"), onPressed: () {}),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
