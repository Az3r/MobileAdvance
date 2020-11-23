import 'package:flutter/material.dart';
import 'package:SingularSight/utilities/globals.dart' show log;

/// A widget that display brief information about a specific course
class CourseMaster extends StatelessWidget {
  /// a thumbnail image representing the course
  final String thumbnail;

  /// download size of course video
  final double size;

  /// Author of the course
  final String author;

  /// title of the course
  final String title;

  /// expectaion of experience of learner
  final String level;

  /// time when this course is uploaded
  final DateTime upload;

  /// user rating for this course, from 0 -> 5
  final double rating;

  /// the number of views this course has
  final int views;

  ///
  const CourseMaster({
    Key key,
    @required this.thumbnail,
    @required this.size,
    @required this.author,
    @required this.title,
    @required this.level,
    @required this.upload,
    @required this.rating,
    @required this.views,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CourseThumbnail(
            background: Image.network(
              thumbnail,
              height: 128,
              fit: BoxFit.fill,
            ),
            videoSize: size,
          ),
          CourseInfo(
            title: title,
            author: author,
            level: level,
            views: views,
            upload: upload,
            rating: rating,
          )
        ],
      ),
    );
  }
}

/// This widget is used for [CourseMaster.thumbnail]
class CourseThumbnail extends StatefulWidget {
  /// an image representing the course
  final Widget background;

  /// the download size of the course
  final double videoSize;

  ///
  const CourseThumbnail({
    Key key,
    this.background,
    this.videoSize,
  }) : super(key: key);

  @override
  _CourseThumbnailState createState() => _CourseThumbnailState();
}

class _CourseThumbnailState extends State<CourseThumbnail> {
  /// false: display 'Bookmark' option,
  /// true: display 'Remove bookmark' option.
  bool bookmarked = false;

  /// false: display 'Download' option,
  /// true: display 'Remove download' option.
  bool downloaded = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        children: [
          widget.background,
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
                child: Icon(Icons.more_vert), onTapDown: _showAction),
          ),
          if (downloaded)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.black87,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_download),
                    Text('${widget.videoSize} GB'),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  void _showAction(TapDownDetails details) async {
    log.i(details.globalPosition);
    final position = RelativeRect.fromRect(
      details.globalPosition & const Size(64, 128),
      Offset.zero &
          Overlay.of(context).context.findRenderObject().semanticBounds.size,
    );
    log.wtf(position);
    final value = await showMenu<String>(
      items: [
        PopupMenuItem(value: 'a', child: Text('option a')),
        PopupMenuItem(value: 'b', child: Text('option b')),
        PopupMenuItem(value: 'c', child: Text('option c')),
        PopupMenuItem(value: 'd', child: Text('option d')),
      ],
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(128, 128),
        Offset.zero &
            Overlay.of(context).context.findRenderObject().semanticBounds.size,
      ),
      context: context,
    );
    log.v('selected value: $value');
  }
}

/// Widget that displays brief information of a course, see [CourseMaster]
class CourseInfo extends StatelessWidget {
  /// Author of the course
  final String author;

  /// title of the course
  final String title;

  /// expectaion of experience of learner
  final String level;

  /// time when this course is uploaded
  final DateTime upload;

  /// user rating for this course, from 0 -> 5
  final double rating;

  /// the number of views this course has
  final int views;

  ///
  const CourseInfo({
    Key key,
    @required this.author,
    @required this.title,
    @required this.level,
    @required this.upload,
    @required this.rating,
    @required this.views,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(author),
        Text(' \u{25CF}'),
        Row(
          children: [
            for (var i = 0; i < 5; ++i)
              i < rating ? Icon(Icons.star) : Icon(Icons.star_outline),
            Text('($views)'),
          ],
        ),
      ],
    );
  }
}
