// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telugu_matka/Api_Calling/Networking/api_service.dart';
import 'package:telugu_matka/App_Utils/color_utils.dart';

class StarlineChart extends StatefulWidget {
  final String market;
  const StarlineChart({super.key, required this.market});

  @override
  State<StarlineChart> createState() => _StarlineChartState();
}

class _StarlineChartState extends State<StarlineChart> {
  Map? jsonData;
  bool isLoading = false;
  bool _isDisposed = false;
  String? getChartData;

  @override
  void initState() {
    super.initState();
    // fetchData();
    chartData();
    chartDataHtml();
  }

  Future<void> chartData() async {
    print("getData");
    setState(() {
      isLoading = true;
    });

    if (_isDisposed) {
      return;
    }

    setState(() {});
    await ApiServices.fetchChartData(widget.market).then((value) {
      getChartData = value;
      log("hbhbjhjkkuih >>>>> ${value.toString()}");
    });

    if (_isDisposed) {
      return;
    }

    setState(() {
      isLoading = false;
    });
    setState(() {});
  }

  chartDataHtml() {
    if (getChartData != null) {
      log("hbajdcjkfn ckm : $getChartData");
    } else {
      log("hbajdcjkfn ckm : null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: ColorUtils.blue,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: ColorUtils.white,
            )),
        centerTitle: true,
        title: Text(
          widget.market,
          style: TextStyle(
            fontSize: 18,
            color: ColorUtils.white,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorUtils.blue,
            ))
          : Column(
              children: [
                Container(
                  // height: Get.height * 0.2,
                  width: Get.width,
                  color: Colors.blue[50],
                  child: Center(
                    child: HtmlWidget(
                        //to show HTML as widget.
                        getChartData.toString()),
                  ),
                )
              ],
            ),
    );
  }
}
