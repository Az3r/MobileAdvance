import 'dart:io';

import 'package:SingularSight/components/errors.dart';
import 'package:SingularSight/components/list.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/firebase_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:SingularSight/components/channel.dart' as ch;
import 'package:SingularSight/components/typography.dart' as typo;

class ChannelDetails extends StatefulWidget {
  final ChannelModel channel;

  const ChannelDetails({Key key, this.channel}) : super(key: key);

  @override
  _ChannelDetailsState createState() => _ChannelDetailsState();
}

class _ChannelDetailsState extends State<ChannelDetails> {
  final _listWidget = GlobalKey<_PlaylistCollectionState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.title),
        centerTitle: true,
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _listWidget.currentState.next();
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    SizedBox(
                      child: ch.ShortThumbnail.h(
                        channel: widget.channel,
                      ),
                      height: 64,
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      child: Text('SUBSCRIBE'),
                      onPressed: _openYoutubeChannel,
                    ),
                    SizedBox(height: 16),
                    Text(widget.channel.description),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(
                thickness: 1,
                color: Colors.white24,
              ),
            ),
            _PlaylistCollection(
              key: _listWidget,
              channel: widget.channel,
            ),
          ],
        ),
      ),
    );
  }

  void _openYoutubeChannel() async {
    final scheme = Platform.isIOS ? 'youtube' : 'https';
    final url = '$scheme://www.youtube.com/channel/${widget.channel.id}';
    launch(url).catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Oopise!'),
            content: Text('Unable to open youtube app'),
            actions: [
              TextButton(
                child: Text("That's sad!"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });
  }
}

class _PlaylistCollection extends StatefulWidget {
  final ChannelModel channel;

  const _PlaylistCollection({Key key, @required this.channel})
      : assert(channel != null),
        super(key: key);

  @override
  _PlaylistCollectionState createState() => _PlaylistCollectionState();
}

class _PlaylistCollectionState extends State<_PlaylistCollection> {
  GlobalKey<DynamicSliverListState<PlaylistModel>> _list;
  final youtube = LocatorService().youtube;
  ApiToken<PlaylistModel> _token;

  @override
  void initState() {
    super.initState();
    _list = GlobalKey<DynamicSliverListState<PlaylistModel>>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaylistModel>>(
        future: _getNext(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return SliverToBoxAdapter(child: ErrorWidget(snapshot.error));
          if (snapshot.hasData)
            return DynamicSliverList<PlaylistModel>(
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
          return SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        });
  }

  void next() => _list.currentState.displayNext();

  Future<List<PlaylistModel>> _getNext() async {
    _token = await youtube.getPlaylistsOfChannel(
      widget.channel,
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
