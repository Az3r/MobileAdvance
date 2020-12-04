import 'dart:async';

import 'package:SingularSight/components/animations.dart';
import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/locator_service.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  final youtube = LocatorService().youtube;

  StreamController<List<PlaylistModel>> _controller;
  final _list = GlobalKey<AnimatedListState>();
  final _playlists = <PlaylistModel>[];
  ApiResult prev;
  String skills;

  @override
  void initState() {
    super.initState();
    _controller = StreamController();

    // load all skills from firestore and use them as search query
    _getSkills().then((value) {
      skills = value.join('|');
      loadNext();
    });
  }

  Future<List<String>> _getSkills() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('skills').get();
    return snapshot.docs.map((e) => e.id).toList();
  }

  Future<void> loadNext() async {
    if (prev == null || prev.nextToken != null) {
      final value = await youtube.searchPlaylists(
        skills,
        nextToken: prev?.nextToken,
      );
      prev = value;
      _controller.add(value.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        loadNext();
        return true;
      },
      child: StreamBuilder<List<PlaylistModel>>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (_list.currentState != null && snapshot.hasData) {
            for (final item in snapshot.data) {
              _playlists.add(item);
              _list.currentState.insertItem(_playlists.length - 1);
            }
          }
          return AnimatedList(
            key: _list,
            itemBuilder: (context, index, animation) {
              return SlideDownWithFade(
                animation: animation,
                child: _buildItem(_playlists[index]),
              );
            },
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
        onChannelThumbnailTap: () =>
            youtube.getChannel(playlist.channelId).then(
                  (value) => Navigator.pushNamed(
                    context,
                    RouteNames.watch,
                    arguments: value,
                  ),
                ),
      ),
    );
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
    await loadNext();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
