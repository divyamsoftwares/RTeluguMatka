// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telugu_matka/App_Utils/color_utils.dart';
import 'package:telugu_matka/App_Utils/image_utils.dart';
import 'package:telugu_matka/Drawer_Screen/wallet_screen.dart';
import 'package:telugu_matka/Home_Screen/play_screen.dart';
import 'package:telugu_matka/Home_Screen/play_screen2.dart';

class GameScreen extends StatefulWidget {
  final String title;
  final String openTime;
  final String closeTime;
  final int isOpen;
  final int isClose;
  final String walletPrice;
  const GameScreen(
      {super.key,
      required this.title,
      required this.openTime,
      required this.closeTime,
      required this.isOpen,
      required this.isClose,
      required this.walletPrice});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.blue,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(() => WalletScreen(wallet: widget.walletPrice));
              },
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    ImageUtils.wallet,
                    color: Colors.white,
                  ))),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.walletPrice,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => PlayScreen(
                        walletPrice: widget.walletPrice,
                        title: "Single Digit",
                        bazar: widget.title,
                        openPlay: widget.isOpen,
                        closePlay: widget.isClose,
                      ));
                },
                child: game(ImageUtils.icon_single_digit, "Single Digit"),
              ),
              SizedBox(
                width: 25,
              ),
              GestureDetector(
                onTap: () {
                  if (widget.isOpen == 0 && widget.isClose == 1) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return sessionCloseDialog();
                        });
                    print("NOOOOOOOOO");
                  } else {
                    print("YESSSSSSSSSSS");
                    Get.to(() => PlayScreen(
                        walletPrice: widget.walletPrice,
                        title: "Jodi Digit",
                        bazar: widget.title,
                        openPlay: widget.isOpen,
                        closePlay: widget.isClose));
                  }
                },
                child: game(ImageUtils.icon_double_digit, "Jodi Digit"),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => PlayScreen(
                      walletPrice: widget.walletPrice,
                      bazar: widget.title,
                      title: "Single Panna",
                      openPlay: widget.isOpen,
                      closePlay: widget.isClose));
                },
                child: game(ImageUtils.icon_single_pana, "Single Panna"),
              ),
              SizedBox(
                width: 25,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => PlayScreen(
                      walletPrice: widget.walletPrice,
                      bazar: widget.title,
                      title: "Double Panna",
                      openPlay: widget.isOpen,
                      closePlay: widget.isClose));
                },
                child: game(ImageUtils.icon_double_pana, "Double Panna"),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => PlayScreen(
                  walletPrice: widget.walletPrice,
                  bazar: widget.title,
                  title: "Triple Panna",
                  openPlay: widget.isOpen,
                  closePlay: widget.isClose));
            },
            child: game(ImageUtils.icon_triple_pana, "Triple Panna"),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.isOpen == 0 && widget.isClose == 1) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return sessionCloseDialog();
                        });
                  } else {
                    Get.to(() => PlayScreen2(
                          walletPrice: widget.walletPrice,
                          title: "Half Sangam",
                          openPlay: widget.isOpen,
                          bazar: widget.title,
                          closePlay: widget.isClose,
                        ));
                  }
                },
                child: game(ImageUtils.icon_sangam_half, "Half Sangam"),
              ),
              SizedBox(
                width: 25,
              ),
              GestureDetector(
                onTap: () {
                  if (widget.isOpen == 0 && widget.isClose == 1) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return sessionCloseDialog();
                        });
                  } else {
                    Get.to(() => PlayScreen2(
                          walletPrice: widget.walletPrice,
                          title: "Full Sangam",
                          openPlay: widget.isOpen,
                          bazar: widget.title,
                          closePlay: widget.isClose,
                        ));
                  }
                },
                child: game(ImageUtils.icon_sangam_full, "Full Sangam"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  game(String image, String title) {
    return CircleAvatar(
      radius: 60,
      backgroundImage: AssetImage(image),
      backgroundColor: Colors.white,
      // child: Text(title,style: TextStyle(color: Colors.white),),
    );
  }

  sessionCloseDialog() {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      content: SizedBox(
        height: Get.height * 0.18,
        width: Get.width * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Session Completed",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Center(
              child: Text(
                  "Open session is completed. You can't place bid on Jodi Digit.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ColorUtils.blue,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
