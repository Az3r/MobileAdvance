import 'dart:async';
import 'dart:io';
import 'package:SingularSight/components/routings.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:SingularSight/components/animations.dart';
import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {
  const Search();

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  final youtube = LocatorService().youtube;
  TextEditingController _editor;
  Timer _tick;
  ApiResult _prev;
  StreamController<List<PlaylistModel>> _stream;
  var _list = GlobalKey<AnimatedListState>();
  final _playlists = [];

  @override
  void initState() {
    super.initState();
    _editor = TextEditingController();
    _stream = StreamController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(children: [
        TextField(
          controller: _editor,
          textInputAction: TextInputAction.search,
          onChanged: _search,
          decoration: InputDecoration(
            hintText: 'Search your playlists...',
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: _editor.clear,
            ),
          ),
        ),
        Expanded(
            child: NotificationListener<ScrollEndNotification>(
          onNotification: (_) {
            _loadNext();
            return true;
          },
          child: StreamBuilder<List<PlaylistModel>>(
            stream: _stream.stream,
            builder: (context, snapshot) {
              if (_list.currentState != null && snapshot.hasData) {
                for (final item in snapshot.data) {
                  _playlists.add(item);
                  _list.currentState.insertItem(_playlists.length - 1);
                }
              }
              return animatedList;
            },
          ),
        ))
      ]),
    );
  }

  Widget get animatedList {
    return AnimatedList(
      key: _list,
      itemBuilder: (context, index, animation) => SlideUpWidthFade(
        animation: animation,
        child: _buildItem(_playlists[index]),
      ),
    );
  }

  Widget _buildItem(PlaylistModel item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PlaylistThumbnail.horizontal(
        playlist: item,
        onThumbnailTap: () => Navigator.of(context).pushNamed(
          RouteNames.watch,
          arguments: item,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editor.dispose();
    super.dispose();
  }

  void _search(String value) {
    _tick?.cancel();
    _tick = Timer(const Duration(milliseconds: 1000), () async {
      if (_editor.text.isEmpty) return;

      while (_playlists.isNotEmpty) {
        final item = _playlists.removeAt(0);
        _list.currentState.removeItem(
          0,
          (context, animation) => FadeTransition(
            opacity: Tween(begin: 1.0, end: 0.0).animate(animation),
            child: _buildItem(item),
          ),
        );
      }
      _prev = null;
      _loadNext();
    });
  }

  Future<void> _loadNext() async {
    if (_prev == null || _prev.nextToken != null) {
      var retry = true;
      while (retry) {
        try {
          final result = await youtube.searchPlaylists(
            _editor.text,
            nextToken: _prev?.nextToken,
          );
          retry = false;
          _prev = result;
          _stream.add(result.items);
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
    return true;
  }

  @override
  bool get wantKeepAlive => true;
}
