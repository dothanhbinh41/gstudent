import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DialogSendInvite extends StatefulWidget {
  int myClanId;
  int toClanId;

  DialogSendInvite({this.toClanId, this.myClanId});

  @override
  State<StatefulWidget> createState() => DialogSendInviteState(myClanId: this.myClanId, toClanId: this.toClanId);
}

class DialogSendInviteState extends State<DialogSendInvite> {
  int myClanId;
  int toClanId;

  DialogSendInviteState({this.toClanId, this.myClanId});

  DateTime date;
  Duration hour;
  HomeCubit cubit;
  String letter;
  FocusNode _focus = new FocusNode();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    initializeDateFormatting();
    date = DateTime.now();
    hour = Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute);
    _focus.addListener(_onFocusChange);
  }


  void _onFocusChange() {
    if (_focus.hasFocus) {

    } else {
      disableFocus();
    }
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
    _focus.unfocus();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => disableFocus(),
        child: Container(
          height: 360,
          width: MediaQuery.of(context).size.width * 0.9 > 400 ? 400 : MediaQuery.of(context).size.width * 0.9,
          child: Stack(
            children: [
              Positioned(
                child: Image(
                  image: AssetImage('assets/images/bg_dialog_send_invite.png'),
                  fit: BoxFit.fill,
                ),
                top: 24,
                right: 0,
                left: 0,
                bottom: 60,
              ),
              Positioned(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image(
                        image: AssetImage('assets/images/icon_title_send_invite.png'),
                        height: 48,
                        width: 48,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Center(
                      child: Text(
                        'Thư thách đấu',
                        style: TextStyle(color: HexColor("#792020"), fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro', fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Image(
                        image: AssetImage('assets/images/ellipse.png'),
                      ),
                    ),
                    Container(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            letter = value;
                          });
                        },
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          hintText: 'Lời thách đấu',
                          hintStyle: TextStyle(fontSize: 12),
                        ),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro'),
                        minLines: 4,
                        // any number you need (It works as the rows for the textarea)
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                      ),
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      decoration: BoxDecoration(border: Border.all(color: HexColor("#98380C")), borderRadius: BorderRadius.circular(4)),
                    ),
                    Container(
                      child: Text(
                        'Thời gian thách đấu',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w400, fontFamily: 'SourceSerifPro', fontSize: 12),
                      ),
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                child: hour != null
                                    ? Text(
                                        _printDuration(hour),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'SourceSerifPro',
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        '00 : 00',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'SourceSerifPro',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(border: Border.all(color: HexColor("#98380C")), borderRadius: BorderRadius.circular(4)),
                              ),
                              onTap: () => selectTime(),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => selectDate(),
                              child: Container(
                                child: date != null && date.hour != null && date.minute != null
                                    ? Text(
                                        date.day.toString() + ' / ' + date.month.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'SourceSerifPro',
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        DateTime.now().day.toString() + '/' + DateTime.now().month.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'SourceSerifPro',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(border: Border.all(color: HexColor("#98380C")), borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                top: 0,
                right: 16,
                left: 16,
                bottom: 64,
              ),
              Positioned(
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: ButtonGraySmall(
                        'HỦY',
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () => sendInvite(),
                      child: ButtonYellowSmall('GỬI'),
                    )),
                  ],
                ),
                height: 48,
                right: 0,
                left: 0,
                bottom: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  selectTime() {
    CupertinoRoundedDurationPicker.show(
      context,
      initialTimerDuration: Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute),
      fontFamily: "SourceSerifPro",
      textColor: Colors.white,
      background: Colors.deepPurple,
      borderRadius: 16,
      initialDurationPickerMode: CupertinoTimerPickerMode.hm,
      onDurationChanged: (p0) {
        setState(() {
          hour = p0;
          print(hour);
        });
      },
    );
  }

  selectDate() async {
    DateTime newDateTime = await showRoundedDatePicker(
        context: context,
        height: MediaQuery.of(context).size.height / 2,
        textPositiveButton: 'Chọn',
        textNegativeButton: 'Hủy',
        initialDate: date,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        styleDatePicker: MaterialRoundedDatePickerStyle(
          textStyleDayButton: TextStyle(fontSize: 14, color: Colors.white),
          textStyleYearButton: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          textStyleDayHeader: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          textStyleCurrentDayOnCalendar: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          textStyleDayOnCalendar: TextStyle(fontSize: 14, color: Colors.white),
          textStyleDayOnCalendarSelected: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          textStyleDayOnCalendarDisabled: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.1)),
          textStyleMonthYearHeader: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          paddingDatePicker: EdgeInsets.fromLTRB(0, 8, 0, 0),
          paddingMonthHeader: EdgeInsets.all(8),
          paddingActionBar: EdgeInsets.all(8),
          paddingDateYearHeader: EdgeInsets.all(8),
          sizeArrow: 24,
          colorArrowNext: Colors.white,
          colorArrowPrevious: Colors.white,
          textStyleButtonAction: TextStyle(fontSize: 14, color: Colors.white),
          textStyleButtonPositive: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          textStyleButtonNegative: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
          decorationDateSelected: BoxDecoration(color: Colors.orange[600], shape: BoxShape.circle),
          backgroundPicker: Colors.deepPurple[400],
          backgroundActionBar: Colors.deepPurple[300],
          backgroundHeaderMonth: Colors.deepPurple[300],
        ),
        styleYearPicker: MaterialRoundedYearPickerStyle(
          textStyleYear: TextStyle(fontSize: 14, color: Colors.white),
          textStyleYearSelected: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          heightYearRow: 60,
          backgroundPicker: Colors.deepPurple[400],
        ));
    if (newDateTime != null) {
      setState(() {
        date = newDateTime;
      });
    }
  }

  sendInvite() async {
    disableFocus();
    if (letter == null || letter.isEmpty) {
      await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text(
                  'Lỗi',
                  style: ThemeStyles.styleNormal(font: 20),
                ),
                content: Text(
                  'Lời nhắn không được để trống',
                  style: ThemeStyles.styleNormal(),
                ),
                actions: [CupertinoDialogAction(child: Text('Đóng',style: ThemeStyles.styleBold(),),onPressed: () {
                  Navigator.of(context).pop();
                },)],
              ));
      return;
    }

    var format = DateFormat('yyyy-MM-dd HH:mm:ss', 'vi_VN');
    print(format.locale);
    DateTime time = DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0);
    if (hour == null) {
      hour = Duration(milliseconds: 0);
    }
    time = time.add(hour);
    if (time.isBefore(DateTime.now())) {
      await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(
              'Lỗi',
              style: ThemeStyles.styleNormal(font: 20),
            ),
            content: Text(
              'Thời gian không thể đặt trước thời gian hiện tại',
              style: ThemeStyles.styleNormal(),
            ),
            actions: [CupertinoDialogAction(child: Text('Đóng',style: ThemeStyles.styleBold(),),onPressed: () {
              Navigator.of(context).pop();
            },)],
          ));

      return;
    }
    if (hour.inHours <= DateTime.now().hour && DateTime(time.year, time.month, time.day) == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
      if (hour.inMinutes - (60 * (hour.inMinutes ~/ 60)) <= DateTime.now().minute + 2) {
        await showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(
                'Lỗi',
                style: ThemeStyles.styleNormal(font: 20),
              ),
              content: Text(
                'Không thể đặt thời gian bắt đầu sát giờ!',
                style: ThemeStyles.styleNormal(),
              ),
              actions: [CupertinoDialogAction(child: Text('Đóng',style: ThemeStyles.styleBold(),),onPressed: () {
                Navigator.of(context).pop();
              },)],
            ));

        return;
      }
    }
    var datetime = format.format(time);
    showLoading();
    var res = await cubit.sendInviteArena(this.myClanId, this.toClanId, letter, datetime);
    hideLoading();
    if (res != null) {
      if (res.error == false) {
        toast(context, res.message);
        Navigator.of(context).pop();
      } else {
        toast(context, res.message);
        return;
      }
    }
  }
}
