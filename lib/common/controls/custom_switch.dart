import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class CustomSwitch extends StatefulWidget {
  bool value;
  ValueChanged<bool> onChanged;
  Color activeColor;
  Color inactiveColor = Colors.grey;
  String activeText = 'On';
  String inactiveText = 'Off';
  Color activeTextColor = Colors.white70;
  Color inactiveTextColor = Colors.white70;

  CustomSwitch({
    Key key,
    this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeText,
    this.inactiveText,
    this.activeTextColor,
    this.inactiveTextColor})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 70.0,
            height: 35.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: _circleAnimation.value == Alignment.centerLeft
                    ? widget.inactiveColor
                    : widget.activeColor),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4.0, right: 4.0, left: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _circleAnimation.value == Alignment.centerRight
                      ? Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Text(
                      widget.activeText,
                      style: TextStyle(
                          color: widget.activeTextColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SourceSerifPro',
                          fontSize: 16.0),
                    ),
                  )
                      : Container(),
                  Align(
                    alignment: _circleAnimation.value,
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: _circleAnimation.value == Alignment.centerRight ?HexColor("#00d431") :  HexColor("#777777")),
                    ),
                  ),
                  _circleAnimation.value == Alignment.centerLeft
                      ? Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 5.0),
                    child: Text(
                      widget.inactiveText,
                      style: TextStyle(
                          color: widget.inactiveTextColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'SourceSerifPro',
                          fontSize: 16.0),
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}