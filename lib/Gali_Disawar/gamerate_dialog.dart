// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameRateGaliDSDialog extends StatefulWidget {
  final String singleDigit;
  final String jodiDigit;
  const GameRateGaliDSDialog({super.key, required this.singleDigit, required this.jodiDigit});

  @override
  State<GameRateGaliDSDialog> createState() => _GameRateGaliDSDialogState();
}

class _GameRateGaliDSDialogState extends State<GameRateGaliDSDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
          /* surfaceTintColor: ColorUtils.blue,
          backgroundColor: ColorUtils.blue, */
          content: Stack(
            children: [
              Container(
            height: 150,
            width: Get.width * 0.85,
            
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 15,),
                Text(
                  "Gali Disawar",
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
                    "Jodi Digit : ${widget.jodiDigit}",
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