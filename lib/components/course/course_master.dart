import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class CourseMaster extends StatelessWidget {
  final Widget background;
  final double size;
  final String author;
  final String title;
  final String level;
  final DateTime upload;

  const CourseMaster({
    Key key,
    @required this.background,
    @required this.size,
    @required this.author,
    @required this.title,
    @required this.level,
    @required this.upload,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256.0,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 128.0,
              child: Stack(
                children: [
                  Image.network(
                    'https://images.dog.ceo/breeds/cotondetulear/IMAG1063.jpg',
                    width: 256.0,
                    fit: BoxFit.fill,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.more_vert,
                      size: 16,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text('abc'),
                  ),
                ],
              ),
            ),
            for (final item in data) Text(item),
            Row(
              children: [
                for (var i = 0; i < 5; ++i) Icon(Icons.star, size: 8.0),
                Text(
                  randomBetween(1, 1000).toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final data = [for (var i = 0; i < 3; i++) randomString(50)];
