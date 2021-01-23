import 'dart:io';

import 'package:SingularSight/components/errors.dart';
import 'package:SingularSight/components/list.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
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
  final _list = GlobalKey<DynamicSliverListState<PlaylistModel>>();
  final youtube = LocatorService().youtube;
  ApiToken<PlaylistModel> _token;

  @override
  Widget build(BuildContext context) {
    return DynamicSliverList<PlaylistModel>(
      key: _list,
      getNext: _getNext,
      itemBuilder: (context, index, data) => InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _PlaylistWidget.h(
            playlist: data,
          ),
        ),
      ),
    );
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
  final bool _v;
  const _PlaylistWidget.v({Key key, this.playlist})
      : _v = true,
        super(key: key);
  const _PlaylistWidget.h({Key key, this.playlist})
      : _v = false,
        super(key: key);

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
          child: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Thumbnail get _thumbnail => playlist.thumbnails.medium;
}
