import 'package:SingularSight/components/animations.dart';
import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../services/locator_service.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final youtube = LocatorService().youtube;
  final users = LocatorService().users;

  final _list = GlobalKey<AnimatedListState>();
  final _playlists = <PlaylistModel>[];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    youtube.searchPlaylists(pageSize: 10).forEach((value) {
      _playlists.add(value);
      _list.currentState.insertItem(_playlists.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshList,
      child: AnimatedList(
        key: _list,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index, animation) {
          return SlideDownWithFade(
            animation: animation,
            child: _buildItem(_playlists[index]),
          );
        },
      ),
    );
  }

  Widget _buildItem(PlaylistModel playlist) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: PlaylistThumbnail(
        channelThumbnail: playlist.channel.thumbnails.medium,
        channelTitle: playlist.channel.title,
        thumbnail: playlist.thumbnails.medium,
        title: playlist.title,
        vertical: true,
        videoCount: playlist.videoCount,
        onThumbnailTap: () => Navigator.of(context).pushNamed(
          RouteNames.watch,
          arguments: playlist,
        ),
        onChannelThumbnailTap: () => Navigator.of(context).pushNamed(
          RouteNames.channelDetails,
          arguments: playlist.channel,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;

  Future<void> _refreshList() async {
    while (_playlists.isNotEmpty) {
      final item = _playlists.removeAt(0);
      _list.currentState.removeItem(
        0,
        (context, animation) => FadeTransition(
          opacity: Tween(begin: 0.0, end: 0.0).animate(animation),
          child: _buildItem(item),
        ),
      );
    }
    await load();
  }
}
