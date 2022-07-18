import 'dart:async';

import 'package:ferce_app/views/authentication/signIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import constants
import 'package:ferce_app/constants/images.dart';
import 'package:ferce_app/constants/colors.dart';
import 'package:ferce_app/constants/fonts.dart';
import 'package:ferce_app/constants/others.dart';
import 'package:iconsax/iconsax.dart';

class onboarding3 extends StatefulWidget {
  const onboarding3({Key? key}) : super(key: key);
  @override
  _onboarding3 createState() => _onboarding3();
}

class _onboarding3 extends State<onboarding3> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      child: SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.black),
            ),
            Container(
              margin: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 32 + 24),
                    height: 438,
                    width: 327,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/background/onboarding3.png'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 40),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Break Limits",
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Recoleta',
                            fontWeight: FontWeight.w500,
                            color: white),
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 168),
                      width: 332 + 24,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Break all limits, make a difference and standard with your own style!",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w300,
                            color: white),
                      ))
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
