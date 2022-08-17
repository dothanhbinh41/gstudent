import 'package:flutter/material.dart';
import 'package:gstudent/common/styles/theme_text.dart';

class ExpandableText extends StatefulWidget {
  final double height;
  final double maxHeight;
  final double dividerHeight;
  final double dividerSpace;
  final String child;

  const ExpandableText({
    Key key,
    @required this.child,
    this.height = 80,
    this.maxHeight ,
    this.dividerHeight = 6,
    this.dividerSpace = 2,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  double _height, _maxHeight, _dividerHeight, _dividerSpace;

  @override
  void initState() {
    super.initState();
    _height = widget.height;
    _maxHeight = widget.maxHeight;
    _dividerHeight = widget.dividerHeight;
    _dividerSpace = widget.dividerSpace;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _maxHeight,
      child:Column(
        children: <Widget>[
          SizedBox(
            height: _height,
            child: Container(child: ListView(
              children: [
                textQuestion(widget.child)
              ],
            ),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8)
              ),
            ),
          ),
          SizedBox(height: _dividerSpace),
          Container(
            height: _dividerHeight,
            width: 60,
            child: GestureDetector(
              child: Container( decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4)
              ),),
              onPanUpdate: (details) {
                setState(() {
                  _height += details.delta.dy;

                  // prevent overflow if height is more/less than available space
                  var maxLimit = _maxHeight - _dividerHeight - _dividerSpace;
                  var minLimit = 44.0;

                  if (_height > maxLimit)
                    _height = maxLimit;
                  else if (_height < minLimit)
                    _height = minLimit;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  textQuestion(String title) {
    if (title.contains("<b>") || title.contains("</b>")) {
      var lst = title.split(' ');
      var listBold = lst.where((element) => element.contains("<b>") || element.contains("</b>")).toList();
      var indexFirst = lst.indexOf(listBold.first);
      var indexLast = lst.indexOf(listBold.last);
      return RichText(
        text: TextSpan(children: [
          if (lst.length > 0)
            for (int i = 0; i < lst.length; i++)
              if (i > indexFirst && i < indexLast)
                TextSpan(
                    text: lst[i] + ' ', style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: Colors.white, decoration: TextDecoration.underline))
              else if (i == indexFirst || i == indexLast)
                TextSpan(text: ' ', style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: Colors.white, decoration: TextDecoration.underline))
              else
                TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleNormal(textColors: Colors.white))
        ]),
      );
    } else if (title.contains("#")) {
      var lst = title.split(' ');
      if (lst.length == 1) {
        var splitWord = title.split('#');
        return RichText(
          text: TextSpan(children: [
            if (splitWord.length > 0)
              for (int i = 0; i < splitWord.length; i++)
                if (splitWord[i].contains("#"))
                  TextSpan(
                    text: splitWord[i].split("#").where((element) => element.isNotEmpty).first,
                    style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: Colors.white, decoration: TextDecoration.underline),
                  )
                else
                  TextSpan(text: splitWord[i], style: ThemeStyles.styleNormal(textColors: Colors.white))
          ]),
        );
      } else {
        var listBold = lst.where((element) => element.contains("#")).toList();
        if (listBold.length == 2) {
          var indexFirst = lst.indexOf(listBold.first);
          var indexLast = lst.indexOf(listBold.last);
          return RichText(
            text: TextSpan(children: [
              if (lst.length > 0)
                for (int i = 0; i < lst.length; i++)
                  if (i > indexFirst && i < indexLast)
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleBold(textColors: Colors.white))
                  else if (i == indexFirst || i == indexLast)
                    TextSpan(
                      text: lst[i].split('#').where((element) => element.isNotEmpty).first + ' ',
                      style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: Colors.white, decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleNormal(textColors: Colors.white))
            ]),
          );
        } else {
          return RichText(
            text: TextSpan(children: [
              if (lst.length > 0)
                for (int i = 0; i < lst.length; i++)
                  if (lst[i].contains("#"))
                    TextSpan(
                      text: lst[i].split('#').where((element) => element.isNotEmpty).first + ' ',
                      style: TextStyle(fontSize: 16, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.w700, color: Colors.white, decoration: TextDecoration.underline),
                    )
                  else
                    TextSpan(text: lst[i] + ' ', style: ThemeStyles.styleNormal(textColors: Colors.white))
            ]),
          );
        }
      }
    } else {
      return Text(
        title,
        style: TextStyle(fontSize: 14, fontFamily: 'SourceSerifPro', color: Colors.white, fontWeight: FontWeight.w400),
      );
    }
  }
}