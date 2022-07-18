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
import 'package:themed/themed.dart';
import 'package:dots_indicator/dots_indicator.dart';

class onboarding2 extends StatefulWidget {
  const onboarding2({Key? key}) : super(key: key);
  @override
  _onboarding2 createState() => _onboarding2();
}

class _onboarding2 extends State<onboarding2> {
  List<String> _listImage = [
    'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage.png?alt=media&token=ec52545b-b302-4bd9-9e0b-cbc432e69bab',
    'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage2.png?alt=media&token=2d162985-7373-4313-9379-beb341b2280d',
    'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage3.png?alt=media&token=23a1fd5d-c38a-4157-830b-f7d7bd247b31',
    'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage4.png?alt=media&token=5f2e1ac4-5a2d-4751-8d59-d92604ca13eb',
    'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage5.png?alt=media&token=8e79b4ea-7016-44a2-9896-723b75350081'
  ];
  double _currentPosition = 0.0;
  PageController _pageController =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 0.6);
  double cl = 0.0;

  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.only(top: 32 + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 368 + 24,
                    width: 375 + 24,
                    child: ListView.builder(
                        controller: _pageController,
                        itemCount: _listImage.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Stack(children: [
                            Container(
                              margin: EdgeInsets.only(right: 24, left: 36),
                              width: 315,
                              height: 368,
                              child: ChangeColors(
                                saturation: cl,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    _listImage[index],
                                    fit: BoxFit.cover,
                                    width: 315,
                                    height: 368,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12, left: 12),
                              child: Container(
                                margin: EdgeInsets.only(right: 24, left: 36),
                                width: 315,
                                height: 368,
                                decoration: BoxDecoration(
                                    border: Border.all(color: white),
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ]);
                        }),
                  ),
                  SizedBox(height: 32),
                  Container(
                    margin: EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  if (cl == 0.0) {
                                    setState(() {
                                      cl = -1.0;
                                    });
                                  } else {
                                    setState(() {
                                      cl = 0.0;
                                    });
                                  }
                                },
                                child: Container(
                                  width: 24 + 8,
                                  height: 24 + 8,
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Icon(
                                    Iconsax.paintbucket,
                                    color: black,
                                    size: 24,
                                  ),
                                ),
                              )
                            ]),
                        SizedBox(height: 40),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Relate",
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
                            width: 332 + 24,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "A social networks help to build your own brand, shape your own store style!",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w300,
                                  color: white),
                            ))
                      ],
                    ),
                  ),
                  // DotsIndicator(
                  //   dotsCount: _listImage.length,
                  //   position: _currentPosition,
                  //   decorator: DotsDecorator(
                  //     size: const Size.square(9.0),
                  //     activeSize: const Size(18.0, 9.0),
                  //     activeShape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(5.0)),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
