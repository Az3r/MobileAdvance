import 'package:SingularSight/models/playlist_model.dart';
import 'package:SingularSight/services/locator_service.dart';
import 'package:flutter/material.dart';

class SliverChannelCourses extends StatefulWidget {
  final String channelId;
  final int initialCount;

  const SliverChannelCourses({
    Key key,
    this.channelId,
    this.initialCount = 10,
  }) : super(key: key);

  @override
  _SliverChannelCoursesState createState() => _SliverChannelCoursesState();
}

class _SliverChannelCoursesState extends State<SliverChannelCourses> {
  final youtube = LocatorService().youtube;
  final _list = GlobalKey<SliverAnimatedListState>();

  final videos = <PlaylistModel>[];

  @override
  void initState() {
    super.initState();
    youtube.findPlaylistByChannel(widget.channelId).forEach((element) {
      videos.add(element);
      _list.currentState.insertItem(videos.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _list,
      itemBuilder: (context, index, animation) {
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut))
              .animate(animation),
          child: _buildItem(videos[index]),
        );
      },
    );
  }

  Widget _buildItem(PlaylistModel playlist) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8,
      ),
      child: Row(
        children: [
          SizedBox(
              width: playlist.thumbnails.default_.width.toDouble(),
              height: playlist.thumbnails.default_.height.toDouble(),
              child: Image.network(playlist.thumbnails.default_.url)),
          SizedBox(width: 8),
          Expanded(
            child: ListTile(
              isThreeLine: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                playlist.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                  '${playlist.channel.title}\n${playlist.videoCount} videos'),
            ),
          ),
        ],
      ),
    );
  }

  /// load [count] more videos,
  /// ususally called when user has scrolled to end of list
  void next(int count) {

  }
}
