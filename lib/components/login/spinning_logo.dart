import 'package:SingularSight/components/logo.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi;

class SpinningLogo extends StatefulWidget {
  final bool submitting;

  const SpinningLogo({Key key, this.submitting}) : super(key: key);
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
      opacity: widget.submitting ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutSine,
      child: AnimatedAlign(
        alignment:
            widget.submitting ? Alignment.topCenter : Alignment.bottomCenter,
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
