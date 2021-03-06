import 'dart:async';
import 'dart:io';

import 'package:SingularSight/components/list.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/firebase_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/container/v1.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../styles/texts.dart' as styles;
import 'package:SingularSight/components/image.dart' as img;
import 'package:SingularSight/components/typography.dart' as typo;
import 'package:SingularSight/components/channel.dart' as ch;
import 'package:SingularSight/utilities/type_extension.dart';

class WatchPlaylist extends StatelessWidget {
  final PlaylistModel playlist;
  final int initialVideoIndex;
  const WatchPlaylist({
    Key key,
    @required this.playlist,
    this.initialVideoIndex = 0,
  })  : assert(playlist != null),
        assert(initialVideoIndex != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiToken<VideoModel>>(
      future: LocatorService().youtube.getVideosFromPlaylist(playlist),
      builder: (context, snapshot) {
        if (snapshot.hasError) return ErrorWidget(snapshot.error);
        if (snapshot.hasData)
          return _MainWidget(
            playlist: playlist,
            initialToken: snapshot.data,
            initialVideoIndex: initialVideoIndex,
          );
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _MainWidget extends StatefulWidget {
  final PlaylistModel playlist;
  final ApiToken<VideoModel> initialToken;
  final int initialVideoIndex;

  const _MainWidget({
    Key key,
    @required this.playlist,
    @required this.initialToken,
    this.initialVideoIndex = 0,
  })  : assert(playlist != null),
        assert(initialToken != null),
        assert(initialVideoIndex != null),
        super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<_MainWidget> {
  YoutubePlayerController _player;

  @override
  void initState() {
    super.initState();

    _player = YoutubePlayerController(
      initialVideoId: widget.initialToken.items[widget.initialVideoIndex].id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        forceHD: false,
        controlsVisibleAtStart: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: OrientationBuilder(
          builder: (context, orientation) {
            return Column(
              children: [
                YoutubePlayer(
                  controller: _player,
                ),
                if (orientation == Orientation.portrait)
                  Expanded(
                    child: _PortraitView(
                      player: _player,
                      playlist: widget.playlist,
                      initialToken: widget.initialToken,
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class _PortraitView extends StatefulWidget {
  final PlaylistModel playlist;
  final ApiToken<VideoModel> initialToken;
  final int initialVideoIndex;
  final YoutubePlayerController player;
  _PortraitView({
    Key key,
    @required this.playlist,
    @required this.player,
    this.initialToken,
    this.initialVideoIndex = 0,
  })  : assert(playlist != null),
        assert(player != null),
        assert(initialVideoIndex != null),
        super(key: key);

  @override
  _PortraitViewState createState() => _PortraitViewState();
}

class _PortraitViewState extends State<_PortraitView>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<_VideoCollectionState> _list;
  VideoModel _currentVideo;

  @override
  void initState() {
    super.initState();
    _list = GlobalKey();
    _currentVideo = widget.initialToken.items[widget.initialVideoIndex];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        _list.currentState.next();
        return true;
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: _SliverVideoDetail(
              playlistId: widget.playlist.id,
              video: _currentVideo,
              onWatchOnYoutube: () => _openYoutubeVideo(_currentVideo.id),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            sliver: _SliverChannelDetail(channel: widget.playlist.channel),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            sliver: SliverToBoxAdapter(
              child: Divider(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(64),
                thickness: 0.7,
              ),
            ),
          ),
          _VideoCollection(
            key: _list,
            playlist: widget.playlist,
            initialToken: widget.initialToken,
            onVideoSelected: (video) {
              widget.player.load(video.id);
              setState(() => _currentVideo = video);
            },
          ),
        ],
      ),
    );
  }

  void _openYoutubeVideo(String videoId) async {
    final scheme = Platform.isIOS ? 'youtube' : 'https';
    final url =
        '$scheme://www.youtube.com/watch?v=${videoId}&list=${widget.playlist.id}';
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _SliverVideoDetail extends StatelessWidget {
  final String playlistId;
  final VideoModel video;
  final VoidCallback onWatchOnYoutube;
  const _SliverVideoDetail({
    Key key,
    @required this.video,
    this.onWatchOnYoutube,
    @required this.playlistId,
  })  : assert(video != null),
        assert(playlistId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Row(
          children: [
            Expanded(
              child: typo.Title(text: video.title),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () => _openDescription(context),
            ),
          ],
        ),
        typo.Subtitle(
          text:
              '${video.viewCount.toVideoViewFormat()} - ${DateTime.now().difference(video.publishedAt).toVideoPublishFormat()}',
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _VideoAction(
              icon: Icon(Icons.thumb_up),
              label: video.likeCount.toCountingFormat(),
            ),
            _VideoAction(
              icon: Icon(Icons.thumb_down),
              label: video.dislikeCount.toCountingFormat(),
            ),
            _VideoSwitchAction(
              toggled: observeBookmark(playlistId),
              offIcon: Icon(Icons.bookmark_outline),
              onIcon:
                  Icon(Icons.bookmark, color: Theme.of(context).accentColor),
              onLabel: 'Unbookmark',
              offLabel: 'Bookmark',
              onValueChanged: (value) {
                if (value)
                  FirebaseService().addToWatchLaters(playlistId);
                else
                  FirebaseService().removeFromWatchLater([playlistId]);
              },
            ),
            _VideoSwitchAction(
              toggled: observeFavorite(playlistId),
              offIcon: Icon(Icons.favorite_outline),
              onIcon:
                  Icon(Icons.favorite, color: Theme.of(context).accentColor),
              onLabel: 'Unfavorite',
              offLabel: 'Favorite',
              onValueChanged: (value) {
                if (value)
                  FirebaseService().addToFavorites(playlistId);
                else
                  FirebaseService().removeFromFavorites([playlistId]);
              },
            )
          ],
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
            ),
            label: Text('WATCH ON YOUTUBE'),
            icon: Icon(FontAwesomeIcons.youtube),
            onPressed: onWatchOnYoutube,
          ),
          width: 480,
        ),
      ]),
    );
  }

  Future<bool> observeFavorite(String playlistId) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .where(FieldPath.documentId, isEqualTo: playlistId)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<bool> observeBookmark(String playlistId) async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final query = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('watch_laters')
        .where(FieldPath.documentId, isEqualTo: playlistId)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  void _openDescription(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(video.title, style: styles.headline(context)),
                  const SizedBox(height: 16),
                  Text(video.description),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
    ;
  }
}

class _SliverChannelDetail extends StatelessWidget {
  final ChannelModel channel;
  const _SliverChannelDetail({
    Key key,
    @required this.channel,
  })  : assert(channel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        SizedBox(
          child: ch.ShortThumbnail.h(channel: channel),
          height: 48,
        ),
      ]),
    );
  }
}

class _VideoCollection extends StatefulWidget {
  final ValueChanged<VideoModel> onVideoSelected;
  final PlaylistModel playlist;
  final ApiToken<VideoModel> initialToken;

  const _VideoCollection({
    Key key,
    @required this.playlist,
    this.initialToken,
    this.onVideoSelected,
  })  : assert(playlist != null),
        super(key: key);

  @override
  _VideoCollectionState createState() => _VideoCollectionState();
}

class _VideoCollectionState extends State<_VideoCollection> {
  final _list = GlobalKey<DynamicSliverListState<VideoModel>>();
  final youtube = LocatorService().youtube;
  var _selected = 0;
  ApiToken<VideoModel> _token;

  @override
  void initState() {
    super.initState();
    _token = widget.initialToken;
  }

  @override
  Widget build(BuildContext context) {
    return DynamicSliverList<VideoModel>(
      key: _list,
      getNext: _getNext,
      initialItems: widget.initialToken.items,
      itemBuilder: (context, index, data) => InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(RouteNames.watch, arguments: data),
        child: _VideoWidget(
          key: Key(data.id),
          video: data,
          selected: index == _selected,
          onPressed: () {
            widget?.onVideoSelected(data);
            setState(() => _selected = index);
          },
        ),
      ),
    );
  }

  void next() => _list.currentState.displayNext();

  Future<List<VideoModel>> _getNext() async {
    _token = await youtube.getVideosFromPlaylist(
      widget.playlist,
      nextToken: _token?.nextToken,
    );
    return _token.items;
  }
}

class _VideoWidget extends StatelessWidget {
  final VideoModel video;
  final bool selected;
  final VoidCallback onPressed;
  const _VideoWidget({
    Key key,
    @required this.video,
    @required this.selected,
    this.onPressed,
  })  : assert(video != null),
        assert(selected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        color:
            selected ? Theme.of(context).selectedRowColor.withAlpha(64) : null,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 128,
              child: img.ThumbnailImage(thumbnail: video.thumbnails.medium),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  typo.Subtitle(text: video.viewCount.toVideoViewFormat()),
                  typo.Subtitle(
                      text: DateTime.now()
                          .difference(video.publishedAt)
                          .toVideoPublishFormat())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoAction extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onPressed;
  const _VideoAction({
    Key key,
    @required this.icon,
    this.label = '',
    this.onPressed,
  })  : assert(icon != null),
        assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [icon, const SizedBox(height: 8), typo.Subtitle(text: label)],
      ),
    );
  }
}

class _VideoSwitchAction extends StatefulWidget {
  final Icon onIcon;
  final Icon offIcon;
  final String onLabel;
  final String offLabel;
  final Future<bool> toggled;
  final ValueChanged<bool> onValueChanged;
  _VideoSwitchAction({
    Key key,
    @required this.onIcon,
    @required this.offIcon,
    @required this.toggled,
    this.onValueChanged,
    this.onLabel = '',
    this.offLabel = '',
  })  : assert(onLabel != null),
        assert(offLabel != null),
        assert(onIcon != null),
        assert(offIcon != null),
        assert(toggled != null),
        super(key: key);

  @override
  _VideoSwitchActionState createState() => _VideoSwitchActionState();
}

class _VideoSwitchActionState extends State<_VideoSwitchAction> {
  bool _toggled;
  @override
  void initState() {
    super.initState();
    _toggled = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.toggled != null)
      widget.toggled.then((value) => setState(() => _toggled = value));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final value = !_toggled;
        setState(() => _toggled = value);
        widget.onValueChanged?.call(value);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggled ? widget.onIcon : widget.offIcon,
          const SizedBox(height: 8),
          typo.Subtitle(text: _toggled ? widget.onLabel : widget.offLabel),
        ],
      ),
    );
  }
}
