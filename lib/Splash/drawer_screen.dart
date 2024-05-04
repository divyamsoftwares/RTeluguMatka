// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, unnecessary_null_comparison, unused_element, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telugu_matka/App_Utils/color_utils.dart';
import 'package:telugu_matka/App_Utils/image_utils.dart';
import 'package:telugu_matka/Authentication/login_screen.dart';
import 'package:telugu_matka/Drawer_Screen/change_password.dart';
import 'package:telugu_matka/Drawer_Screen/contact_us.dart';
import 'package:telugu_matka/Drawer_Screen/edit_profile.dart';
import 'package:telugu_matka/Drawer_Screen/game_history.dart';
import 'package:telugu_matka/Drawer_Screen/game_rates.dart';
import 'package:telugu_matka/Drawer_Screen/wallet_screen.dart';
import 'package:telugu_matka/Drawer_Screen/win_history.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerScreen extends StatefulWidget {
  final String wallet;
  final String username;
  final String verify;
  final String playstoreUrl;

  const DrawerScreen({
    super.key,
    required this.wallet,
    required this.username,
    required this.verify,
    required this.playstoreUrl,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String? mobile;
  String? pass;
  String? session;
  // HomeData? gethomedata;
  // bool _isDisposed = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSavedBodyData();
  }

  @override
  didChangeDependencies() {
    getSavedBodyData();
    super.didChangeDependencies();
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
        // getData();
        // configData();
      }

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  Future<void> printAndRemoveSessionData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? sessionValueBefore = prefs.getString('bodydata');
    print("Session Value Before Remove: $sessionValueBefore");

    prefs.remove('bodydata');

    final String? sessionValueAfter = prefs.getString('bodydata');
    print("Session Value After Remove: $sessionValueAfter");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: Get.width * 0.85,
        child: Container(
          height: Get.height,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImageUtils.bluebg), fit: BoxFit.cover)),
          // color: Colors.white,
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: ColorUtils.blue,
                    height: 30,
                  ),
                  Container(
                    color: ColorUtils.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 90,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                              Image(image: AssetImage(ImageUtils.logoRmoveBg)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.username,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            widget.verify != '0'
                                ? Text(
                                    mobile!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    ),
                  ),
                  Container(
                    color: ColorUtils.blue,
                    height: 30,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -1),
                    leading: Container(
                        height: Get.height * 0.04,
                        width: Get.width * 0.06,
                        child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              ImageUtils.drawerHome,
                            ))),
                    onTap: () {
                      Get.back();
                    },
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  widget.verify != '0'
                      ? ListTile(
                          visualDensity: VisualDensity(vertical: -1),
                          leading: Container(
                              height: Get.height * 0.04,
                              width: Get.width * 0.06,
                              child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset(
                                    ImageUtils.drawerProfile,
                                  ))),
                          onTap: () {
                            Get.to(() => EditProfile());
                          },
                          title: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Container(),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -1),
                    leading: Container(
                        height: Get.height * 0.04,
                        width: Get.width * 0.06,
                        child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              ImageUtils.drawerChangePassword,
                            ))),
                    onTap: () {
                      Get.to(() => ChangePassword());
                    },
                    title: const Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  widget.verify != '0'
                      ? ListTile(
                          visualDensity: VisualDensity(vertical: -1),
                          leading: Container(
                              height: Get.height * 0.04,
                              width: Get.width * 0.06,
                              child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset(
                                    ImageUtils.drawerWallet,
                                  ))),
                          onTap: () {
                            Get.to(() => WalletScreen(wallet: widget.wallet));
                          },
                          title: const Text(
                            'Wallet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Container(),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  widget.verify != '0'
                      ? ListTile(
                          visualDensity: VisualDensity(vertical: -1),
                          leading: Container(
                              height: Get.height * 0.04,
                              width: Get.width * 0.06,
                              child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset(
                                    ImageUtils.drawerWInHistory,
                                  ))),
                          onTap: () {
                            Get.to(() => WinHistoryScreen());
                          },
                          title: const Text(
                            'Win History',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Container(),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  widget.verify != '0'
                      ? ListTile(
                          visualDensity: VisualDensity(vertical: -1),
                          leading: Container(
                              height: Get.height * 0.04,
                              width: Get.width * 0.06,
                              child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset(
                                    ImageUtils.drawerBidHistory,
                                  ))),
                          onTap: () {
                            Get.to(() => BidHistory());
                          },
                          title: const Text(
                            'Game History',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Container(),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  widget.verify != '0'
                      ? ListTile(
                          visualDensity: VisualDensity(vertical: -1),
                          leading: Container(
                              height: Get.height * 0.04,
                              width: Get.width * 0.06,
                              child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset(
                                    ImageUtils.drawerGameRates,
                                  ))),
                          onTap: () {
                            Get.to(() => GameRatesScreen());
                          },
                          title: const Text(
                            'Game Rates',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Container(),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -1),
                    leading: Container(
                        height: Get.height * 0.04,
                        width: Get.width * 0.06,
                        child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              ImageUtils.drawerShare,
                            ))),
                    onTap: () {
                      String shareurl = widget.playstoreUrl;
                      print("url :::::: $shareurl");
                      Share.share("com.sara.seven.matka.app");
                    },
                    title: const Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -1),
                    leading: Container(
                        height: Get.height * 0.04,
                        width: Get.width * 0.06,
                        child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              ImageUtils.drawerContact,
                            ))),
                    onTap: () {
                      Get.to(() => ContactUsScreen());
                    },
                    title: const Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -1),
                    leading: Container(
                        height: Get.height * 0.04,
                        width: Get.width * 0.06,
                        child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              ImageUtils.drawerRating,
                            ))),
                    onTap: () {
                      _launchUrl(widget.playstoreUrl);
                    },
                    title: const Text(
                      'Rating',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: -1),
                    leading: Container(
                        height: Get.height * 0.04,
                        width: Get.width * 0.06,
                        child: SizedBox(
                            height: 25,
                            width: 25,
                            child: Image.asset(ImageUtils.logout))),
                    onTap: () {
                      printAndRemoveSessionData();
                    },
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
