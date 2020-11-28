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
  final playlists = <PlaylistModel>[];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    youtube.searchPlaylists(pageSize: 10).forEach((value) {
      playlists.add(value);
      _list.currentState.insertItem(playlists.length - 1);
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
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .animate(animation),
            child: SlideTransition(
              position: Tween(begin: Offset(0, -0.10), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut))
                  .animate(animation),
              child: _buildItem(playlists[index]),
            ),
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
    while (playlists.isNotEmpty) {
      final item = playlists.removeAt(0);
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
