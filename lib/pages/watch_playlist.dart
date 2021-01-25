import 'dart:async';
import 'dart:io';

import 'package:SingularSight/components/list.dart';
import 'package:SingularSight/components/video_playlist.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/models/video_model.dart';
import 'package:SingularSight/services/api_service.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/youtube/v3.dart';
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
  const WatchPlaylist({
    Key key,
    @required this.playlist,
  })  : assert(playlist != null),
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
          );
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _MainWidget extends StatefulWidget {
  final PlaylistModel playlist;
  final ApiToken<VideoModel> initialToken;

  const _MainWidget({
    Key key,
    @required this.playlist,
    @required this.initialToken,
  })  : assert(playlist != null),
        assert(initialToken != null),
        super(key: key);

  @override
  __MainWidgetState createState() => __MainWidgetState();
}

class __MainWidgetState extends State<_MainWidget> {
  YoutubePlayerController _player;
  VideoModel _currentVideo;

  @override
  void initState() {
    super.initState();

    _currentVideo = widget.initialToken.items[0];

    _player = YoutubePlayerController(
      initialVideoId: _currentVideo.id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        forceHD: false,
        controlsVisibleAtStart: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return _LandscapeView(player: _player);
          } else {
            return _PortraitView(
              player: _player,
              playlist: widget.playlist,
              initialToken: widget.initialToken,
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class _LandscapeView extends StatefulWidget {
  final YoutubePlayerController player;
  const _LandscapeView({
    Key key,
    @required this.player,
  })  : assert(player != null),
        super(key: key);

  @override
  __LandscapeViewState createState() => __LandscapeViewState();
}

class __LandscapeViewState extends State<_LandscapeView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(child: YoutubePlayer(controller: widget.player));
  }

  @override
  bool get wantKeepAlive => true;
}

class _PortraitView extends StatefulWidget {
  final PlaylistModel playlist;
  final ApiToken<VideoModel> initialToken;
  final YoutubePlayerController player;
  _PortraitView({
    Key key,
    @required this.player,
    @required this.playlist,
    this.initialToken,
  })  : assert(player != null),
        assert(playlist != null),
        super(key: key);

  @override
  _PortraitViewState createState() => _PortraitViewState();
}

class _PortraitViewState extends State<_PortraitView>
    with AutomaticKeepAliveClientMixin {
  final _list = GlobalKey<_VideoCollectionState>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        YoutubePlayer(controller: widget.player),
        Expanded(
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              _list.currentState.next();
              return true;
            },
            child: CustomScrollView(
              slivers: [
                _SliverVideoDetail(
                  video: null,
                  onWatchOnYoutube: () => _openYoutubeVideo(null),
                ),
                _SliverChannelDetail(channel: widget.playlist.channel),
                _VideoCollection(
                  playlist: widget.playlist,
                  initialToken: widget.initialToken,
                ),
              ],
            ),
          ),
        ),
      ],
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
  final VideoModel video;
  final VoidCallback onWatchOnYoutube;
  const _SliverVideoDetail({
    Key key,
    @required this.video,
    this.onWatchOnYoutube,
  })  : assert(video != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: typo.Title(text: video.viewCount.toVideoViewFormat()),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: () => _openDescription(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: typo.Subtitle(
            text: '''${video.viewCount.toVideoViewFormat()} - 
                ${DateTime.now().difference(video.publishedAt).toVideoPublishFormat()}''',
          ),
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
              offIcon: Icon(Icons.bookmark_outline),
              onIcon:
                  Icon(Icons.bookmarks, color: Theme.of(context).accentColor),
              onLabel: 'Unbookmark',
              offLabel: 'Bookmark',
            ),
            _VideoSwitchAction(
              offIcon: Icon(Icons.favorite_outline),
              onIcon:
                  Icon(Icons.favorite, color: Theme.of(context).accentColor),
              onLabel: 'Unfavorite',
              offLabel: 'Favorite',
            ),
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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Expanded(child: ch.ShortThumbnail.h(channel: channel)),
          ElevatedButton(
            child: Text('SUBSCRIBE'),
            onPressed: () => _openYoutubeChannel(context),
          ),
        ]),
      ),
    );
  }

  void _openYoutubeChannel(BuildContext context) async {
    final scheme = Platform.isIOS ? 'youtube' : 'https';
    final url = '$scheme://www.youtube.com/channel/${channel.id}';
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

class _VideoCollection extends StatefulWidget {
  final PlaylistModel playlist;
  final ApiToken<VideoModel> initialToken;

  const _VideoCollection({
    Key key,
    @required this.playlist,
    this.initialToken,
  })  : assert(playlist != null),
        super(key: key);

  @override
  _VideoCollectionState createState() => _VideoCollectionState();
}

class _VideoCollectionState extends State<_VideoCollection> {
  final _list = GlobalKey<DynamicSliverListState<VideoModel>>();
  final youtube = LocatorService().youtube;
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
      itemBuilder: (context, index, data) => InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(RouteNames.watch, arguments: data),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _VideoWidget(
            video: data,
          ),
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
  const _VideoWidget({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
              typo.Title(text: video.title),
              typo.Subtitle(text: video.viewCount.toVideoViewFormat())
            ],
          ),
        ),
      ],
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
  final ValueChanged<bool> onValueChanged;
  _VideoSwitchAction({
    Key key,
    @required this.onIcon,
    @required this.offIcon,
    this.onValueChanged,
    this.onLabel = '',
    this.offLabel = '',
  })  : assert(onLabel != null),
        assert(offLabel != null),
        assert(onIcon != null),
        assert(offIcon != null),
        super(key: key);

  @override
  _VideoSwitchActionState createState() => _VideoSwitchActionState();
}

class _VideoSwitchActionState extends State<_VideoSwitchAction> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
