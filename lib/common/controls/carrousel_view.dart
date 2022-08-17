import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Carroussel extends StatefulWidget {
  List<String> img;
  int currentpage ;
  Carroussel({this.img,this.currentpage});

  @override
  _CarrousselState createState() => new _CarrousselState(img: this.img,currentpage: this.currentpage);
}

class _CarrousselState extends State<Carroussel> {
  List<String> img;
  int currentpage ;

  _CarrousselState({this.img,this.currentpage});
  PageController controller;

  @override
  initState() {
    super.initState();
    controller = PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 0.9,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentpage = value;
                });
              },
              controller: controller,
              itemBuilder: (context, index) => builder(index),
          itemCount: img.length,),
        ),
      ),
    );
  }

  builder(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 250,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        color: index % 2 == 0 ? Colors.blue : Colors.red,
        child: Image(
          image: AssetImage(img[index]),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}