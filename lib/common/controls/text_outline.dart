import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final Text text;
  final List<OutlinedTextStroke> strokes;

  const OutlinedText({Key key, this.text, this.strokes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    final list = strokes ?? [];
    double widthSum = 0;
    for (var i = 0; i < list.length; i++) {
      widthSum += list[i].width ?? 0;
      children.add(Text(text?.data ?? '',
          textAlign: text?.textAlign,
          style: (text?.style ?? TextStyle()).copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = widthSum
                ..color = list[i].color ?? Colors.transparent)));
    }

    return Stack(
      children: [...children.reversed, text ?? SizedBox.shrink()],
    );
  }
}

class OutlinedTextStroke {
  final Color color;
  final double width;

  OutlinedTextStroke({this.color, this.width});
}

