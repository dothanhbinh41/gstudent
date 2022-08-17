import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gstudent/api/dtos/Clan/clan.dart';
import 'package:gstudent/api/dtos/Clan/create_clan_reponse.dart';
import 'package:gstudent/api/dtos/Clan/search_clan_response.dart';
import 'package:gstudent/character/services/character_services.dart';
import 'package:gstudent/clan/services/clan_services.dart';
import 'package:gstudent/clan/views/create_clan/dialog_check_clan.dart';
import 'package:gstudent/common/colors/HexColor.dart';
import 'package:gstudent/common/controls/button/button_style.dart';
import 'package:gstudent/common/controls/text_painting.dart';
import 'package:gstudent/common/styles/theme_text.dart';
import 'package:gstudent/home/cubit/home_cubit.dart';
import 'package:gstudent/home/cubit/home_state.dart';
import 'package:gstudent/home/services/home_services.dart';
import 'package:gstudent/main.dart';
import 'package:gstudent/mission/services/MissionService.dart';
import 'package:gstudent/settings/helper/ApplicationSettings.dart';
import 'package:gstudent/special/services/special_service.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class CreateClanView extends StatefulWidget {
  int idIsland;
  int classroomId;
  int clanId;
  int userClanId;
  String nameCLan;
  String userName;

  CreateClanView({
    this.idIsland,
    this.classroomId,
    this.clanId,
    this.userClanId,
    this.nameCLan,
    this.userName,
  });

  @override
  State<StatefulWidget> createState() => CreateClanViewState(
      userName: this.userName,
      idIsland: this.idIsland,
      classroomId: this.classroomId,
      clanId: this.clanId,
      userClanId: this.userClanId,
      nameCLan: this.nameCLan);
}

class CreateClanViewState extends State<CreateClanView> {
  int idIsland;
  int classroomId;
  int clanId;
  int userClanId;
  String nameCLan;
  String userName;

  CreateClanViewState({
    this.idIsland,
    this.classroomId,
    this.clanId,
    this.userClanId,
    this.nameCLan,
    this.userName,
  });

