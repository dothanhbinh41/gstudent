import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class StripePainter extends CustomPainter {
  double progress;
  double distance;
  double height;
  StripePainter({@required this.progress,this.distance,this.height});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    drawRRect(
      canvas,
      distance,
      path: squarePath(
        position: Offset(0, height+2),
        size: Size((size.width)*progress, height),
      ),
      color: HexColor("#f8de47"),

    );
  }

  Rect rect;
  Path squarePath({@required Offset position, @required Size size}) {
    double widthf = size.width ;
    double heightf = size.height ;
    var start = position - Offset(0, heightf);
    var end = position + Offset(widthf, 0);
    rect = Rect.fromPoints(start, end);
    Path _path = Path();
    RRect rrect = RRect.fromRectAndRadius(
        rect, Radius.circular(1));
    _path.addRRect(rrect);
    return _path;
  }

  void drawRRect(Canvas canvas,double dis, {@required Path path, @required Color color}) {
    double distance = dis;
    double stroke = 9;
    Offset position = path.getBounds().centerLeft;
    double widthf = path.getBounds().width;
    double heightf = path.getBounds().height ;
    final gradient = new LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.repeated,
      colors: [ HexColor("#fcf25b"), HexColor("#efb71f")],
    );

    var paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
    Path _path = Path();
    _path.moveTo(position.dx, position.dy);
    for (int i = 0; i < widthf / distance * 2; i++) {
      _path.relativeMoveTo(-distance * i, 0);
      _path.relativeMoveTo(widthf, -heightf);
      _path.relativeLineTo(-widthf/(5*progress), heightf * 2);
      _path.moveTo(position.dx, position.dy);

      _path.relativeMoveTo(distance * i, 0);
      _path.relativeMoveTo(widthf, -heightf);
      _path.relativeLineTo(-widthf /(5*progress), heightf * 2);
      _path.moveTo(position.dx, position.dy);
    }
    canvas.save();
    canvas.clipPath(path);

    final gradient2 = new LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.repeated,
      colors: [HexColor("#ffffb5"),
        HexColor("#ffff40"),],
    );


    canvas.drawPath(
        _path..fillType = PathFillType.evenOdd,
        Paint()
          ..shader = gradient2.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke);
    canvas.restore();
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
   return true;
  }

}