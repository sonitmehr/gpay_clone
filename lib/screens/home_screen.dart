// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gpay_clone/resources/utils.dart';
import 'package:gpay_clone/screens/home_screen_drawer.dart';
import 'package:gpay_clone/screens/payment_successful_screen_wrapper.dart';
import 'package:gpay_clone/screens/recent_people.dart';
import 'package:gpay_clone/screens/scanner_screen.dart';
import 'package:gpay_clone/screens/under_development.dart';
import 'package:gpay_clone/screens/transaction_history.dart';
import 'package:gpay_clone/styles/home_screen_styles.dart';
import 'package:gpay_clone/widgets/arrow_list_tile.dart';
import 'package:gpay_clone/widgets/asset_image.dart';
import 'package:gpay_clone/widgets/search_bar.dart';
import 'package:gpay_clone/widgets/user_profile_icon.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart' as model;
import '../providers/user_providers.dart';
import '../resources/colors.dart';
import '../resources/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    double fullScreenWidth = MediaQuery.of(context).size.width;
    double fullScreenHeight = MediaQuery.of(context).size.height;
    double iconWidth = 75;
    double iconHeight = 90;
    model.User user = Provider.of<UserProvider>(context).getUser;
    Color iconbackgroundColor = hexToColor(user.hexColor);
    // final UserProvider userProvider = Provider.of<UserProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeScreenDrawer(),
      backgroundColor: backgroundColor,
      body: (user.uid == "")
          ? const Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: fullScreenWidth * 0.06,
                      vertical: fullScreenHeight * 0.06),
                  child: Row(
                    children: [
                      SizedBox(
                          width: fullScreenWidth * 0.71,
                          height: fullScreenHeight * 0.059,
                          child: const CustomSearchBar()),
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        child: UserProfileIcon(
                          backgroundColor: iconbackgroundColor,
                          radius: 17,
                          name: user.name,
                        ),
                      )
                    ],
                  ),
                ),
                AssetImageViewer(
                    assetImage: homeScreenImage,
                    height: fullScreenHeight * 0.199),
                SizedBox(
                  height: fullScreenHeight * 0.012,
                ),
                SizedBox(
                  height: fullScreenHeight * 0.24,
                  child: GridView.count(
                    crossAxisCount: 4, // Number of columns
                    childAspectRatio: 1.0, // Aspect ratio
                    padding: EdgeInsets.symmetric(
                        vertical: fullScreenHeight * 0.009,
                        horizontal: fullScreenWidth * 0.02), // Padding
                    children: List.generate(8, (index) {
                      // Generate 8 grid items
                      return GridTile(
                        child: SizedBox(
                            width: iconWidth,
                            height: iconHeight,
                            child: callToActionIcon(
                                context,
                                iconImagePath[index],
                                iconTextList[index],
                                (context) => iconRedirectList[index])),
                      );
                    }),
                  ),
                ),

                // iconsFirstRow(context, iconWidth, iconHeight),
                // iconsSecondRow(context, iconWidth, iconHeight),
                Center(
                  child: Container(
                      width: fullScreenWidth * 0.41,
                      padding: EdgeInsets.symmetric(
                          vertical: fullScreenHeight * 0.0049,
                          horizontal: fullScreenWidth * 0.035),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: upiIDBorderColor),
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: fullScreenWidth * 0.25,
                            child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'UPI ID: vpa@bank',
                                  style: TextStyle(fontFamily: 'Product Sans'),
                                )),
                          ),
                          SizedBox(
                            width: fullScreenWidth * 0.05,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Icon(
                                Icons.copy_sharp,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: fullScreenHeight * 0.062,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: fullScreenWidth * 0.061,
                        vertical: fullScreenHeight * 0.019),
                    child: const Text(
                      'People',
                      style:
                          TextStyle(fontSize: 25, fontFamily: 'Product Sans'),
                    ),
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: fullScreenHeight * 0.186,
                    child: const RecentPeople()),
                ArrowListTile(
                  icon: const Icon(
                    Icons.history,
                    color: gpayBlue,
                  ),
                  text: "Show transaction history",
                  builder: (context) => const TransactionHistory(),
                ),
                AssetImageViewer(
                    assetImage: inviteFriendsImage,
                    height: fullScreenHeight * 0.37),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: fullScreenHeight * 0.04,
                      horizontal: fullScreenWidth * 0.08),
                  child: const Text(
                    'Showing businesses based on your location - Learn more',
                    textAlign: TextAlign.center,
                    style: bottomTextStyle,
                  ),
                )
              ]),
            ),
    );
  }
}

Widget iconsFirstRow(
    BuildContext context, double iconWidth, double iconHeight) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: callToActionIcon(context, "assets/images/scan_icon.svg",
                "Scan any QR Code", (context) => const ScanPage())),
        SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: callToActionIcon(
                context,
                "assets/images/pay_contacts.svg",
                "Pay contacts",
                (context) => const PaymentSuccessWrapper(
                      amount: "20",
                      payingName: "BANKING NAME : Enzo Shop",
                      upiID: "Enzo@paytm",
                      bankingName: "Enzo Shop",
                    ))),
        SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: callToActionIcon(context, "assets/images/pay_to_phone.svg",
                "Pay to Phone ", (context) => const UnderDevelopmentScreen())),
        SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: callToActionIcon(context, "assets/images/bank_transfer.svg",
                "Bank Transfer", (context) => const UnderDevelopmentScreen())),
      ],
    ),
  );
}

Widget iconsSecondRow(
    BuildContext context, double iconWidth, double iconHeight) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: callToActionIcon(context, "assets/images/pay_to_upi_id.svg",
                "Pay to UPI ID", (context) => const UnderDevelopmentScreen())),
        SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: callToActionIcon(context, "assets/images/self_transder.svg",
                "Self transfer", (context) => const UnderDevelopmentScreen())),
        SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: callToActionIcon(context, "assets/images/pay_bills.svg",
                "Pay bills", (context) => const UnderDevelopmentScreen())),
        SizedBox(
            width: iconWidth,
            height: iconHeight,
            child: callToActionIcon(
                context,
                "assets/images/mobile_recharge.svg",
                "Mobile Recharge",
                (context) => const UnderDevelopmentScreen())),
      ],
    ),
  );
}

Widget callToActionIcon(BuildContext context, String imageAsset, String text,
    Widget Function(BuildContext) builder) {
  return GestureDetector(
    onTap: () async {
      Navigator.push(context, MaterialPageRoute(builder: builder));
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            child: SvgPicture.asset(
              imageAsset,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Product Sans', color: hexToColor("#363636")),
          ),
        )
      ],
    ),
  );
}
