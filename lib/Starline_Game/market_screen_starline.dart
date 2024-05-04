// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:telugu_matka/Api_Calling/Data_Model/get_config_model.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/starline_timing_model.dart';
import 'package:telugu_matka/Api_Calling/Networking/api_service.dart';
import 'package:telugu_matka/App_Utils/color_utils.dart';
import 'package:telugu_matka/App_Utils/image_utils.dart';
import 'package:telugu_matka/Drawer_Screen/game_history.dart';
import 'package:telugu_matka/Drawer_Screen/win_history.dart';
import 'package:telugu_matka/Starline_Game/select_starline_game.dart';
import 'package:telugu_matka/Starline_Game/starline_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

class MarketScreen extends StatefulWidget {
  final String session;
  final String market;
  final String wallet;
  const MarketScreen(
      {super.key,
      required this.session,
      required this.market,
      required this.wallet});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  bool _isDisposed = false;
  bool isLoading = false;
  StarlineTiming? starlineTiming;
  String? eventTime;
  GetConfig? getConfigData;

  @override
  void initState() {
    super.initState();
    getMarketStarlineList();
    configData();
    /* timer = Timer.periodic(Duration(seconds: 0), (Timer t) {
      // updateTimedifference();
    }); */
  }

  Future<void> getMarketStarlineList() async {
    print("getData");
    setState(() {
      isLoading = true;
    });

    if (_isDisposed) {
      return;
    }

    setState(() {});
    starlineTiming =
        await ApiServices.starlineTiming(widget.market, widget.session);

    if (_isDisposed) {
      return;
    }

    setState(() {
      isLoading = false;
    });
    setState(() {});
  }

  Future<void> configData() async {
    if (mounted) {
      if (mounted) {
        getConfigData = await ApiServices.fetchGetConfigData();
        if (mounted) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: ColorUtils.blue,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          widget.market,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => StarlineChart(market: widget.market));
            },
            child: Container(
                margin: EdgeInsets.only(right: 18),
                height: 30,
                width: 30,
                child: Image.asset(ImageUtils.chart)),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorUtils.blue,
            ))
          : Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImageUtils.bluebg), fit: BoxFit.cover)),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Text(
                          "Starline Rates",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Single Digit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              starlineTiming?.single.replaceAll("/", " - ") ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Single Panna",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              starlineTiming?.singlepatti
                                      .replaceAll("/", " - ") ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Double Panna",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              starlineTiming?.doublepatti
                                      .replaceAll("/", " - ") ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Triple Panna",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              starlineTiming?.triplepatti
                                      .replaceAll("/", " - ") ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => BidHistory());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: ColorUtils.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Text(
                              "BID HISTORY",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => WinHistoryScreen());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: ColorUtils.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Text(
                              "WIN HISTORY",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: starlineTiming?.data.length,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        itemBuilder: (context, index) {
                          final List<GlobalKey<ShakeWidgetState>> shakeKeys =
                              List.generate(
                            starlineTiming?.data.length ?? 0,
                            (index) => GlobalKey<ShakeWidgetState>(),
                          );
                          return InkWell(
                              onTap: () {
                                if (starlineTiming?.data[index].isOpen == "0") {
                                  shakeKeys[index].currentState?.shake();
                                  Vibration.vibrate(duration: 700);
                                } else {
                                  Get.to(() => SelectStarlineGame(
                                      time: starlineTiming?.data[index].time ??
                                          "",
                                      market: widget.market,
                                      wallet: widget.wallet));
                                }
                              },
                              child: ShakeMe(
                                key: shakeKeys[index],
                                // configure the animation parameters
                                shakeCount: 5,
                                shakeOffset: 5,
                                shakeDuration: Duration(milliseconds: 700),
                                child: Container(
                                  width: Get.width,
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 3),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: ColorUtils.openBorder,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                          child: Text(
                                            "open Time - ${starlineTiming?.data[index].time.toUpperCase() ?? ""}",
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 0,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "${starlineTiming?.data[index].time.toUpperCase() ?? ""}",
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 17),
                                              ),
                                              Text(
                                                starlineTiming
                                                        ?.data[index].result ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                starlineTiming?.data[index]
                                                            .isOpen ==
                                                        "0"
                                                    ? "Market Closed"
                                                    : "Market Running",
                                                style: TextStyle(
                                                    color: starlineTiming
                                                                ?.data[index]
                                                                .isOpen ==
                                                            "0"
                                                        ? Colors.red[800]
                                                        : Colors.green[600],
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              starlineTiming?.data[index]
                                                          .isOpen ==
                                                      "0"
                                                  ? SizedBox(
                                                      height: 25,
                                                      width: 25,
                                                      child: Image.asset(
                                                        ImageUtils
                                                            .closeStarline,
                                                        color: Colors.red[900],
                                                      ))
                                                  : SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child: Image.asset(
                                                        ImageUtils.starlinePlay,
                                                        color:
                                                            Color(0xFF830080),
                                                      )),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                starlineTiming?.data[index]
                                                            .isOpen ==
                                                        "0"
                                                    ? "Closed"
                                                    : "Running",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
    );
  }
}