  HomeCubit cubit;
  PageController controller ;
  ScrollController _scrollController;
  ClanFindByName clan;
  int page = 0;
  final pageIndexNotifier = ValueNotifier<int>(0);
  String codeClan;
  Clan param;
  TextEditingController textEditingController;
  bool isFocus = false;
  FocusNode _focus = new FocusNode();
  ApplicationSettings settings = GetIt.instance.get<ApplicationSettings>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    controller = PageController(
      initialPage: 0,
      viewportFraction: 0.6,
    );
    _scrollController = ScrollController();
    loadImage();
    textEditingController = TextEditingController();
    param = Clan(
        userClanId: this.userClanId,
        isApprove: false,
        characterId: null,
        id: this.clanId,
        name: this.nameCLan);
    loadClan('Team của bạn đang chờ được duyệt!');
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
    if (_focus.hasFocus) {
      setState(() {
        isFocus = true;
      });
    } else {
      disableFocus();
    }
  }

  loadClan(String mess) async {
    if (clanId != null && clanId != 0) {
      var res = await cubit.getDetailCLan(clanId);
      if (res == null) {
        var dialogRespone = await showDialog(
          context: context,
          builder: (context) => BlocProvider(
            create: (context) => HomeCubit(
                clanService: GetIt.instance.get<ClanService>(),
                homeService: GetIt.instance.get<HomeService>(),
                settings: GetIt.instance.get<ApplicationSettings>(),
                characterService: GetIt.instance.get<CharacterService>(),
                missionService: GetIt.instance.get<MissionService>(),
                specialService: GetIt.instance.get<SpecialService>()),
            child: DialogCheckClanView(
              message: mess,
              clanId: this.clanId,
            ),
          ),
        );

        if (dialogRespone) {
          param.isApprove = dialogRespone;
          Navigator.of(context).pop(param);
        } else {
          Navigator.of(context).pop(param);
        }
      }
    }
  }

  List<AssetImage> options = [
    AssetImage("assets/images/character_landing.png"),
    AssetImage("assets/images/character_landing2.png"),
  ];
  AssetImage bgDialog;
  AssetImage bgGame;
  AssetImage imgIsland;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(bgDialog, context);
    precacheImage(bgGame, context);
    options.forEach((element) {
      precacheImage(element, context);
    });
  }

  loadImage() {
    bgGame = AssetImage('assets/game_bg_map.png');
    bgDialog = AssetImage('assets/game_bg_dialog_create_medium.png');
    imgIsland = AssetImage(localImageByIdIsland(idIsland));
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).viewInsets.bottom);
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {},
      child: Stack(
        children: [
          Positioned(
              top: -20,
              right: 0,
              left: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => disableFocus(),
                child: Image(
                  image: bgGame,
                  fit: BoxFit.fill,
                ),
              )),
          Positioned(
            child: GestureDetector(
              onTap: () => disableFocus(),
              child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(image: imgIsland),
                      top: 0,
                      right: -24,
                      bottom: 0,
                    ),
                    Positioned(
                      child: textpaintingBoldBase(nameIslandById(idIsland), 18,
                          Colors.white, Colors.black, 5,
                          textAlign: TextAlign.center),
                      bottom: 0,
                      left: 8,
                      right: 8,
                    )
                  ],
                ),
              ),
            ),
            top: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          Positioned(
            child: GestureDetector(
              onTap: () => disableFocus(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height:   MediaQuery.of(context).size.height * 0.54 ,
                    child: CarouselSlider.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index, realIndex) {
                          return item(index);
                        },
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.7,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              page = index;
                              pageIndexNotifier.value = index;
                              textEditingController.clear();
                            });
                          },
                          scrollDirection: Axis.horizontal,
                        )),
                  ),
                  Container(
                    child: pageviewIndicator(),
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  ),
                ],
              ),
            ),
            top: MediaQuery.of(context).size.height * 0.19,
            height: MediaQuery.of(context).size.height * 0.8,
            right: 0,
            left: 0,
          ),
          KeyboardAware(
            builder: (context, configuracaoTeclado) {
              return AnimatedPositioned(
                child: Container(
                  height: 48,
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: HexColor("#6C5448").withOpacity(0.68),
                  ),
                  child: TextField(
                    focusNode: _focus,
                    onChanged: (value) {},
                    controller: textEditingController,
                    style: ThemeStyles.styleNormal(textColors: HexColor("#FFE1B2").withOpacity(0.8)),
                    decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        hintText: page == 0 ? 'Tên Team' : 'Mã Team',
                        hintStyle: TextStyle(
                            color: HexColor("#FFE1B2"),
                            fontFamily: 'SourceSerifPro',
                            fontWeight: FontWeight.w400)),
                  ),
                ),
                duration: Duration(milliseconds: 50),
                right: 0,
                left: 0,
                bottom:isFocus ? configuracaoTeclado.keyboardHeight + 80: 64,
              );
            },
          ),
          Positioned(
              child: GestureDetector(
                onTap: () => checkButton(),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    height: 48,
                    child: ButtonGraySmall(page == 0 ? "TẠO TEAM" : "GIA NHẬP"),
                  ),
                ),
              ),
              right: 0,
              left: 0,
              bottom: 8),
          Positioned(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 8, 0, 0),
                child: Image(
                  image: AssetImage('assets/images/game_button_back.png'),
                  height: 48,
                  width: 48,
                ),
              ),
            ),
            left: 8,
            top: 8,
          )
        ],
      ),
    ));
  }

  item(index) {
    return Stack(
      children: [
        Positioned(
          top: 42,
          right: 0,
          left: 0,
          bottom: 0,
          child: Container(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(4),
                  color: HexColor("#5BBCE2").withOpacity(0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                  ),
                  Container(
                    child: index == 0
                        ? textpaintingBoldBase('Tạo Team', 20,
                            HexColor("#6D0A0A"), Colors.white, 3)
                        : textpaintingBoldBase('Gia nhập team', 20,
                            HexColor("#6D0A0A"), Colors.white, 3),
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  ),
                  Expanded(
                          child: Scrollbar(
                          thickness: 4,
                          controller: _scrollController,
                          child: ListView(
                            children: [
                              index == 0
                                  ? Container(
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Chào mừng ',
                                                style: ThemeStyles.styleNormal(
                                                    font: 16)),
                                            TextSpan(
                                                text: userName,
                                                style: ThemeStyles.styleBold(
                                                    font: 16)),
                                            TextSpan(
                                                text: ' đến với Học Viện \n',
                                                style: ThemeStyles.styleNormal(
                                                    font: 16)),
                                            TextSpan(
                                                text:
                                                    'Trong khóa học sẽ có rất nhiều trải nghiệm thực tế, chúng ta cần thêm những người đồng đội để đồng hành và hỗ trợ nhau. Hãy đứng lên và lập Team cho mình nhé.\n'
                                                    'Bạn là người đội trưởng - người sẽ chịu trách nhiệm dẫn dắt team đi tới mục tiêu cuối cùng.\n'
                                                    'Học viện xin cung cấp cho bạn những thông tin hữu ích sau:\n'
                                                    'Team được hình thành bởi: 1 Chủ tướng và các Thành viên.\n'
                                                    'Khi là Chủ tướng (Team Leader), bạn là người có trách nhiệm cao nhất và có thể đưa ra nhiều quyết định nhất. Mỗi thành viên trong team đều có một năng lực khác nhau như: Tấn công, Phòng thủ, Trộm, Luyện kim, Luyện đan… Sau mỗi buổi học, các thành viên sẽ được thực hiện năng lực của mình. Hãy lãnh đạo cả team để bảo vệ team mình, đồng thời tấn công các team khác. Hãy nhớ rằng, chúng tôi sẽ có rất nhiều phần quà hấp dẫn cho Team đạt được Kết quả tốt nhất.\n'
                                                    'Trong Học viện, có một Khu vực rất đặc biệt cho Team - đó là Phòng Đấu trường. Ở vị trí chủ tướng, bạn có thể thách đấu với các Team khác ở toàn quốc và đưa team mình nâng cao vị thế trên Bảng xếp hạng. Thành viên xuất sắc nhất của Team sẽ được nhận thêm danh hiệu MVP. Mỗi trận thắng tại Đấu trường, mỗi thành viên sẽ nhận được thưởng tương ứng Chủ tướng +500 EXP, Member +200 EXP, MVP +200 EXP.\n'
                                                    'Bên cạnh đó, học viện sẽ tổ chức các sự kiện thường niên và siêu sự kiện giải đấu giữa các Team. Bạn hãy động viên cả Team cùng nỗ lực và tiến sâu vào giải đấu.\n'
                                                    'Hãy chứng minh mình xứng đáng trở thành thủ lĩnh bằng việc dẫn dắt Team giành được nhiều vinh quang và sở hữu một vị thế đáng ngưỡng mộ.\n\n'
                                                    'Cùng đồng đội chọn ra cái tên cho Team của mình.\n'
                                                    'Bạn sẵn sàng rồi chứ?',
                                                style: ThemeStyles.styleNormal(
                                                    font: 16)),
                                          ],
                                        ),
                                      ),
                                      // Text(
                                      //   "Hành trình thu thập đầy đủ các nguyện liệu, thần khí, đan dược, mảnh bản đồ, ngọc thần,... hay chinh phục những con boss khổng lồ là những hành trình rất là gian nan. Chính vì vậy các bạn - những thần dân thuộc các dòng tộc khác nhau, sở hữu trong mình những năng lực khác nhau cần tập hợp lại với nhau thành một nhóm, cùng nhau kề vai sát cánh vượt qua những thử thách khó khăn trên.",
                                      //   style: ThemeStyles.styleNormal(),
                                      // ),
                                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    )
                                  : Container(
                                      child: Text(
                                          "Tham gia thách đấu và chiến thắng tất cả Team khác để đạt Top rank thách đầu là mục tiêu mà bất cứ Team nào cũng muốn đạt được bởi thứ hạng này không chỉ đem lại cho bạn danh vọng mà còn mang tới rất nhiều phần thưởng giá trị lớn.\nGửi thách đấu tới các Team khác, tham gia thách đầu, cùng đồng đội giành chiến thắng và đánh bại đội đối phương là hành trình bạn khẳng định bản thân trong suốt khóa học tại hòn đảo này",
                                          style: ThemeStyles.styleNormal()),
                                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    ),
                            ],
                          ),
                        ))
                ],
              )),
        ),
        Positioned(
          height: 92,
          child: Image(
            image: options[index],
            fit: BoxFit.fill,
          ),
          top: 0,
          right: 16,
          left: 16,
        )
      ],
    );
  }

  pageviewIndicator() {
    return CirclePageIndicator(
      size: 12.0,
      selectedSize: 16.0,
      dotColor: HexColor("#2B80A3").withOpacity(0.4),
      selectedDotColor: HexColor("#2B80A3"),
      itemCount: options.length,
      currentPageNotifier: pageIndexNotifier,
    );
  }

  checkButton() async {
    if (textEditingController.text == null ||
        textEditingController.text.isEmpty) {
      return;
    }
    if (page == 1) {
      joinClan();
    } else {
      createClanClick();
    }
  }

  String localImageByIdIsland(int idIsland) {
    switch (idIsland) {
      case 1:
        return 'assets/athena_land.png';
      case 2:
        return 'assets/amazonica_land.png';
      case 3:
        return 'assets/isukha_land.png';
      case 4:
        return 'assets/arcint_land.png';
      case 5:
        return 'assets/edo_land.png';
      case 6:
        return 'assets/fly_land.png';
      case 7:
        return 'assets/moa_land.png';
    }
  }

  createClanClick() async {
    showLoading();
    CreateClanReponse res =
        await cubit.createClan(classroomId, textEditingController.text);
    hideLoading();
    if (res != null && res.error == false) {
      setState(() {
        clanId = res.data.id;
        param = Clan(
            characterId: null,
            userClanId: res.data.userClanId,
            name: res.data.name,
            id: clanId,
            isApprove: false);
      });
      loadClan(res.message + '. Vui lòng chờ để được duyệt Team!');
    }
    if (res == null) {
      toast(context, 'Something went wrong please contact with center');
    }
    if (res.error == true) {
      toast(context, res.message);
      return;
    }
  }

  joinClan() async {
    showLoading();
    var res = await cubit.joinClan(textEditingController.text);
    hideLoading();
    if (res != null && res.error == false) {
      var clanDetail = await cubit.findClan(res.userClan.clanId);
      if (clanDetail != null && clanDetail.error == false) {
        param = Clan(
            id: res.userClan.clanId,
            name: clanDetail.data.first.name,
            userClanId: res.userClan.id,
            characterId: null,
            isApprove: true);
        Navigator.of(context).pop(param);
      }
    }
    if (res != null && res.error == true) {
      toast(context, res.message);
    }
    if (res == null) {
      toast(context, 'Something went wrong please contact with center');
    }
  }

  String nameIslandById(int idIsland) {
    switch (idIsland) {
      case 0:
        return "Đảo thông thái Athena";
      case 1:
        return "Đảo thông thái Athena";
      case 2:
        return "Rừng nhiệt đới Amazonica";
      case 3:
        return "Vương quốc sa mạc Isukha";
      case 4:
        return "Thành phố bắc cực Arcint";
      case 5:
        return "Thành phố Edo thuộc Ryo Quốc-Nhật";
      case 6:
        return "Đảo Flyland";
      default:
        return "Đảo Flyland";
    }
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
    _focus.unfocus();
    setState(() {
      isFocus = false;
    });
  }
}
