// ignore_for_file: prefer_const_constructors, unused_field, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:telugu_matka/App_Utils/app_utils.dart';
import 'package:telugu_matka/App_Utils/image_utils.dart';
import 'package:telugu_matka/Authentication/login_screen.dart';
import 'package:telugu_matka/Home_Screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? mobile;
  String? pass;
  String? session;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchUrl();
  }

  Future<void> fetchUrl() async {
    final response =
        await http.get(Uri.parse('https://api.npoint.io/d05befb59dc4c73708f5'));
    if (response.statusCode == 200) {
      var geturl = json.decode(response.body);
      log("Get String response>>>${geturl['APILink']}");
      apiLinkUrl = geturl['APILink'];
      getData();
    } else {
      getData();
      throw Exception('Failed to load users');
    }
  }

  void getData() {
    getSavedBodyData();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted && session == null) {
        print("LoginScreen session : $session");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        print("HomeScreen session : $session");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
      /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen())); */
    });
  }

  Future<Map<String, dynamic>?> getSavedBodyData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? bodydataJson = prefs.getString('bodydata');

    if (bodydataJson != null) {
      final Map<String, dynamic> savedBodydata = json.decode(bodydataJson);

      mobile = savedBodydata["mobile"] ?? "";
      pass = savedBodydata["pass"] ?? "";
      session = savedBodydata["session"] ?? "";

      setState(() {});
    } else {
      print("Bodydata not found in shared preferences.");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImageUtils.bluebg), fit: BoxFit.cover)),
        child: Center(
          child: SizedBox(
              height: 220,
              width: 220,
              child: Image(
                image: AssetImage(ImageUtils.logoRmoveBg),
                fit: BoxFit.cover,
              )),
        ),
      ),
    );
  }
}
