import 'package:flutter/material.dart';

class ShowImageDialog extends StatefulWidget {
  String file;

  ShowImageDialog({this.file});

  @override
  State<StatefulWidget> createState() => ShowImageDialogState(file: this.file);
}

class ShowImageDialogState extends State<ShowImageDialog> {
  String file;

  ShowImageDialogState({this.file});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
        child: Stack(
      children: [
        Positioned(
          child: Image.network(file),
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
        )
      ],
    ));
  }
}
