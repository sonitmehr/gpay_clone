import 'package:flutter/cupertino.dart';

import '../screens/payment_successful_screen_wrapper.dart';
import '../screens/scanner_screen.dart';
import '../screens/under_development.dart';

String girlImage = "assets/images/girl.jpg";
String iconImage = "assets/icons/shopping-bag-dark-svg.svg";
String homeScreenImage = "assets/images/home_screen_image.PNG";
String inviteFriendsImage = "assets/images/invite_friends.PNG";

String senderUpi = "sonitmyl@okaxis";
String recieverUpi = "shreyamehrotra@fam";

List<String> iconImagePath = [
  "assets/images/scan_icon.svg",
  "assets/images/pay_contacts.svg",
  "assets/images/pay_to_phone.svg",
  "assets/images/bank_transfer.svg",
  "assets/images/pay_to_upi_id.svg",
  "assets/images/self_transder.svg",
  "assets/images/pay_bills.svg",
  "assets/images/mobile_recharge.svg",
];

List<String> iconTextList = [
  "Scan any QR Code",
  "Pay contacts",
  "Pay to Phone ",
  "Bank Transfer",
  "Pay to UPI ID",
  "Self transfer",
  "Pay bills",
  "Mobile Recharge",
];

List<Widget> iconRedirectList = [
  const ScanPage(),
  const PaymentSuccessWrapper(
    amount: "20",
    payingName: "BANKING NAME : Enzo Shop",
    upiID: "Enzo@paytm",
    bankingName: "Enzo Shop",
  ),
  const UnderDevelopmentScreen(),
  const UnderDevelopmentScreen(),
  const UnderDevelopmentScreen(),
  const UnderDevelopmentScreen(),
  const UnderDevelopmentScreen(),
  const UnderDevelopmentScreen(),
];
