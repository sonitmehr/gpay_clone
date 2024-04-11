import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color getRandomColor() {
  Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,
  );
}

showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

String randomHex() {
  Random random = Random();

  int r = random.nextInt(256);
  int g = random.nextInt(256);
  int b = random.nextInt(256);
  r = r.clamp(0, 255);
  g = g.clamp(0, 255);
  b = b.clamp(0, 255);

  String hexR = r.toRadixString(16).padLeft(2, '0');
  String hexG = g.toRadixString(16).padLeft(2, '0');
  String hexB = b.toRadixString(16).padLeft(2, '0');

  return '#$hexR$hexG$hexB';
}

Color hexToColor(String hexColor) {
  // Remove the '#' symbol if present
  hexColor = hexColor.replaceAll("#", "");

  // Parse the hexadecimal string to an integer
  int colorValue = int.parse(hexColor, radix: 16);

  // Create a Color object using the parsed value
  return Color(colorValue | 0xFF000000);
}

int generateRandom8DigitNumber() {
  Random random = Random();

  return random.nextInt(90000000) + 10000000;
}

String toDoubleString(String amount) {
  if (amount == "") {
    return "0.0";
  }
  try {
    double val = double.parse(amount);
    return val.toStringAsFixed(2);
  } catch (e) {
    return "0.0";
  }
}

String getCurrentDate() {
  DateTime date = DateTime.now();
  final DateFormat formatter = DateFormat('MMMM dd, yyyy h:mm a');
  return formatter.format(date);
}

String urlEncode(String upiID) {
  return upiID.replaceAll("/", "%2F");
}

String generateRandomEmail() {
  // Generate a random string for the username part of the email
  String username = Random.secure().nextInt(10000).toString();

  // Choose a random domain from a list of common email domains
  List<String> domains = [
    'gmail.com',
    'yahoo.com',
    'hotmail.com',
    'outlook.com',
    'example.com'
  ];
  String domain = domains[Random.secure().nextInt(domains.length)];

  // Return the generated email address
  return '$username@$domain';
}

double toDouble(String val) {
  if (val == "") return 0;
  try {
    return double.parse(val);
  } catch (e) {}
  return 0;
}

int toInt(String val) {
  if (val == "") return 0;
  try {
    return int.parse(val);
  } catch (e) {}
  return 0;
}

DateTime stringToDateTime(String dateString) {
  return DateTime.parse(dateString);
}
