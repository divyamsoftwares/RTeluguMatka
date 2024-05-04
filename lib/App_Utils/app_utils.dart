import 'dart:math';

import 'package:intl/intl.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('EEE dd-MMM-yyyy');
    return formatter.format(now);
  }

String formatTime(String time24) {
  final DateFormat inputFormat = DateFormat.Hm(); // Input format (24-hour)
  final DateFormat outputFormat = DateFormat('hh:mm a'); // Output format (12-hour with AM/PM)

  try {
    // Parse input time
    DateTime dateTime = inputFormat.parse(time24);

    // Format the time in 12-hour format with AM/PM
    return outputFormat.format(dateTime);
  } catch (e) {
    // Handle the case where the input time is not in the expected format
    return "";
  }
}

String apiLinkUrl = "";