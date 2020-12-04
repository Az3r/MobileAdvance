import 'package:flutter/material.dart';

class SlideLeftWithFade extends StatelessWidget {
  final Animation animation;
  final Widget child;

  const SlideLeftWithFade({
    Key key,
    @required this.animation,
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween(begin: Offset(0.25, 0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOut))
          .animate(animation),
      child: FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut))
              .animate(animation),
          child: child),
    );
  }
}

class SlideDownWithFade extends StatelessWidget {
  final Animation animation;
  final Widget child;

  const SlideDownWithFade({
    Key key,
    @required this.animation,
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(animation),
      child: SlideTransition(
        position: Tween(begin: Offset(0, -0.10), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(animation),
        child: child,
      ),
    );
  }
}

class SlideUpWidthFade extends StatelessWidget {
  final Animation animation;
  final Widget child;

  const SlideUpWidthFade({
    Key key,
    @required this.animation,
    this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(animation),
      child: SlideTransition(
        position: Tween(begin: Offset(0, 0.10), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(animation),
        child: child,
      ),
    );
  }
}
