import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/api/dtos/TestInput/group_question.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class TestInputQuestionDialog extends StatefulWidget {
  List<GroupQuestionTest> qs;
  double itemHeight;
  double itemWidth;

  int current;
  String type;

  TestInputQuestionDialog(
      {Key key,
        this.itemHeight,
        this.itemWidth,
        this.qs,
        this.current,
        this.type});

  @override
  State<StatefulWidget> createState() => TestInputQuestionDialogState(
      itemHeight: this.itemHeight,
      itemWidth: this.itemWidth,
      qs: this.qs,
      current: this.current,
      type: this.type);
}

class TestInputQuestionDialogState extends State<TestInputQuestionDialog> {
  double itemHeight;
  List<GroupQuestionTest> qs;

  double itemWidth;

  int current;
  String type;

  TestInputQuestionDialogState(
      {Key key,
        this.itemHeight,
        this.itemWidth,
        this.qs,
        this.current,
        this.type});

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
              height: 280,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 48, 10, 10),
                  child: GridView.count(
                      primary: false,
                      shrinkWrap: true,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      crossAxisCount: 6,
                      childAspectRatio: (itemWidth / itemHeight) * 2,
                      children: List.generate(
                          qs.length, (index) => itemIndex(context, index)))),
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                  backgroundColor: HexColor("#2a3776"),
                  radius: 40,
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
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, offset: Offset(0, 1), blurRadius: 3)
            ]),
        child: Center(
          child: Text(index.toString(),
              style: TextStyle(
                  fontFamily: 'SourceSerifPro',fontWeight: FontWeight.w400,
                color: index == current
                    ? Theme.of(context).colorScheme.primary
                    : Colors.red,
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
