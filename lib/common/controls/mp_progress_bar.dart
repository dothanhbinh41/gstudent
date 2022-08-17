import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';

class MpProgressbar extends StatefulWidget {
  int exp;
  int nextLevel;

  MpProgressbar({this.exp, this.nextLevel});

  @override
  State<StatefulWidget> createState() => MpProgressbarState(exp: this.exp,  nextLevel:this.nextLevel);
}

class MpProgressbarState extends State<MpProgressbar> {
  int exp;
  int nextLevel;
  MpProgressbarState({this.exp, this.nextLevel});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 14,
        child: Stack(
          children: [
            Positioned(
              child: Image(
                image: AssetImage('assets/images/mp_bar.png'),
                fit: BoxFit.fill,
              ),
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
            ),
            Positioned(
                child: MPProgressBar(
                  direction: Axis.horizontal,
                  currentValue: exp ,
                  maxValue: nextLevel,
                ),
                top: 2,
                bottom: 2,
                right: 4,
                left: 2),
            // Positioned(
            //   child: textpaintingBoldBase(exp.toString(), 8, Colors.white, Colors.black, 2),
            //   bottom: 0,
            //   left: 16,
            // ),
          ],
        ));
  }
}

class MPProgressBar extends StatefulWidget {
  MPProgressBar({
    Key key,
    this.currentValue = 0,
    this.maxValue = 100,
    this.size = 12,
    this.animatedDuration = const Duration(milliseconds: 1000),
    this.direction = Axis.horizontal,
    this.verticalDirection = VerticalDirection.down,
    BorderRadiusGeometry borderRadius,
    this.border,
    this.backgroundColor = const Color(0x00FFFFFF),
    this.progressColor = const Color(0xFFFA7268),
    this.changeColorValue,
    this.changeProgressColor = const Color(0xFF5F4B8B),
    this.displayText,
    this.displayTextStyle = const TextStyle(color: const Color(0xFFFFFFFF), fontSize: 12, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold),
  })  : _borderRadius = borderRadius ??
            BorderRadius.only(
              bottomLeft: Radius.zero,
              bottomRight: Radius.circular(24),
              topLeft: Radius.zero,
              topRight: Radius.zero,
            ),
        super(key: key);
  final int currentValue;
  final int maxValue;
  final double size;
  final Duration animatedDuration;
  final Axis direction;
  final VerticalDirection verticalDirection;
  final BorderRadiusGeometry _borderRadius;
  final BoxBorder border;
  final Color backgroundColor;
  final Color progressColor;
  final int changeColorValue;
  final Color changeProgressColor;
  final String displayText;
  final TextStyle displayTextStyle;

  @override
  _FAProgressBarState createState() => _FAProgressBarState();
}

class _FAProgressBarState extends State<MPProgressBar> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  double _currentBegin = 0;
  double _currentEnd = 0;

  @override
  void initState() {
    _controller = AnimationController(duration: widget.animatedDuration, vsync: this);
    _animation = Tween<double>(begin: _currentBegin, end: _currentEnd).animate(_controller);
    triggerAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(MPProgressBar old) {
    triggerAnimation();
    super.didUpdateWidget(old);
  }

  void triggerAnimation() {
    setState(() {
      _currentBegin = _animation.value;

      if (widget.currentValue == 0 || widget.maxValue == 0) {
        _currentEnd = 0;
      } else {
        _currentEnd = widget.currentValue / widget.maxValue;
      }

      _animation = Tween<double>(begin: _currentBegin, end: _currentEnd).animate(_controller);
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedProgressBar(
        animation: _animation,
        widget: widget,
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedProgressBar extends AnimatedWidget {
  AnimatedProgressBar({
    Key key,
    Animation<double> animation,
    this.widget,
  }) : super(key: key, listenable: animation);

  final MPProgressBar widget;

  double transformValue(x, begin, end, before) {
    double y = (end * x - (begin - before)) * (1 / before);
    return y < 0 ? 0 : ((y > 1) ? 1 : y);
  }

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    Color progressColor = widget.progressColor;

    if (widget.changeColorValue != null) {
      final _colorTween = ColorTween(
        begin: widget.progressColor,
        end: widget.changeProgressColor,
      );

      progressColor = _colorTween.transform(transformValue(
        animation.value,
        widget.changeColorValue,
        widget.maxValue,
        5,
      ));
    }

    List<Widget> progressWidgets = [];
    Widget progressWidget = Container(
        child: ClipPath(
      clipper: ParallelogramClipper(),
      child: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [HexColor("#69EBF6"), HexColor("#41B7C1")])),
      ),
    ));
    progressWidgets.add(progressWidget);

    if (widget.displayText != null) {
      Widget textProgress = Container(
        alignment: widget.direction == Axis.horizontal ? FractionalOffset(0.95, 0.5) : (widget.verticalDirection == VerticalDirection.up ? FractionalOffset(0.5, 0.05) : FractionalOffset(0.5, 0.95)),
        child: Text(
          (animation.value * widget.maxValue).toInt().toString() + widget.displayText,
          softWrap: false,
          style: widget.displayTextStyle,
        ),
      );
      progressWidgets.add(textProgress);
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: widget.direction == Axis.vertical ? widget.size : null,
        height: widget.direction == Axis.horizontal ? widget.size : null,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget._borderRadius,
          border: widget.border,
        ),
        child: Flex(
          direction: widget.direction,
          verticalDirection: widget.verticalDirection,
          children: <Widget>[
            Expanded(
              flex: (animation.value * 100).toInt(),
              child: Stack(
                children: progressWidgets,
              ),
            ),
            Expanded(
              flex: 100 - (animation.value * 100).toInt(),
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
//
// class ParallelogramClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var w = size.width;
//     final path = Path()
//       ..lineTo(0, size.height )
//       ..lineTo(size.width > 16 ? size.width -8 : 0, size.height)
//       ..lineTo(size.width , 0.0)
//       ..lineTo(size.width, 0.0)
//       ..close();
//     return path;
//
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

class ParallelogramClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width > 16 ? size.width - 5 : 0, size.height)
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
