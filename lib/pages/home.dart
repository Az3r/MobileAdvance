import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:SingularSight/utilities/constants.dart';
import 'package:flutter/material.dart';
import '../services/locator_service.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  final youtube = LocatorService().youtube;
  final users = LocatorService().users;

  final _list = GlobalKey<AnimatedListState>();
  final widgets = <Widget>[];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    youtube.searchPlaylists(pageSize: 10).forEach((value) {
      widgets.add(_buildItem(value));
      _list.currentState.insertItem(widgets.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _refreshList,
      child: AnimatedList(
        key: _list,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .animate(animation),
            child: SlideTransition(
              position: Tween(begin: Offset(0, -0.10), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOut))
                  .animate(animation),
              child: widgets[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(PlaylistModel playlist) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(
              RouteNames.watch,
              arguments: playlist,
            ),
            child: Container(
              height: playlist.thumbnails.high.height.toDouble() - 64,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    playlist.thumbnails.high.url,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      width: 128,
                      color: Colors.black.withOpacity(0.5),
                      child: Text('${playlist.videoCount} videos'),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(
              RouteNames.channelDetails,
              arguments: playlist.channel,
            ),
            child: Row(
              children: [
                Hero(
                  tag: playlist.channel.id,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      playlist.channel.thumbnails.default_.url,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    isThreeLine: true,
                    title: Text(
                      playlist.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(playlist.channel.title +
                        (playlist.channel.subscriberCount == null
                            ? ''
                            : '\n${playlist.channel.subscriberCount} subscribers')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _refreshList() async {
    while (widgets.isNotEmpty) {
      final item = widgets.removeAt(0);
      _list.currentState.removeItem(
        0,
        (context, animation) => FadeTransition(
          opacity: Tween(begin: 0.0, end: 0.0).animate(animation),
          child: item,
        ),
      );
    }
    await load();
  }
}
