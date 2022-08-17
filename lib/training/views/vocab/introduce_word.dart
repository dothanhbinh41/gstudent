import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../api/dtos/Training/vocab/vocab.dart';

class TranningIntroducePage extends StatefulWidget {
  String subeng ;
  String subviet ;
  Vocab word = Vocab();
  TranningIntroducePage({Key key, this.subeng, this.subviet, this.word})
      : super(key: key);
  @override
  _TranningIntroducePageState createState() =>
      _TranningIntroducePageState(subeng: subeng, subviet: subviet, word: word);
}

class _TranningIntroducePageState extends State<TranningIntroducePage> {
  String subeng ;
  String subviet ;
  Vocab word = Vocab();
  _TranningIntroducePageState({this.subeng, this.subviet, this.word});
  @override
  Widget build(BuildContext context) {
    var arrs =
    subeng.toLowerCase().split(word.vocabOrWord.trim().toLowerCase());
    var lst = List<String>();
    for (int i = 0; i < arrs.length; i++) {
      if (i == arrs.length - 1) {
        lst.add(arrs[i]);
        continue;
      }
      lst.add(arrs[i]);
      lst.add(word.vocabOrWord);
    }
    // var index = lst.indexOf(word.vocabOrWord);
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  if (subeng.length > 0)
                    for (var text in lst)
                      if (text
                          .toLowerCase()
                          .contains(word.vocabOrWord.toLowerCase().trim()))
                        TextSpan(
                          text: '$text ',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        )
                      else
                        TextSpan(
                            text: '$text ',
                            style: TextStyle(
                                fontSize: 14, color: Colors.black54,fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400))
                ],
              ),
            ),

            // Text(subeng),
            SizedBox(height: 12),
            Text(subviet,
                style: TextStyle(fontSize: 14, color: Colors.black54,fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400)),
            SizedBox(
              height: 28,
            ),
            Text.rich(TextSpan(children: [
              TextSpan(text: word.vocabOrWord, style:  TextStyle(color: Colors.black,fontSize: 16,fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400)),
              TextSpan(text: ' '),
              TextSpan(text: '${word.pronunciation} ', style: GoogleFonts.notoSerif(
                  textStyle: TextStyle(color: Colors.black,fontSize: 16,fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400)))
            ])),
            Text(word.meaning ?? "",
                style: TextStyle(fontSize: 12, color: Colors.grey[500],fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400)),
          ]),
    );
  }
}
