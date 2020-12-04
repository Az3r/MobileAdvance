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

class ChannelPlaylists extends StatefulWidget {
  final Stream<PlaylistModel> stream;

  ChannelPlaylists({
    Key key,
    this.stream,
  }) : super(key: key);

  @override
  _ChannelPlaylistsState createState() => _ChannelPlaylistsState();
}

class _ChannelPlaylistsState extends State<ChannelPlaylists> {
  final _list = GlobalKey<AnimatedListState>();
  final _playlists = <PlaylistModel>[];

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
    return AnimatedList(
      key: _list,
      itemBuilder: (context, index, animation) => SlideLeftWithFade(
        animation: animation,
        child: _buildItem(_playlists[index]),
      ),
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
  final _controller = StreamController<List<PlaylistModel>>();
  final _playlists = <PlaylistModel>[];
  ApiResult prev;

  @override
  void initState() {
    super.initState();
    loadMore();
  }

  Future<void> loadMore() async {
    final value = await youtube.findPlaylistByChannel_future(
      widget.channel,
      nextToken: prev?.nextToken,
    );
    prev = value;
    _controller.add(value.items);
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

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
