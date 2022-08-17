import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gstudent/api/dtos/TestInput/image.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_outline.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:image_picker/image_picker.dart';

class CreateSupportView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateSupportViewState();
}

class CreateSupportViewState extends State<CreateSupportView> {
  AssetImage bgDialog;
  HomeCubit cubit;
  String image;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    loadImage();
  }

  loadImage() {
    bgDialog = AssetImage('assets/game_bg_info_clan.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
  }

  final picker = ImagePicker();
  PickedFile pickedFile;

  Future<String> getImage(int isCamera) async {
    if (isCamera == 1) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    }
    if (isCamera == 2) {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      var image = File(pickedFile.path);
      return image.path;
    }

    return null;
  }

  uploadImage() async {
    int isCamera;
    await imageOptions(context).then((value) => isCamera = value);
    var file = await getImage(isCamera);
    if (file == null || file.isEmpty) {
      return;
    }
    var now = DateTime.now().toString();
    Images result = await cubit.uploadFile("img" + now, file);
    if (result != null) {
      setState(() {
        image = result.path;
      });
    }
  }

  Future<int> imageOptions(context) async {
    var result = await showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: 'image picker',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 100,
            child: SizedBox.expand(
                child: Container(
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      child: Text(
                        AppLocalizations.of(context).lblCamera,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SourceSerifPro',
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    ),
                    onTap: () => {Navigator.pop(context, 1)},
                  ),
                  Expanded(
                      child: Divider(
                    color: Colors.grey,
                  )),
                  GestureDetector(
                      child: Container(
                        child: Text(
                          AppLocalizations.of(context).lblGallery,
                          style: ThemeStyles.styleNormal(),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      ),
                      onTap: () => {Navigator.pop(context, 2)})
                ],
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              alignment: Alignment.bottomCenter,
            )),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
    return result == null ? 0 : result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned(
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      right: 16,
                      left: 16,
                      bottom: 0,
                      child: Image(
                        image: bgDialog,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 48,
                      right: 48,
                      left: 48,
                      bottom: 16,
                      child: content(),
                    ),
                    Positioned(
                        child: Container(
                          child: Stack(
                            children: [
                              Positioned(
                                child: Image(
                                  image: AssetImage('assets/images/title_result.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                child: Center(child: textpainting('Hỗ trợ', 24)),
                                top: 0,
                                right: 0,
                                bottom: 8,
                                left: 0,
                              )
                            ],
                          ),
                        ),
                        top: 0,
                        left: 24,
                        right: 24),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image(
                          image: AssetImage('assets/images/game_button_back.png'),
                          height: 48,
                          width: 48,
                        ),
                      ),
                      top: 16,
                      right: 16,
                    ),
                  ],
                ),
                bottom: 0,
                top: 0,
                left: 0,
                right: 0,
              ),
            ],
          )),
          Container(
            height: 90,
          ),
        ],
      ),
    );
  }

  textpainting(String s, double fontSize) {
    return OutlinedText(
      text: Text(s, textAlign: TextAlign.justify, style: TextStyle(fontSize: fontSize, fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, color: HexColor("#f8e9a5"))),
      strokes: [
        OutlinedTextStroke(color: HexColor("#681527"), width: 3),
      ],
    );
  }

  content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
        ),
        Card(
            color: HexColor("#fff6d8"),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                maxLines: 8,
                style: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 12),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration.collapsed(hintText: "Bạn cần hỗ trợ gì...", hintStyle: TextStyle(fontFamily: 'SourceSerifPro', fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            )),
        Container(
            margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
            height: 48,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    uploadImage();
                  },
                  child: Container(
                      height: 48,
                      width: 48,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      decoration: BoxDecoration(color: HexColor("#fdf1d1"), border: Border.all(color: Colors.black45)),
                      child: Icon(
                        Icons.camera_alt,
                        color: HexColor("#e7bba4"),
                      )),
                ),
                image != null
                    ? Container(
                        height: 48,
                        width: 48,
                        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Image(
                          image: NetworkImage(image),
                        ),
                      )
                    : Container(),
              ],
            )),
        Expanded(child: Container()),
        Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 16),
          height: 48,
          child: GestureDetector(
            onTap: () => sendSupport(),
            child:ButtonYellowSmall('GỬI'),
          ),
        )
      ],
    );
  }

  sendSupport() async {
    if (controller.text.isEmpty) {
      toast(context, 'Nội dung không được để trống');
      return;
    }
    showLoading();
    var res = await cubit.sendSupport(controller.text, image);
    hideLoading();
    if(res != null  ){
      if(res.error == false){
        toast(context, res.message);
        Navigator.of(context).pop();
      }else{
        toast(context, res.message);
      }
    }else{
      toast(context, "ERROR!");
    }
  }
}
