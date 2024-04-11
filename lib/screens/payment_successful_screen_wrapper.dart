import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gpay_clone/resources/utils.dart';
import 'package:gpay_clone/screens/payment_succesful_screen.dart';
import 'package:gpay_clone/screens/tick_animation_screen.dart';

class PaymentSuccessWrapper extends StatefulWidget {
  final String amount;
  final String payingName;
  final String upiID;
  final String bankingName;
  const PaymentSuccessWrapper({
    super.key,
    required this.amount,
    required this.payingName,
    required this.upiID,
    required this.bankingName,
  });

  @override
  State<PaymentSuccessWrapper> createState() => _PaymentSuccessWrapperState();
}

class _PaymentSuccessWrapperState extends State<PaymentSuccessWrapper> {
  bool isAnimation = true;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    playSound();
    super.initState();

    tickAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedContainer(
            margin: EdgeInsets.only(top: isAnimation ? 150 : 100),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: const TickAnimationScreen()),
        if (!isAnimation)
          Expanded(
            child: PaymentSuccessfulScreen(
              amount: widget.amount,
              payingName: widget.payingName,
              upiID: widget.upiID,
              bankingName: widget.bankingName,
            ),
          ),
      ],
    )
        // : PaymentSuccessfulScreen(
        //     amount: widget.amount,
        //     payingName: widget.payingName,
        //     upiID: widget.upiID),
        );
  }

  void tickAnimation() {
    Timer(Duration(milliseconds: 2600), () {
      setState(() {
        isAnimation = false;
      });
    });
  }

  Future<void> playSound() async {
    await audioPlayer.play(AssetSource('audio/success_sound.mp3'));
  }
}
