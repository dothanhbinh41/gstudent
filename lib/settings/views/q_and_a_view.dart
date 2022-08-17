import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gstudent/api/dtos/QuestionAnswer/QuestionAndAnswerData.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';

class QAndAView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QAndAViewState();
}

class QAndAViewState extends State<QAndAView> {
  HomeCubit cubit;

  List<QuestionAndAnswer> data ;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
    loadImage();
    loadQA();
  }
  loadQA() async {
    var res = await cubit.getAllQAndA();
    if(res != null &&res.error == false){
      setState(() {
        data= res.data;
      });
    }
  }

  AssetImage bgDialog;

  loadImage() {
    bgDialog = AssetImage('assets/game_bg_info_clan.png');
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
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
                      right: MediaQuery.of(context).size.width > 800 ? 48 : 16,
                      left: MediaQuery.of(context).size.width > 800 ? 48 : 16,
                      bottom: 0,
                      child: Image(
                        image: bgDialog,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: MediaQuery.of(context).size.width > 800
                          ? MediaQuery.of(context).size.width * 0.15
                          : 48,
                      left: MediaQuery.of(context).size.width > 800
                          ? MediaQuery.of(context).size.width * 0.15
                          : 48,
                      bottom: 16,
                      child: content(),
                    ),
                    Positioned(
                        child: Container(
                          child: Stack(
                            children: [
                              Positioned(
                                right: MediaQuery.of(context).size.width > 800
                                    ? 60
                                    : 0,
                                bottom: 0,
                                left: MediaQuery.of(context).size.width > 800
                                    ? 60
                                    : 0,
                                top: 0,
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/title_result.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                child: Center(
                                    child: textpaintingBoldBase(
                                        'Q&A',
                                        24,
                                        HexColor("#f8e9a5"),
                                        HexColor("#681527"),
                                        3)),
                                top: 0,
                                right: 0,
                                bottom: 8,
                                left: 0,
                              )
                            ],
                          ),
                        ),
                        top: 0,
                        height:
                            MediaQuery.of(context).size.width > 800 ? 90 : 60,
                        left: 24,
                        right: 24),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image(
                          image: AssetImage(
                              'assets/images/game_close_dialog_clan.png'),
                          height: 48,
                          width: 48,
                        ),
                      ),
                      top: 16,
                      right: MediaQuery.of(context).size.width > 800 ? 60 : 16,
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
          Container(height: 90,)
        ],
      ),
    );
  }

  content() {
    return data != null ? ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, i) {
        return new ExpansionTile(
          title: new Text(data[i].name, style: TextStyle(
            fontSize: 16,
            fontFamily: 'UTMThanChienTranh',
            fontWeight: FontWeight.w700,
            color: HexColor("#681527"),
          ),),
          children: <Widget>[
            new Column(
              children: _buildExpandableContent(data[i]),
            ),
          ],
        );
      },
    ) : Container();
  }

  _buildExpandableContent(QuestionAndAnswer data) {

    List<Widget> columnContent = [];

    for (QAndA content in data.qAndAs)
      columnContent.add(
        new ExpansionTile(
          title: new Text(content.question, style: TextStyle(
            fontSize: 16,
            fontFamily: 'UTMThanChienTranh',
            fontWeight: FontWeight.w700,
            color: HexColor("#681527"),
          ),),
          children: <Widget>[
            Container(margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text(content.answer,style: TextStyle(
              fontSize: 16,
              fontFamily: 'UTMThanChienTranh',
              fontWeight: FontWeight.w400,
              color: HexColor("#681527"),
            ),))
          ],
        ),
      );

    return columnContent;

  }

}
