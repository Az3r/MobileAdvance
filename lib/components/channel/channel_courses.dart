import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';

import '../thumbnails.dart';

class SliverChannelCourses extends StatefulWidget {
  final String channelId;
  final int initialCount;

  const SliverChannelCourses({
    Key key,
    this.channelId,
    this.initialCount = 10,
  }) : super(key: key);

  @override
  _SliverChannelCoursesState createState() => _SliverChannelCoursesState();
}

class _SliverChannelCoursesState extends State<SliverChannelCourses> {
  final youtube = LocatorService().youtube;
  final _list = GlobalKey<SliverAnimatedListState>();

  final videos = <PlaylistModel>[];

  @override
  void initState() {
    super.initState();
    youtube.findPlaylistByChannel(widget.channelId).forEach((element) {
      videos.add(element);
      _list.currentState.insertItem(videos.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _list,
      itemBuilder: (context, index, animation) {
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut))
              .animate(animation),
          child: _buildItem(videos[index]),
        );
      },
    );
  }

  Widget _buildItem(PlaylistModel playlist) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        RouteNames.watch,
        arguments: playlist,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16,
        ),
        child: PlaylistThumbnail(
          channelThumbnail: playlist.channel.thumbnails?.default_,
          channelTitle: playlist.channel.title,
          thumbnail: playlist.thumbnails.default_,
          title: playlist.title,
          videoCount: playlist.videoCount,
        ),
      ),
    );
  }
}
