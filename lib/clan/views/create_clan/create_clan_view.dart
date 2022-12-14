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
    loadClan('Team c???a b???n ??ang ch??? ???????c duy???t!');
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
                        hintText: page == 0 ? 'T??n Team' : 'M?? Team',
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
                    child: ButtonGraySmall(page == 0 ? "T???O TEAM" : "GIA NH???P"),
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
                        ? textpaintingBoldBase('T???o Team', 20,
                            HexColor("#6D0A0A"), Colors.white, 3)
                        : textpaintingBoldBase('Gia nh???p team', 20,
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
                                                text: 'Ch??o m???ng ',
                                                style: ThemeStyles.styleNormal(
                                                    font: 16)),
                                            TextSpan(
                                                text: userName,
                                                style: ThemeStyles.styleBold(
                                                    font: 16)),
                                            TextSpan(
                                                text: ' ?????n v???i H???c Vi???n \n',
                                                style: ThemeStyles.styleNormal(
                                                    font: 16)),
                                            TextSpan(
                                                text:
                                                    'Trong kho??a h???c s??? c?? r???t nhi???u tr???i nghi???m th???c t???, ch??ng ta c???n th??m nh???ng ng?????i ?????ng ?????i ????? ?????ng h??nh v?? h??? tr??? nhau. H??y ?????ng l??n v?? l???p Team cho m??nh nh??.\n'
                                                    'B???n l?? ng?????i ?????i tr?????ng - ng?????i s??? ch???u tr??ch nhi???m d???n d???t team ??i t???i m???c ti??u cu???i c??ng.\n'
                                                    'H???c vi???n xin cung c???p cho b???n nh???ng th??ng tin h???u ??ch sau:\n'
                                                    'Team ???????c h??nh th??nh b???i: 1 Ch??? t?????ng v?? c??c Th??nh vi??n.\n'
                                                    'Khi l?? Ch??? t?????ng (Team Leader), b???n l?? ng?????i c?? tr??ch nhi???m cao nh???t v?? c?? th??? ????a ra nhi???u quy???t ?????nh nh???t. M???i th??nh vi??n trong team ?????u c?? m???t n??ng l???c kh??c nhau nh??: T???n c??ng, Ph??ng th???, Tr???m, Luy???n kim, Luy???n ??an??? Sau m???i bu???i h???c, c??c th??nh vi??n s??? ???????c th???c hi???n n??ng l???c c???a m??nh. H??y l??nh ?????o c??? team ????? b???o v??? team m??nh, ?????ng th???i t???n c??ng c??c team kh??c. H??y nh??? r???ng, ch??ng t??i s??? c?? r???t nhi???u ph???n qu?? h???p d???n cho Team ?????t ???????c K???t qu??? t???t nh???t.\n'
                                                    'Trong H???c vi???n, c?? m???t Khu v???c r???t ?????c bi???t cho Team - ???? l?? Ph??ng ?????u tr?????ng. ??? v??? tr?? ch??? t?????ng, b???n c?? th??? th??ch ?????u v???i c??c Team kh??c ??? to??n qu???c v?? ????a team m??nh n??ng cao v??? th??? tr??n B???ng x???p h???ng. Th??nh vi??n xu???t s???c nh???t c???a Team s??? ???????c nh???n th??m danh hi???u MVP. M???i tr???n th???ng t???i ?????u tr?????ng, m???i th??nh vi??n s??? nh???n ???????c th?????ng t????ng ???ng Ch??? t?????ng +500 EXP, Member +200 EXP, MVP +200 EXP.\n'
                                                    'B??n c???nh ????, h???c vi????n s??? t??? ch???c c??c s??? ki???n th?????ng ni??n v?? si??u s??? ki???n gi???i ?????u gi???a c??c Team. B???n h??y ?????ng vi??n c??? Team c??ng n??? l???c v?? ti???n s??u v??o gi???i ?????u.\n'
                                                    'H??y ch???ng minh m??nh x???ng ????ng tr??? th??nh th??? l??nh b???ng vi???c d???n d???t Team gi??nh ???????c nhi???u vinh quang v?? s??? h???u m???t v??? th??? ????ng ng?????ng m???.\n\n'
                                                    'C??ng ?????ng ?????i ch???n ra c??i t??n cho Team c???a m??nh.\n'
                                                    'B???n s???n s??ng r???i ch????',
                                                style: ThemeStyles.styleNormal(
                                                    font: 16)),
                                          ],
                                        ),
                                      ),
                                      // Text(
                                      //   "H??nh tr??nh thu th???p ?????y ????? c??c nguy???n li???u, th???n kh??, ??an d?????c, m???nh b???n ?????, ng???c th???n,... hay chinh ph???c nh???ng con boss kh???ng l??? l?? nh???ng h??nh tr??nh r???t l?? gian nan. Ch??nh v?? v???y c??c b???n - nh???ng th???n d??n thu???c c??c d??ng t???c kh??c nhau, s??? h???u trong m??nh nh???ng n??ng l???c kh??c nhau c???n t???p h???p l???i v???i nhau th??nh m???t nh??m, c??ng nhau k??? vai s??t c??nh v?????t qua nh???ng th??? th??ch kh?? kh??n tr??n.",
                                      //   style: ThemeStyles.styleNormal(),
                                      // ),
                                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    )
                                  : Container(
                                      child: Text(
                                          "Tham gia th??ch ?????u v?? chi???n th???ng t???t c??? Team kh??c ????? ?????t Top rank th??ch ?????u l?? m???c ti??u m?? b???t c??? Team n??o c??ng mu???n ?????t ???????c b???i th??? h???ng n??y kh??ng ch??? ??em l???i cho b???n danh v???ng m?? c??n mang t???i r???t nhi???u ph???n th?????ng gi?? tr??? l???n.\nG???i th??ch ?????u t???i c??c Team kh??c, tham gia th??ch ?????u, c??ng ?????ng ?????i gi??nh chi???n th???ng v?? ????nh b???i ?????i ?????i ph????ng l?? h??nh tr??nh b???n kh???ng ?????nh b???n th??n trong su???t kh??a h???c t???i h??n ?????o n??y",
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
      loadClan(res.message + '. Vui l??ng ch??? ????? ???????c duy???t Team!');
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
        return "?????o th??ng th??i Athena";
      case 1:
        return "?????o th??ng th??i Athena";
      case 2:
        return "R???ng nhi???t ?????i Amazonica";
      case 3:
        return "V????ng qu???c sa m???c Isukha";
      case 4:
        return "Th??nh ph??? b???c c???c Arcint";
      case 5:
        return "Th??nh ph??? Edo thu???c Ryo Qu???c-Nh???t";
      case 6:
        return "?????o Flyland";
      default:
        return "?????o Flyland";
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
