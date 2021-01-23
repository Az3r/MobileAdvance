import 'dart:async';
import 'dart:io';

import 'package:SingularSight/utilities/globals.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:flutter/material.dart';

import 'animations.dart';
import 'routings.dart';

class SliverVideoPlaylist extends StatefulWidget {
  final PlaylistModel playlist;
  final int initialSelected;
  final void Function(int i, VideoModel video) onSelected;
  const SliverVideoPlaylist({
    Key key,
    this.playlist,
    this.onSelected,
    this.initialSelected = 0,
  }) : super(key: key);

  @override
  SliverVideoPlaylistState createState() => SliverVideoPlaylistState();
}

class SliverVideoPlaylistState extends State<SliverVideoPlaylist>
    with AutomaticKeepAliveClientMixin {
  final youtube = LocatorService().youtube;
  final _list = GlobalKey<SliverAnimatedListState>();

  StreamController<List<VideoModel>> _videoList;
  ApiToken<VideoModel> prev;

  final _videos = <VideoModel>[];
  int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected;
    _videoList = StreamController();
    loadNext();
  }

  Future<void> loadNext() async {
    if (_videos.length >= widget.playlist.videoCount) return;
    if (prev == null || prev.nextToken != null) {
      var retry = true;
      while (retry) {
        try {
          final value = await youtube.getVideosFromPlaylist(
            widget.playlist,
            nextToken: prev?.nextToken,
          );
          prev = value;
          _videoList.add(value.items);
          retry = false;
        } on DetailedApiRequestError {
          Navigator.of(context).push(Routings.exceedQuota());
          retry = false;
        } on SocketException {
          retry = await Navigator.of(context).push(Routings.disconnected());
        } catch (e) {
          rethrow;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<VideoModel>>(
      stream: _videoList.stream,
      builder: (context, snapshot) {
        if (_list.currentState != null && snapshot.hasData) {
          for (final item in snapshot.data) {
            _videos.add(item);
            _list.currentState.insertItem(_videos.length - 1);
          }
        }
        return SliverAnimatedList(
          key: _list,
          itemBuilder: (context, index, animation) {
            return SlideLeftWithFade(
              animation: animation,
              child: _buildItem(index, _videos[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildItem(int i, VideoModel video) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: VideoThumbnail(
        selected: i == _selected,
        video: video,
        onTap: () {
          widget.onSelected(i, video);
          setState(() => _selected = i);
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoList.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
