import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';

import 'animations.dart';

class SliverVideoPlaylist extends StatefulWidget {
  final Stream<VideoModel> stream;

  const SliverVideoPlaylist({
    Key key,
    this.stream,
  }) : super(key: key);

  @override
  _SliverVideoPlaylistState createState() => _SliverVideoPlaylistState();
}

class _SliverVideoPlaylistState extends State<SliverVideoPlaylist> {
  final youtube = LocatorService().youtube;
  final _list = GlobalKey<SliverAnimatedListState>();

  final _playlists = <VideoModel>[];

  @override
  void initState() {
    super.initState();
    widget.stream.handleError((error, stackTrace) {
      log.e(
        'Received error signal from stream',
        error,
        stackTrace,
      );
    }).forEach((value) {
      _playlists.add(value);
      _list.currentState.insertItem(_playlists.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _list,
      itemBuilder: (context, index, animation) {
        return SlideLeftWithFade(
          animation: animation,
          child: _buildItem(_playlists[index]),
        );
      },
    );
  }

  Widget _buildItem(VideoModel video) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: VideoThumbnail(video: video),
    );
  }
}
