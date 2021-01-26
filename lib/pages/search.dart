import 'dart:async';
import 'dart:io';
import 'package:SingularSight/components/errors.dart';
import 'package:SingularSight/components/list.dart';
import 'package:SingularSight/components/routings.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:SingularSight/components/animations.dart';
import 'package:SingularSight/components/thumbnails.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:SingularSight/components/typography.dart' as typo;

class Search extends StatefulWidget {
  const Search();

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  final youtube = LocatorService().youtube;
  TextEditingController _editor;
  Timer _tick;
  String query;
  GlobalKey<_PlaylistCollectionState> _list;

  @override
  void initState() {
    super.initState();
    _editor = TextEditingController();
    _list = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _editor,
          textInputAction: TextInputAction.search,
          onChanged: _search,
          onSubmitted: _submitted,
          decoration: InputDecoration(
            hintText: 'Search your playlists...',
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: _editor.clear,
            ),
          ),
        ),
      ),
      Expanded(
          child: NotificationListener<ScrollEndNotification>(
        onNotification: (_) {
          _list.currentState.next();
          return true;
        },
        child: _PlaylistCollection(
          key: _list,
        ),
      ))
    ]);
  }

  void _search(String value) {
    _tick?.cancel();
    _tick = Timer(const Duration(milliseconds: 1000),
        () => _list.currentState.search(value));
  }

  void _submitted(String value) {
    _tick?.cancel();
    _list.currentState.search(value);
  }

  @override
  void dispose() {
    _editor.dispose();
    _tick?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class _PlaylistCollection extends StatefulWidget {
  const _PlaylistCollection({
    Key key,
  }) : super(key: key);

  @override
  _PlaylistCollectionState createState() => _PlaylistCollectionState();
}

class _PlaylistCollectionState extends State<_PlaylistCollection> {
  GlobalKey<DynamicListState<PlaylistModel>> _list;
  final youtube = LocatorService().youtube;
  ApiToken<PlaylistModel> _token;
  String _query;

  @override
  void initState() {
    super.initState();
    _list = GlobalKey<DynamicListState<PlaylistModel>>();
    _query = '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaylistModel>>(
        future: _getNext(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return ErrorWidget(snapshot.error);
          if (snapshot.hasData)
            return DynamicList<PlaylistModel>(
              key: _list,
              getNext: _getNext,
              initialItems: snapshot.data,
              itemBuilder: (context, index, data) => InkWell(
                onTap: () => Navigator.of(context).pushNamed(RouteNames.watch,
                    arguments: {'playlist': data, 'initialVideoIndex': 0}),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _PlaylistWidget(
                    playlist: data,
                  ),
                ),
              ),
            );
          return Center(child: CircularProgressIndicator());
        });
  }

  void search(String q) {
    if (q != _query) {
      print(q);
      _query = q;
      _list.currentState.clear();
      _list.currentState.displayNext();
    }
  }

  void next() => _list.currentState.displayNext();

  Future<List<PlaylistModel>> _getNext() async {
    _token = await youtube.searchPlaylists(
      _query,
      nextToken: _token?.nextToken,
    );
    return _token.items;
  }
}

class _PlaylistWidget extends StatelessWidget {
  final PlaylistModel playlist;
  const _PlaylistWidget({Key key, this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 128,
          child: CachedNetworkImage(
            imageUrl: _thumbnail.url,
            errorWidget: (context, url, error) =>
                NetworkImageError(error: error),
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              typo.Title(text: playlist.title),
              typo.Subtitle(text: '${playlist.videoCount} videos')
            ],
          ),
        ),
        SizedBox(width: 8.0),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<void>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Add to Bookmarks'),
                    leading: Icon(
                      Icons.bookmark,
                    ),
                    onTap: () => _addToBookmarks(context)),
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        )
      ],
    );
  }

  void _addToBookmarks(BuildContext context) async {
    await FirebaseService().addToWatchLaters(playlist.id);
    Navigator.of(context).pop();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(Icons.bookmark),
          const SizedBox(width: 16),
          Text('Playlist has been bookmarked'),
        ],
      ),
    ));
  }

  Thumbnail get _thumbnail => playlist.thumbnails.medium;
}
