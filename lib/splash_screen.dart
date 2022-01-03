import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset("assets/images/jci_logo.svg")),
            ),
            Align(
              child: Column(
                children: [
                  Text(
                    'Developed By',
                    style: TextStyle(
                      fontFamily: "pop-med",
                      fontSize: 11,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      "assets/images/logo.svg",
                      height: Get.height * 0.05,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Get.offNamed("/");
    });
  }
}
