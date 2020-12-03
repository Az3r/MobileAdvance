import 'dart:math' show pi;

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

class SpinningLogo extends StatefulWidget {
  final bool spinning;

  const SpinningLogo({Key key, this.spinning}) : super(key: key);
  @override
  _SpinningLogoState createState() => _SpinningLogoState();
}

class _SpinningLogoState extends State<SpinningLogo>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;
  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      upperBound: 2 * pi,
      lowerBound: 0.0,
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.spinning ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutSine,
      child: AnimatedAlign(
        alignment:
            widget.spinning ? Alignment.topCenter : Alignment.bottomCenter,
        duration: const Duration(milliseconds: 300),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value,
              child: child,
            );
          },
          child: const ClipOval(
            child: Logo(
              width: 48,
              height: 48,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}
