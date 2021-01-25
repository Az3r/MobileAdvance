import 'package:SingularSight/components/image.dart' as img;
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:SingularSight/components/typography.dart' as typo;

class Bookmarks extends StatelessWidget {
  const Bookmarks({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaylistModel>>(
      future: FirebaseService().watchLaters(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return ErrorWidget(snapshot.error);
        if (snapshot.hasData)
          return _BookmarkCollection(playlists: snapshot.data);
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _BookmarkCollection extends StatefulWidget {
  final List<PlaylistModel> playlists;
  _BookmarkCollection({Key key, @required this.playlists})
      : assert(playlists != null),
        super(key: key);

  @override
  __BookmarkCollectionState createState() => __BookmarkCollectionState();
}

class __BookmarkCollectionState extends State<_BookmarkCollection> {
  List<int> selecteds = [];
  bool multiSelectionMode = false;
  List<PlaylistModel> willDelete = [];
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
        leading: multiSelectionMode
            ? IconButton(
                icon: Icon(Icons.close), onPressed: _disableMultiSelection)
            : null,
        title: multiSelectionMode
            ? Text('Select ${selecteds.length}')
            : Text('Bookmarks'),
        actions: [
          if (multiSelectionMode)
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
            selected: multiSelectionMode ? selecteds.contains(index) : null,
            onDeleted: _addToWillDelete,
            onLongPressed: () => _enableMultiSelection(index),
            onPressed: () => multiSelectionMode
                ? _selectPlaylist(index)
                : _openPlaylist(index),
          ),
        ),
      ),
    );
  }

  void _deleteSelectedItems() {
    for (final index in selecteds) {
      willDelete.add(list[index]);
    }
    setState(() {
      for (final index in selecteds) {
        list.removeAt(index);
      }
      selecteds.clear();
      multiSelectionMode = false;
    });
  }

  void _addToWillDelete(int index, PlaylistModel playlist) {
    willDelete.add(playlist);
    setState(() => list.removeAt(index));
  }

  void _enableMultiSelection(int selectedIndex) {
    selecteds
      ..clear()
      ..add(selectedIndex);
    setState(() => multiSelectionMode = true);
  }

  void _disableMultiSelection() {
    selecteds.clear();
    setState(() => multiSelectionMode = false);
  }

  void _openPlaylist(int index) {}
  void _selectPlaylist(int index) {
    setState(() {
      if (!selecteds.remove(index)) selecteds.add(index);
    });
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
        color: selected == true ? Theme.of(context).selectedRowColor : null,
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
        img.ThumbnailImage(thumbnail: playlist.thumbnails.medium),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            children: [
              typo.Title(text: playlist.title),
              const SizedBox(height: 8),
              typo.Subtitle(text: playlist.channel.title),
              typo.Subtitle(text: '${playlist.videoCount} videos')
            ],
          ),
        ),
      ],
    );
  }
}
