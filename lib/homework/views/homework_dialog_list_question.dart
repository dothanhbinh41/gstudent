
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/homework/homework.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class HomeworkDialogListQuestion extends StatefulWidget {
  List<GroupQuestion>  qs;
  int current;

  HomeworkDialogListQuestion(
      {Key key,
        this.qs,
        this.current, });

  @override
  State<StatefulWidget> createState() => HomeworkDialogListQuestionState(
      qs: this.qs,
      current: this.current, );
}

class HomeworkDialogListQuestionState extends State<HomeworkDialogListQuestion> {
  List<GroupQuestion>  qs;


  int current;

  HomeworkDialogListQuestionState(
      {Key key,
        this.qs,
        this.current, });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 36, 10, 10),
                  child: GridView.count(
                      primary: false,
                      shrinkWrap: true,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      crossAxisCount: 6,
                      childAspectRatio: 1.5,
                      children: List.generate(
                          qs.length, (index) => itemIndex(context, index)))),
            ),
            Positioned(
                top: -24,
                child: CircleAvatar(
                  backgroundColor: HexColor(
                      "#9c7f6a"),
                  radius: 28,
                  child: Icon(
                    Icons.list_alt_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                )),
          ],
        ));
  }

  itemIndex(BuildContext context, int index) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(6, 0, 6, 0),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: HexColor(
                "#9c7f6a"),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, 1), blurRadius: 3)
            ]),
        child: Center(
          child: Text((index+1).toString(),
              style: TextStyle(
                fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,
                color: index == current
                    ? Colors.white
                    : Colors.black,
              )),
        ),
      ),
      onTap: () => selectQuestion(index),
    );
  }

  selectQuestion(int index) {
    setState(() {
      current = index;
    });
    Navigator.of(context).pop(current);
  }
}
