// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/gali_disawar_gamerate.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/gali_disawar_games_model.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/get_config_model.dart';
import 'package:telugu_matka/Api_Calling/Networking/api_service.dart';
import 'package:telugu_matka/App_Utils/color_utils.dart';
import 'package:telugu_matka/App_Utils/image_utils.dart';
import 'package:telugu_matka/Gali_Disawar/bid_history_galiDS.dart';
import 'package:telugu_matka/Gali_Disawar/gali_disawar_games.dart';
import 'package:telugu_matka/Gali_Disawar/gali_disawar_win_history.dart';
import 'package:vibration/vibration.dart';

class GaliDisawar extends StatefulWidget {
  final String wallet;
  const GaliDisawar({super.key, required this.wallet});

  @override
  State<GaliDisawar> createState() => _GaliDisawarState();
}

class _GaliDisawarState extends State<GaliDisawar> {
  GetConfig? getConfigData;
  GameRateGaliDisawar? gamerateGaliDisawar;
  GetGaliDsGame? galiDSGame;
  bool _isDisposed = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getGameRate();
  }

  Future<void> getGameRate() async {
    print("getGameData");
    if (_isDisposed) {
      return;
    }

    setState(() {});

    setState(() {
      isLoading = true;
    });

    galiDSGame = await ApiServices.fetchGaliDSGame();
    gamerateGaliDisawar = await ApiServices.fetchGameRateGaliDisawar();
    getConfigData = await ApiServices.fetchGetConfigData();

    setState(() {
      isLoading = false;
    });

    if (_isDisposed) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorUtils.blue,
        centerTitle: true,
        titleSpacing: 0,
        title: Text("Gali Disawar",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
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
                    height: 12,
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
                          "Gali Disawar Rates",
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
                              gamerateGaliDisawar?.result.first.single
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
                              "Jodi Digit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              gamerateGaliDisawar?.result.last.jodi
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => GameHistoryGaliDS());
                          },
                          child: Container(
                            width: Get.width * 0.45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white),
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.red[800],
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Text(
                                "BID HISTORY",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => GaliWinHistory());
                          },
                          child: Container(
                            width: Get.width * 0.45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white),
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.red[800],
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Text(
                                "WIN HISTORY",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 12),
                        itemCount: galiDSGame?.result.length,
                        itemBuilder: (context, index) {
                          final List<GlobalKey<ShakeWidgetState>> shakeKeys =
                              List.generate(
                            galiDSGame?.result.length ?? 0,
                            (index) => GlobalKey<ShakeWidgetState>(),
                          );
                          return InkWell(
                            onTap: () {
                              if (galiDSGame?.result[index].betting == "0") {
                                shakeKeys[index].currentState?.shake();
                                Vibration.vibrate(duration: 700);
                              } else {
                                Get.to(() => GaliDisawarGames(
                                    title: galiDSGame?.result[index].name
                                            .toUpperCase() ??
                                        "",
                                    wallet: widget.wallet,
                                    closeTime:
                                        galiDSGame?.result[index].close ?? "",
                                    gameName:
                                        galiDSGame?.result[index].name ?? "",
                                    gameId: galiDSGame?.result[index].gameid ??
                                        ""));
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          galiDSGame?.result[index].name
                                                  .toUpperCase() ??
                                              "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          galiDSGame?.result[index].close ?? "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          galiDSGame?.result[index].result ??
                                              "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                         galiDSGame?.result[index].betting ==
                                                  "0" ? SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: Image.asset(ImageUtils.closeStarline,color: Colors.red[900],
                                                      )) : SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: Image.asset(ImageUtils.starlinePlay,color: Color(0xFF830080),
                                                      )) ,
                                        /* SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(galiDSGame
                                                        ?.result[index]
                                                        .betting ==
                                                    "0"
                                                ? ImageUtils.close
                                                : ImageUtils.right)), */
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          galiDSGame?.result[index].betting ==
                                                  "0"
                                              ? "Closed"
                                              : "Running",
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  /* InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return GameRateGaliDSDialog(
                            singleDigit: gamerateGaliDisawar
                                    ?.result.first.single
                                    .replaceAll("/", " - ") ??
                                "",
                            jodiDigit: gamerateGaliDisawar?.result.last.jodi
                                    .replaceAll("/", " - ") ??
                                "");
                      },
                    );
                  },
                  child: Container(
                    width: Get.width,
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Center(
                        child: Text(
                      "GALI DISAWAR GAME RATES",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    )),
                  ),
                ) */
                ],
              ),
            ),
    );
  }
}
