import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingProgress extends StatelessWidget {
  final double strokeWidth;
  final Color color;

  const LoadingProgress({Key key, this.strokeWidth = 2, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: color == null ? null : AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _JumpingDot extends AnimatedWidget {
  final Color color;
  final double fontSize;
  _JumpingDot({Key key, Animation<double> animation, this.color, this.fontSize})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
      padding: EdgeInsets.only(bottom: animation.value),
      child: Text(
        '.',
        style: TextStyle(color: color, fontSize: fontSize),
      ),
    );
  }
}

class JumpingDotsProgressIndicator extends StatefulWidget {
  final int numberOfDots;
  final double fontSize;
  final double dotSpacing;
  final Color color;
  final int milliseconds;
  final double jumpHeight;
  final double beginTweenValue = 0.0;

  const JumpingDotsProgressIndicator({
    Key key,
    this.numberOfDots = 3,
    this.fontSize = 10.0,
    this.color = Colors.black,
    this.dotSpacing = 0.0,
    this.milliseconds = 250,
    this.jumpHeight = 8.0,
  }) : super(key: key);

  @override
  _JumpingDotsProgressIndicatorState createState() =>
      _JumpingDotsProgressIndicatorState(
        numberOfDots: this.numberOfDots,
        fontSize: this.fontSize,
        color: this.color,
        dotSpacing: this.dotSpacing,
        milliseconds: this.milliseconds,
      );
}

class _JumpingDotsProgressIndicatorState
    extends State<JumpingDotsProgressIndicator> with TickerProviderStateMixin {
  int numberOfDots;
  int milliseconds;
  double fontSize;
  double dotSpacing;
  Color color;
  List<AnimationController> controllers = new List<AnimationController>();
  List<Animation<double>> animations = new List<Animation<double>>();
  List<Widget> _widgets = new List<Widget>();

  _JumpingDotsProgressIndicatorState({
    this.numberOfDots,
    this.fontSize,
    this.color,
    this.dotSpacing,
    this.milliseconds,
  });

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numberOfDots; i++) {
      _addAnimationControllers();
      _buildAnimations(i);
      _addListOfDots(i);
    }
    controllers[0].forward();
  }

  void _addAnimationControllers() {
    controllers.add(AnimationController(
        duration: Duration(milliseconds: milliseconds), vsync: this));
  }

  void _addListOfDots(int index) {
    _widgets.add(Padding(
      padding: EdgeInsets.only(right: dotSpacing),
      child: _JumpingDot(
        animation: animations[index],
        fontSize: fontSize,
        color: color,
      ),
    ));
  }

  void _buildAnimations(int index) {
    animations.add(Tween(begin: widget.beginTweenValue, end: widget.jumpHeight)
        .animate(controllers[index])
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed)
              controllers[index].reverse();
            if (index == numberOfDots - 1 &&
                status == AnimationStatus.dismissed) {
              controllers[0].forward();
            }
            if (animations[index].value > widget.jumpHeight / 2 &&
                index < numberOfDots - 1) {
              controllers[index + 1].forward();
            }
          }));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _widgets,
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < numberOfDots; i++) controllers[i].dispose();
    super.dispose();
  }
}
