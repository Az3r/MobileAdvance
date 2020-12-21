import 'dart:async';
import 'dart:developer';

import 'package:SingularSight/components/animations.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';

import 'thumbnails.dart';

class SliverPlaylists extends StatefulWidget {
  final Stream<PlaylistModel> stream;
  final ChannelModel channel;

  const SliverPlaylists({
    Key key,
    this.stream,
    @required this.channel,
  }) : super(key: key);

  @override
  SliverPlaylistsState createState() => SliverPlaylistsState();
}

class SliverPlaylistsState extends State<SliverPlaylists> {
  final youtube = LocatorService().youtube;
  final _list = GlobalKey<SliverAnimatedListState>();
  StreamController<List<PlaylistModel>> _controller;
  final _playlists = <PlaylistModel>[];
  ApiResult<PlaylistModel> prev;

  @override
  void initState() {
    super.initState();
    _controller = StreamController();
    loadNext();
  }

  Future<void> loadNext() async {
    if (prev == null || prev.nextToken != null) {
      final value = await youtube.getPlaylistsOfChannel(
        widget.channel,
        nextToken: prev?.nextToken,
      );
      prev = value;
      _controller.add(value.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PlaylistModel>>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        if (_list.currentState != null && snapshot.hasData) {
          for (final item in snapshot.data) {
            _playlists.add(item);
            _list.currentState.insertItem(_playlists.length - 1);
          }
        }
        return SliverAnimatedList(
          key: _list,
          itemBuilder: (context, index, animation) {
            return SlideLeftWithFade(
              animation: animation,
              child: _buildItem(_playlists[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildItem(PlaylistModel playlist) {
    return InkWell(
      onTap: () async {
        final first = await youtube.getFirstVideoOfPlaylist(playlist);
        return Navigator.of(context).pushNamed(
          RouteNames.watch,
          arguments: [playlist, first],
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16,
        ),
        child: PlaylistThumbnail.horizontal(playlist: playlist),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
