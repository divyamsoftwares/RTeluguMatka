// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print, unnecessary_null_comparison, prefer_final_fields, use_build_context_synchronously, deprecated_member_use, unnecessary_string_interpolations, unused_field

import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/get_config_model.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/home_model.dart';
import 'package:telugu_matka/Api_Calling/Networking/api.dart';
import 'package:telugu_matka/Api_Calling/Networking/api_service.dart';
import 'package:telugu_matka/App_Utils/color_utils.dart';
import 'package:telugu_matka/App_Utils/image_utils.dart';
import 'package:telugu_matka/Drawer_Screen/wallet_screen.dart';
import 'package:telugu_matka/Home_Screen/chart_screen.dart';
import 'package:telugu_matka/Home_Screen/game_screen.dart';
import 'package:telugu_matka/Splash/drawer_screen.dart';
import 'package:telugu_matka/Starline_Game/select_game.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? mobile;
  String? pass;
  String? session;
  bool _isDisposed = false;
  HomeData? gethomedata;
  bool isLoading = false;
  GetConfig? getConfigData;
  Duration? difference;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  didChangeDependencies() {
    // getSavedBodyData();
    super.didChangeDependencies();
  }

  void fetchDataAndUpdateUI() {
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>?> getSavedBodyData() async {
    print("getSavedBodyData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');

    if (bodydataJson != null) {
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      mobile = savedBodydata["mobile"] ?? "";
      pass = savedBodydata["pass"] ?? "";
      session = savedBodydata["session"] ?? "";

      print("1Mobile Number: $mobile");
      print("1Session Key: $session");
      print("1Password: $pass");

      if (savedBodydata != null) {
        getData();
      }

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  Future<void> getData() async {
    print("getData");

    if (mounted) {
      print("Mobile Number: $mobile");
      print("Password: $pass");
      print("Session Key: $session");

      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      gethomedata = await ApiServices.fetchHomedata(context, session!, mobile!);
      getConfigData = await ApiServices.fetchGetConfigData();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  DateTime parseTimeString(String timeString) {
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');

    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    if (parts.length > 1 && parts[1].toLowerCase() == 'pm') {
      hours += 12;
    }

    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hours, minutes);
  }

  String formatDuration(Duration duration) {
    return "${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(
        wallet: gethomedata?.wallet ?? "",
        username: gethomedata?.name ?? "",
        playstoreUrl: getConfigData?.data[29].data ?? "",
        verify: gethomedata?.verify ?? "",
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorUtils.blue,
        titleSpacing: 0,
        title: Text("Telugu Matka",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        actions: [
          isLoading
              ? Container()
              : gethomedata?.verify != '0'
                  ? InkWell(
                      onTap: () {
                        Get.to(() =>
                            WalletScreen(wallet: gethomedata?.wallet ?? ""));
                      },
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: Image.asset(
                            ImageUtils.wallet,
                            color: ColorUtils.white,
                          )),
                    )
                  : Container(),
          SizedBox(
            width: 7,
          ),
          Text(
            gethomedata?.verify != '0' ? gethomedata?.wallet ?? "" : "",
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorUtils.blue,
            ))
          : WillPopScope(
              onWillPop: () async {
                SystemNavigator.pop();
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  await getSavedBodyData();
                },
                child: Column(
                  children: [
                    gethomedata!.verify != '0'
                        ? Container(
                            decoration: BoxDecoration(
                              color: ColorUtils.white,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                CarouselSlider.builder(
                                  options: CarouselOptions(
                                    aspectRatio: 20 / 9,
                                    viewportFraction: 0.999,
                                    autoPlay: gethomedata?.images.length == 1
                                        ? false
                                        : true,
                                    autoPlayInterval: Duration(seconds: 2),
                                  ),
                                  itemCount: gethomedata?.images.length ?? 0,
                                  itemBuilder: (BuildContext context, int index,
                                      int realIndex) {
                                    return Container(
                                      child: Center(
                                        child: gethomedata?.verify != '0'
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(6),
                                                    topLeft:
                                                        Radius.circular(6)),
                                                child: Image.network(
                                                    ApiUrls.baseUrl +
                                                        gethomedata!
                                                            .images[index]
                                                            .image,
                                                    fit: BoxFit.cover,
                                                    height: 300,
                                                    width: 1000),
                                              )
                                            : Container(
                                                color: Colors.white,
                                                width: 1000,
                                              ),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF005a4e),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15))),
                                  // height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              if (getConfigData!
                                                      .data[18].data ==
                                                  "0") {
                                              } else {
                                                launch(
                                                    "tel:${getConfigData!.data[1].data}");
                                              }
                                            },
                                            child: homeBox(ImageUtils.calls,
                                                '+91 ${getConfigData!.data[1].data}'),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (getConfigData!
                                                      .data[18].data ==
                                                  "0") {
                                              } else {
                                                const countrycode = '91';
                                                String phoneNumber =
                                                    '${getConfigData!.data[1].data}';
                                                print(
                                                    "phone number : $phoneNumber");
                                                final whatsappUrl =
                                                    'https://wa.me/$countrycode$phoneNumber';
                                                if (await canLaunch(
                                                    whatsappUrl)) {
                                                  await launch(whatsappUrl,
                                                      forceSafariVC: false);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      content: Text(
                                                          'WhatsApp is not installed on your device.'),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            child: homeBox(ImageUtils.whatsapp,
                                                '+91 ${getConfigData!.data[1].data}'),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => SelectGame(
                                              wallet:
                                                  gethomedata?.wallet ?? ""));
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(0xFFc503c0),
                                                    Color(0xFF82007f),
                                                    Color(0xFF82007f),
                                                    Color(0xFFc503c0),
                                                  ])),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "STARLINE GAMES",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                    fontSize: 15),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Color(0xFF4eadae),
                                                        Color(0xFF00594d),
                                                        Color(0xFF00594d),
                                                        Color(0xFF4eadae),
                                                      ]),
                                                ),
                                                child: Text(
                                                  "Play Now",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      /* InkWell(
                                        onTap: () {
                                          Get.to(() => GaliDisawar(
                                              wallet: gethomedata?.wallet ?? ""));
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(0xFFc503c0),
                                                    Color(0xFF82007f),
                                                    Color(0xFF82007f),
                                                    Color(0xFFc503c0),
                                                  ])),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "GALI DISAWAR GAMES",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 2,
                                                    fontSize: 15),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Color(0xFF4eadae),
                                                        Color(0xFF00594d),
                                                        Color(0xFF00594d),
                                                        Color(0xFF4eadae),
                                                      ]),
                                                ),
                                                child: Text(
                                                  "Play Now",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ), */
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 5,
                    ),
                    /* gethomedata?.verify != '0'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => AddPointScreen(
                                      wallet: gethomedata?.wallet ?? ""));
                                },
                                child: homeBox(ImageUtils.addpoint, "ADD POINT"),
                              ),
                              // homeBox(ImageUtils.addpoint, "ADD POINT"),
                              InkWell(
                                onTap: () async {
                                  if (getConfigData!.data[18].data == "0") {
                                  } else {
                                    const countrycode = '91';
                                    String phoneNumber =
                                        '${getConfigData!.data[1].data}';
                                    print("phone number : $phoneNumber");
                                    final whatsappUrl =
                                        'https://wa.me/$countrycode$phoneNumber';
                                    if (await canLaunch(whatsappUrl)) {
                                      await launch(whatsappUrl,
                                          forceSafariVC: false);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                              'WhatsApp is not installed on your device.'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: homeBox(ImageUtils.whatsapp, "WHATSAPP"),
                              )
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: 5,
                    ),
                    gethomedata?.verify != '0'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => GaliDisawar(
                                      wallet: gethomedata?.wallet ?? ""));
                                },
                                child: homeBox(ImageUtils.galids, "GALI DISAWAR"),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => WithdrawPoint(
                                      wallet: gethomedata?.wallet ?? ""));
                                },
                                child: homeBox(
                                    ImageUtils.walletwithdraw, "WITHDRAW"),
                              )
                            ],
                          )
                        : Container(), */
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: gethomedata!.result.length,
                          itemBuilder: (context, index) {
                            final List<GlobalKey<ShakeWidgetState>> shakeKeys =
                                List.generate(
                              gethomedata!.result.length,
                              (index) => GlobalKey<ShakeWidgetState>(),
                            );
                            String closeTimeString = gethomedata!
                                .result[index].closeTime
                                .replaceAll('\u200B', ' ')
                                .trim();

                            if (closeTimeString.toLowerCase() == 'holiday') {
                              return GestureDetector(
                                onTap: () {
                                  if (gethomedata!.verify != '0') {
                                    if (gethomedata?.result[index].isOpen ==
                                            "0" &&
                                        gethomedata?.result[index].isClose ==
                                            "0") {
                                      shakeKeys[index].currentState?.shake();
                                      Vibration.vibrate(duration: 700);
                                    } else {
                                      int isOpen = int.tryParse(gethomedata!
                                              .result[index].isOpen) ??
                                          0;
                                      int isClose = int.tryParse(gethomedata!
                                              .result[index].isClose) ??
                                          0;
                                      print("home open : $isOpen");
                                      print("home close : $isClose");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GameScreen(
                                            openTime: gethomedata!
                                                .result[index].openTime,
                                            closeTime: gethomedata!
                                                .result[index].closeTime,
                                            title: gethomedata
                                                    ?.result[index].market ??
                                                "",
                                            walletPrice: gethomedata!.wallet,
                                            isOpen: isOpen,
                                            isClose: isClose,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {}
                                },
                                child: ShakeMe(
                                  key: shakeKeys[index],
                                  // configure the animation parameters
                                  shakeCount: 5,
                                  shakeOffset: 5,
                                  shakeDuration: Duration(milliseconds: 700),
                                  child: Container(
                                    width: Get.width,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.symmetric(
                                            horizontal: BorderSide(
                                                color: gethomedata?.result[index].isOpen ==
                                                            "0" &&
                                                        gethomedata
                                                                ?.result[index]
                                                                .isClose ==
                                                            "0"
                                                    ? ColorUtils.closeBorder
                                                    : ColorUtils.openBorder,
                                                width: 5),
                                            vertical: BorderSide(
                                                color: gethomedata
                                                                ?.result[index]
                                                                .isOpen ==
                                                            "0" &&
                                                        gethomedata
                                                                ?.result[index]
                                                                .isClose ==
                                                            "0"
                                                    ? ColorUtils.closeBorder
                                                    : ColorUtils.openBorder,
                                                width: 1.5))),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5, left: 8, right: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              /* gethomedata?.verify != '0'
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(() => ChartScreen(
                                                            market: gethomedata
                                                                    ?.result[index]
                                                                    .market ??
                                                                "",
                                                          ));
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: ColorUtils.blue),
                                                        height: 40,
                                                        width: 40,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                height: 28,
                                                                width: 28,
                                                                child: Image.asset(
                                                                    ImageUtils
                                                                        .chart)),
                                                          ],
                                                        )),
                                                  )
                                                : Container(), */
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    gethomedata?.result[index]
                                                            .market ??
                                                        "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 1),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    gethomedata?.result[index]
                                                            .result ??
                                                        "",
                                                    style: TextStyle(
                                                        color: ColorUtils.blue,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      gethomedata?.result[index]
                                                                      .isOpen ==
                                                                  "0" &&
                                                              gethomedata
                                                                      ?.result[
                                                                          index]
                                                                      .isClose ==
                                                                  "0"
                                                          ? "Market Close"
                                                          : "Market Running",
                                                      style: TextStyle(
                                                          color: gethomedata
                                                                          ?.result[
                                                                              index]
                                                                          .isOpen ==
                                                                      "0" &&
                                                                  gethomedata
                                                                          ?.result[
                                                                              index]
                                                                          .isClose ==
                                                                      "0"
                                                              ? Colors.redAccent[
                                                                  700]
                                                              : Colors.green,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              gethomedata?.verify != '0'
                                                  ? Column(
                                                      children: [
                                                        Container(
                                                            height: 50,
                                                            width: 50,
                                                            child: Image.asset(gethomedata
                                                                            ?.result[
                                                                                index]
                                                                            .isOpen ==
                                                                        "0" &&
                                                                    gethomedata
                                                                            ?.result[
                                                                                index]
                                                                            .isClose ==
                                                                        "0"
                                                                ? ImageUtils
                                                                    .close
                                                                : ImageUtils
                                                                    .right)),
                                                        Text(
                                                          "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12,
                                                              letterSpacing: 1),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: gethomedata?.result[index]
                                                            .isOpen ==
                                                        "0" &&
                                                    gethomedata?.result[index]
                                                            .isClose ==
                                                        "0"
                                                ? ColorUtils.closeBorder
                                                : ColorUtils.openBorder,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(() => ChartScreen(
                                                        market: gethomedata
                                                                ?.result[index]
                                                                .market ??
                                                            "",
                                                      ));
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 5, left: 8),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    width: 20,
                                                    child: Image.asset(
                                                        ImageUtils.calender)),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 3),
                                                    child: Text(
                                                      "Open - ${gethomedata?.result[index].openTime.toUpperCase() ?? "HOLIDAY"}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 3),
                                                    child: Text(
                                                      "Close - ${gethomedata?.result[index].closeTime.toUpperCase() ?? "HOLIDAY"}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            List<String> timeParts = closeTimeString.split(':');
                            int hours = int.parse(timeParts[0]);
                            int minutes = int.parse(timeParts[1].split(' ')[0]);
                            String amPm = timeParts[1].split(' ')[1];

                            if (amPm.toLowerCase() == 'pm' && hours < 12) {
                              hours += 12;
                            }

                            DateTime closeTime = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              hours,
                              minutes,
                            );
                            DateTime currentTime = DateTime.now();
                            Duration difference =
                                closeTime.difference(currentTime);
                            String formattedDifference = difference.isNegative
                                ? ""
                                : formatDuration(difference);
                            return GestureDetector(
                              onTap: () {
                                if (gethomedata!.verify != '0') {
                                  if (gethomedata?.result[index].isOpen ==
                                          "0" &&
                                      gethomedata?.result[index].isClose ==
                                          "0") {
                                    shakeKeys[index].currentState?.shake();
                                    Vibration.vibrate(duration: 700);
                                  } else {
                                    int isOpen = int.tryParse(gethomedata!
                                            .result[index].isOpen) ??
                                        0;
                                    int isClose = int.tryParse(gethomedata!
                                            .result[index].isClose) ??
                                        0;
                                    print("home open : $isOpen");
                                    print("home close : $isClose");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameScreen(
                                          openTime: gethomedata!
                                              .result[index].openTime,
                                          closeTime: gethomedata!
                                              .result[index].closeTime,
                                          title: gethomedata
                                                  ?.result[index].market ??
                                              "",
                                          walletPrice: gethomedata!.wallet,
                                          isOpen: isOpen,
                                          isClose: isClose,
                                        ),
                                      ),
                                    );
                                  }
                                } else {}
                              },
                              child: ShakeMe(
                                key: shakeKeys[index],
                                // configure the animation parameters
                                shakeCount: 5,
                                shakeOffset: 5,
                                shakeDuration: Duration(milliseconds: 700),
                                child: Container(
                                  width: Get.width,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.symmetric(
                                          horizontal: BorderSide(
                                              color: gethomedata?.result[index]
                                                              .isOpen ==
                                                          "0" &&
                                                      gethomedata?.result[index]
                                                              .isClose ==
                                                          "0"
                                                  ? ColorUtils.closeBorder
                                                  : ColorUtils.openBorder,
                                              width: 5),
                                          vertical: BorderSide(
                                              color:
                                                  gethomedata?.result[index].isOpen == "0" &&
                                                          gethomedata
                                                                  ?.result[index]
                                                                  .isClose ==
                                                              "0"
                                                      ? ColorUtils.closeBorder
                                                      : ColorUtils.openBorder,
                                              width: 1.5))),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5, left: 8, right: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            /* gethomedata?.verify != '0'
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(() => ChartScreen(
                                                            market: gethomedata
                                                                    ?.result[index]
                                                                    .market ??
                                                                "",
                                                          ));
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: ColorUtils.blue),
                                                        height: 40,
                                                        width: 40,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                height: 28,
                                                                width: 28,
                                                                child: Image.asset(
                                                                    ImageUtils
                                                                        .chart)),
                                                          ],
                                                        )),
                                                  )
                                                : Container(), */
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  gethomedata?.result[index]
                                                          .market ??
                                                      "",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      letterSpacing: 1),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  gethomedata?.result[index]
                                                          .result ??
                                                      "",
                                                  style: TextStyle(
                                                      color: ColorUtils.blue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Container(
                                                  child: Text(
                                                    gethomedata?.result[index]
                                                                    .isOpen ==
                                                                "0" &&
                                                            gethomedata
                                                                    ?.result[
                                                                        index]
                                                                    .isClose ==
                                                                "0"
                                                        ? "Market Close"
                                                        : "Market Running",
                                                    style: TextStyle(
                                                        color: gethomedata
                                                                        ?.result[
                                                                            index]
                                                                        .isOpen ==
                                                                    "0" &&
                                                                gethomedata
                                                                        ?.result[
                                                                            index]
                                                                        .isClose ==
                                                                    "0"
                                                            ? Colors
                                                                .redAccent[700]
                                                            : Colors.green,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            gethomedata?.verify != '0'
                                                ? Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                          height: 50,
                                                          width: 50,
                                                          child: Image.asset(gethomedata
                                                                          ?.result[
                                                                              index]
                                                                          .isOpen ==
                                                                      "0" &&
                                                                  gethomedata
                                                                          ?.result[
                                                                              index]
                                                                          .isClose ==
                                                                      "0"
                                                              ? ImageUtils.close
                                                              : ImageUtils
                                                                  .right)),
                                                      Text(
                                                        "${formattedDifference}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 12,
                                                            letterSpacing: 1),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: gethomedata?.result[index]
                                                          .isOpen ==
                                                      "0" &&
                                                  gethomedata?.result[index]
                                                          .isClose ==
                                                      "0"
                                              ? ColorUtils.closeBorder
                                              : ColorUtils.openBorder,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            gethomedata?.verify != '0'
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Get.to(() => ChartScreen(
                                                            market: gethomedata
                                                                    ?.result[
                                                                        index]
                                                                    .market ??
                                                                "",
                                                          ));
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5, left: 8),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 20,
                                                        width: 20,
                                                        child: Image.asset(
                                                            ImageUtils
                                                                .calender)),
                                                  )
                                                : Container(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                                  child: Text(
                                                    "Open - ${gethomedata?.result[index].openTime.toUpperCase() ?? "HOLIDAY"}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                                  child: Text(
                                                    "Close - ${gethomedata?.result[index].closeTime.toUpperCase() ?? "HOLIDAY"}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                            // Text("data");
                          }),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  homeBox(String image, String title) {
    return Container(
      // height: 35,
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
          color: Color(0xFF005a4e), borderRadius: BorderRadius.circular(12)),
      width: Get.width * 0.47,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 24, width: 24, child: Image.asset(image)),
          SizedBox(
            width: 12,
          ),
          Center(
              child: Text(
            title,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          )),
        ],
      ),
    );
  }
}
