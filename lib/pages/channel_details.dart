import 'package:SingularSight/components/channel/channel_courses.dart';
import 'package:SingularSight/components/channel/channel_header.dart';
import 'package:SingularSight/models/channel_model.dart';
import 'package:SingularSight/utilities/globals.dart';
import 'package:flutter/material.dart';

class ChannelDetails extends StatefulWidget {
  final ChannelModel channel;

  const ChannelDetails({Key key, this.channel}) : super(key: key);

  @override
  _ChannelDetailsState createState() => _ChannelDetailsState();
}

class _ChannelDetailsState extends State<ChannelDetails> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (isScrolledToEnd()) {
        log.i('end of views');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: profileColor,
        title: Text(widget.channel.title),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.notifications),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 32.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white12,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ChannelHeader(channel: widget.channel),
                ),
              ],
            ),
          ),
          SliverChannelCourses(channelId: widget.channel.id),
        ],
      ),
    );
  }

  bool isScrolledToEnd() {
    return _controller.hasClients &&
        _controller.offset == _controller.position.maxScrollExtent;
  }

  Color get profileColor {
    return widget.channel.profileColor == '#000000'
        ? null
        : Color(
            int.parse(widget.channel.profileColor.replaceRange(0, 1, '0xFF')));
  }
}
