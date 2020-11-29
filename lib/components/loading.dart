import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading();
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  var _index = 0;
  final _loadingColor = ColorTween(
    begin: Colors.amber,
    end: Colors.blue[400],
  );
  AnimationController _animation;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.reverse) {
            final next = _index + 1;
            setState((() => _index = next >= images.length ? 0 : next));
          }
        },
      );
    _play();
  }

  void _play() async {
    await _animation.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          switchInCurve: Curves.easeOutCirc,
          reverseDuration: Duration.zero,
          child: gif(_index),
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: animation,
              child: child,
            );
          },
          duration: const Duration(milliseconds: 600),
        ),
        SizedBox(height: 16),
        LayoutBuilder(builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth / 2,
            child: LinearProgressIndicator(
              minHeight: 8,
              valueColor: _animation.drive(_loadingColor),
            ),
          );
        }),
      ],
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  final images = [
    Image.asset(
      'assets/images/loading_1.gif',
      fit: BoxFit.contain,
    ),
    Image.asset(
      'assets/images/loading_2.gif',
      fit: BoxFit.contain,
    ),
    Image.asset(
      'assets/images/loading_3.gif',
      fit: BoxFit.contain,
    ),
  ];

  Widget gif(int index) {
    return Container(
      key: Key('$index'),
      width: 128,
      height: 128,
      child: images[_index],
    );
  }
}
