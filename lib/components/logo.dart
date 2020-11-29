import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double width;
  final double height;

  const Logo({
    Key key,
    this.width = double.infinity,
    this.height = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: width,
        height: height,
        child: image,
      ),
    );
  }

  Widget get image {
    return Image.asset(
      'assets/icons/icon.jpeg',
      fit: BoxFit.contain,
    );
  }
}
