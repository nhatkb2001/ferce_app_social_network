// import 'dart:async';
// import 'dart:math';

// import 'package:ferce_app/views/authentication/signIn.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// //import constants
// import 'package:ferce_app/constants/images.dart';
// import 'package:ferce_app/constants/colors.dart';
// import 'package:ferce_app/constants/fonts.dart';
// import 'package:ferce_app/constants/others.dart';
// import 'package:iconsax/iconsax.dart';

// class onboarding4 extends StatefulWidget {
//   const onboarding4({Key? key}) : super(key: key);
//   @override
//   _onboarding4 createState() => _onboarding4();
// }

// class _onboarding4 extends State<onboarding4> {
//   late PageController pageController;
//   double viewportFraction = 0.554;
//   double? pageOffset = 0;
//   double? scale;
//   double _currentPosition = 0.0;
//   List<String> _listImage = [
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2F1.png?alt=media&token=65a3533b-5031-4e59-8f8c-d9ce19e1cfb1',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2F2.png?alt=media&token=11966588-56c6-4095-8384-d5ace33a586c',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2F3.png?alt=media&token=19e60157-b56f-4964-8687-6112f989309f',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2F4.png?alt=media&token=e9efe2da-eac1-4ef8-8109-1d6eb022a3f0',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2F5.png?alt=media&token=10beff0d-1f13-49b2-97a3-92332315d9ef',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2F6.png?alt=media&token=cfd93603-3efb-4159-8473-d0a247608e51',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2F7.png?alt=media&token=ab2c9e39-e55c-4b15-aafb-dca35c85b932',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage.png?alt=media&token=ec52545b-b302-4bd9-9e0b-cbc432e69bab',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage2.png?alt=media&token=2d162985-7373-4313-9379-beb341b2280d',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage3.png?alt=media&token=23a1fd5d-c38a-4157-830b-f7d7bd247b31',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage4.png?alt=media&token=5f2e1ac4-5a2d-4751-8d59-d92604ca13eb',
//     'https://firebasestorage.googleapis.com/v0/b/ferceapp.appspot.com/o/uploads%2FImage5.png?alt=media&token=8e79b4ea-7016-44a2-9896-723b75350081'
//   ];
//   @override
//   void initState() {
//     pageController = new PageController(
//         initialPage: 0, keepPage: true, viewportFraction: viewportFraction)
//       ..addListener(() {
//         setState(() {
//           pageOffset = pageController.page;
//         });
//       });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return AnnotatedRegion(
//       value: SystemUiOverlayStyle(
//           statusBarBrightness: Brightness.light,
//           statusBarIconBrightness: Brightness.light,
//           statusBarColor: Colors.transparent),
//       child: SafeArea(
//           child: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(color: Colors.black),
//             ),
//             Container(
//               margin: EdgeInsets.only(left: 24, right: 24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Container(
//                       margin: EdgeInsets.only(top: 40),
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "The Lead",
//                         style: TextStyle(
//                             fontSize: 32,
//                             fontFamily: 'Recoleta',
//                             fontWeight: FontWeight.w500,
//                             color: white),
//                       )),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Container(
//                       width: 332 + 24,
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "The pioneering application of social networks to develop the fashion clothing market.",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontFamily: 'Urbanist',
//                             fontWeight: FontWeight.w300,
//                             color: white),
//                       )),
//                   SizedBox(height: 40),
//                   Container(
//                     height: 464,
//                     child: CustomScrollView(
//                       slivers: <Widget>[
//                         SliverFillRemaining(
//                           child: FutureBuilder(builder: (context, _) {
//                             return PageView.builder(
//                                 controller: pageController,
//                                 onPageChanged: (num) {
//                                   if (num + 1 == 3) {
//                                     _currentPosition = 2.0;
//                                   } else if (num == 0) {
//                                     _currentPosition = 0.0;
//                                   } else {
//                                     _currentPosition = num.toDouble();
//                                   }
//                                 },
//                                 scrollDirection: Axis.vertical,
//                                 itemCount: _listImage.length,
//                                 itemBuilder: (context, index) {
//                                   double scale = max(
//                                       viewportFraction,
//                                       (1 - (pageOffset! - index).abs()) +
//                                           viewportFraction);
//                                   return Column(
//                                     children: [
//                                       Container(
//                                         width: 206.85 + (scale * 40),
//                                         height: 32 + (scale * 16),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: Image.network(
//                                             _listImage[index],
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 });
//                           }),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
