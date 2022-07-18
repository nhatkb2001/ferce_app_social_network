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

class onboarding1 extends StatefulWidget {
  const onboarding1({Key? key}) : super(key: key);
  @override
  _onboarding1 createState() => _onboarding1();
}

class _onboarding1 extends State<onboarding1> {
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 217 + 24),
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/background/logoFerce.png'),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Ferce',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Recoleta',
                          fontWeight: FontWeight.w500,
                          color: white),
                    )),
                Spacer(),
                Container(
                    margin: EdgeInsets.only(bottom: 24),
                    alignment: Alignment.center,
                    child: Text(
                      'Developed by Minh Thinh - Anh Nhat',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w300,
                          color: white),
                    ))
              ],
            ),
          ],
        ),
      )),
    );
  }
}
