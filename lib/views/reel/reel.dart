import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferce_app/models/reelModel.dart';
import 'package:ferce_app/views/reel/contentScreen.dart';
import 'package:ferce_app/views/reel/createReel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///add constants
import 'package:ferce_app/constants/colors.dart';
import 'package:video_player/video_player.dart';

class atReelScreen extends StatefulWidget {
  String uid;
  atReelScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  _atReelScreen createState() => _atReelScreen();
}

class _atReelScreen extends State<atReelScreen>
    with SingleTickerProviderStateMixin {
  String userId = '';

  List<reelModel> reelList = [];
  List videoList = [];
  List ownerId = [];
  List reelId = [];
  Future getReelList() async {
    FirebaseFirestore.instance
        .collection("reels")
        .orderBy('timeCreate', descending: true)
        .snapshots()
        .listen((value) {
      setState(() {
        reelList.clear();
        value.docs.forEach((element) {
          reelList.add(reelModel.fromDocument(element.data()));
        });
        print(reelList.length);
      });
    });
  }

  late SwiperController swiperController = SwiperController();
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    userId = userid!;
    print(userId);
    getReelList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshController() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return refreshController();
        },
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Swiper(
                controller: swiperController,
                itemBuilder: (BuildContext context, int index) {
                  return ContentScreen(
                    src: reelList[index].urlVideo,
                    uid: reelList[index].idUser,
                    reelId: reelList[index].id,
                  );
                },
                itemCount: reelList.length,
                scrollDirection: Axis.vertical,
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 24 + 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        // SizedBox(width: 117.5),
                        Container(
                          child: Text(
                            'Reel',
                            style: TextStyle(
                                fontFamily: 'Recoleta',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: white),
                          ),
                        ),
                        // SizedBox(width: 117.5),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          //             atPersonalInformationScreen(
                                          //                 required,
                                          //                 uid: ownerId))));

                                          atCreateReelScreen(context,
                                              uid: userId))));
                            },
                            child: Icon(Iconsax.camera, size: 28, color: white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // ContentScreen(like: like,)
            ],
          ),
        ),
      ),
    );
  }
}
