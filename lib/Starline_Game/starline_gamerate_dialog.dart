// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StarlineGameRate extends StatefulWidget {
  final String singleDigit;
  final String singlePanna;
  final String doublePanna;
  final String triplePanna;
  const StarlineGameRate({super.key, required this.singleDigit, required this.singlePanna, required this.doublePanna, required this.triplePanna});

  @override
  State<StarlineGameRate> createState() => _StarlineGameRateState();
}

class _StarlineGameRateState extends State<StarlineGameRate> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.zero,
          surfaceTintColor: Colors.white,
          content: Stack(
            children: [
              Container(
            height: Get.height * 0.23,
            width: Get.width * 0.85,
           
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10,),
                Text(
                  "Starline",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                ),
                SizedBox(height: 22,),
                Column(
                  children: [
                    Center(
                      child: Text(
                        "Single Digit : ${widget.singleDigit}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),
                      ),
                    ),
                    Center(
                  child: Text(
                    "Single Panna : ${widget.singlePanna}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),
                  ),
                ),
                    Center(
                  child: Text(
                    "Double Panna : ${widget.doublePanna}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),
                  ),
                ),
                    Center(
                  child: Text(
                    "Triple Panna : ${widget.triplePanna}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),
                  ),
                ),
                  ],
                ),
              ],
            ),
          ),
            ],
          )
        );
  }
}