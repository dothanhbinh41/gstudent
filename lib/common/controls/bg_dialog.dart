
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstudent/common/colors/HexColor.dart';

class BackgroundDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BackgroundDialogState();

}

class BackgroundDialogState extends State<BackgroundDialog> {
  @override
  Widget build(BuildContext context) {
   return Stack(children: [
     Positioned(top: 12,right: 24,left: 24,bottom: 12,child: Container(color:  HexColor("#f8e8b0"),),),

     Positioned(child: Container(child:  Row(children: [
       for(var i = 0; i < 3 ; i++)
         Expanded(child:   Image(image: AssetImage('assets/images/ngang.png')))

     ],),height: 32,),top: 0,left: 24,right:24),
     Positioned(child: Container(child:  Row(children: [
       for(var i = 0; i < 3; i++)
         Expanded(child:   Image(image: AssetImage('assets/images/ngang.png')))

     ],crossAxisAlignment: CrossAxisAlignment.stretch,),height: 32,),bottom: 0,left: 24,right:24),
     Positioned(child: Container(child:  Column(children: [
       for(var i = 0; i < 3; i++)
         Expanded(child:   Image(image: AssetImage('assets/images/doc.png'),fit: BoxFit.fill,))
     ],crossAxisAlignment: CrossAxisAlignment.stretch,),width: 16,),bottom: 24,left: 8,top:24),
     Positioned(child: Container(child:  Column(children: [
       for(var i = 0; i < 3; i++)
         Expanded(child:   Image(image: AssetImage('assets/images/doc.png'),fit: BoxFit.fill,))
     ],crossAxisAlignment: CrossAxisAlignment.stretch,),width: 16,),bottom: 24,right: 8,top:24),
     Positioned(child: Image(image: AssetImage('assets/images/topleft.png'),),top: 8,left: 8,height: 36),
     Positioned(child: Image(image: AssetImage('assets/images/topright.png'),),top: 8,right: 8,height: 36),
     Positioned(child: Image(image: AssetImage('assets/images/bottomleft.png'),),bottom: 8,left: 8,height: 36,),
     Positioned(child: Image(image: AssetImage('assets/images/bottomright.png'),),bottom: 8,right: 8,height: 36),

   ],);
  }
}