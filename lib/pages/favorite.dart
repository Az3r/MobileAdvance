import 'package:SingularSight/components/image.dart' as img;
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:SingularSight/components/typography.dart' as typo;

class Favorites extends StatelessWidget {
  const Favorites({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaylistModel>>(
      future: FirebaseService().favorites(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return ErrorWidget(snapshot.error);
        if (snapshot.hasData)
          return _FavoriteCollection(playlists: snapshot.data);
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _FavoriteCollection extends StatefulWidget {
  final List<PlaylistModel> playlists;
  _FavoriteCollection({Key key, @required this.playlists})
      : assert(playlists != null),
        super(key: key);

  @override
  _FavoriteCollectionState createState() => _FavoriteCollectionState();
}

class _FavoriteCollectionState extends State<_FavoriteCollection> {
  List<int> _selecteds = [];
  bool _multiSelectionMode = false;
  List<String> _willDelete = [];
  List<PlaylistModel> list;
  @override
  void initState() {
    super.initState();
    list = widget.playlists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _multiSelectionMode
            ? IconButton(
                icon: Icon(Icons.close), onPressed: _disableMultiSelection)
            : null,
        title: _multiSelectionMode
            ? Text('Select ${_selecteds.length}')
            : Text('Favorites'),
        actions: [
          if (_multiSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedItems,
            )
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => InkWell(
          child: _PlaylistItem(
            key: Key(list[index].id),
            index: index,
            playlist: list[index],
            selected: _multiSelectionMode ? _selecteds.contains(index) : null,
            onDeleted: _addToWillDelete,
            onLongPressed:
                _multiSelectionMode ? null : () => _enableMultiSelection(index),
            onPressed: () => _multiSelectionMode
                ? _selectPlaylist(index)
                : _openPlaylist(index),
          ),
        ),
      ),
    );
  }

  void _deleteSelectedItems() {
    for (final index in _selecteds) {
      _willDelete.add(list[index].id);
    }
    setState(() {
      for (final index in _selecteds) {
        list.removeAt(index);
      }
      _selecteds.clear();
      _multiSelectionMode = false;
    });
  }

  void _addToWillDelete(int index, PlaylistModel playlist) {
    _willDelete.add(playlist.id);
    setState(() => list.removeAt(index));
  }

  void _enableMultiSelection(int selectedIndex) {
    _selecteds
      ..clear()
      ..add(selectedIndex);
    setState(() => _multiSelectionMode = true);
  }

  void _disableMultiSelection() {
    _selecteds.clear();
    setState(() => _multiSelectionMode = false);
  }

  void _openPlaylist(int index) {}
  void _selectPlaylist(int index) {
    setState(() {
      if (!_selecteds.remove(index)) _selecteds.add(index);
    });
  }

  @override
  void dispose() {
    super.dispose();

    // now we actually remove deleted playlist
    FirebaseService().removeFromFavorites(_willDelete);
  }
}

class _PlaylistItem extends StatelessWidget {
  final PlaylistModel playlist;
  final bool selected;
  final int index;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final void Function(int index, PlaylistModel playlist) onDeleted;

  _PlaylistItem({
    Key key,
    @required this.playlist,
    @required this.index,
    this.selected,
    this.onPressed,
    this.onLongPressed,
    this.onDeleted,
  })  : assert(playlist != null),
        assert(index != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPressed,
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: selected == true
            ? Theme.of(context).selectedRowColor.withAlpha(64)
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _PlaylistDetail(playlist: playlist)),
            if (selected == null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => onDeleted?.call(index, playlist),
              )
          ],
        ),
      ),
    );
  }
}

class _PlaylistDetail extends StatelessWidget {
  final PlaylistModel playlist;
  const _PlaylistDetail({
    Key key,
    @required this.playlist,
  })  : assert(playlist != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            flex: 2,
            child: img.ThumbnailImage(thumbnail: playlist.thumbnails.medium)),
        const SizedBox(width: 8.0),
        Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              typo.Title(text: playlist.title),
              const SizedBox(height: 8),
              typo.Subtitle(text: playlist.channelTitle),
              typo.Subtitle(text: '${playlist.videoCount} videos')
            ],
          ),
        ),
      ],
    );
  }
}
