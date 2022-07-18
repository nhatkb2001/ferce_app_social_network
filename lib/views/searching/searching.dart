import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferce_app/constants/colors.dart';
import 'package:ferce_app/models/postModel.dart';
import 'package:ferce_app/models/userModel.dart';
import 'package:ferce_app/views/notification/postNotification.dart';
import 'package:ferce_app/views/profile/image.dart';
import 'package:ferce_app/views/profile/profile.dart';
import 'package:ferce_app/views/profile/video.dart';
import 'package:ferce_app/views/searching/classifyImage.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

///add constants
import 'package:tflite/tflite.dart';

class atSearchScreen extends StatefulWidget {
  String uid;
  atSearchScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  _atSearchScreen createState() => _atSearchScreen(uid);
}

class _atSearchScreen extends State<atSearchScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  _atSearchScreen(this.uid);
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String search = '';
  List<postModel> postListCaption = [];

  Future searchCaption() async {
    FirebaseFirestore.instance.collection("posts").snapshots().listen((value) {
      setState(() {
        postListCaption.clear();
        postList.clear();
        value.docs.forEach((element) {
          postListCaption.add(postModel.fromDocument(element.data()));
        });

        postListCaption.forEach((element) {
          print(
              (element.caption.toUpperCase().contains(search.toUpperCase())) ==
                  true);
          if (((element.caption + " ")
                  .toUpperCase()
                  .contains(search.toUpperCase())) ==
              true) {
            postList.add(element);
            print(postList.length);
          }
        });
        if (postList.isEmpty) {}
      });
    });
  }

  List<userModel> userSearch = [];
  Future searchName() async {
    FirebaseFirestore.instance.collection("users").snapshots().listen((value) {
      setState(() {
        userSearch.clear();
        userList.clear();
        value.docs.forEach((element) {
          userSearch.add(userModel.fromDocument(element.data()));
        });

        userSearch.forEach((element) {
          print((element.email.toUpperCase().contains(search.toUpperCase())) ==
              true);
          if (((element.email + " ")
                  .toUpperCase()
                  .contains(search.toUpperCase())) ==
              true) {
            userList.add(element);
            print(userList.length);
          }
        });
        userList.forEach((element) {
          print(element.id);
          if (element.id == uid) {
            setState(() {
              userList.remove(element);
            });
          }
        });
      });
    });
  }

  late List<postModel> postList = [];
  Future getPostList() async {
    FirebaseFirestore.instance
        .collection('posts')
        .where('state', isEqualTo: "show")
        .snapshots()
        .listen((value) {
      setState(() {
        postList.clear();
        value.docs.forEach((element) {
          postList.add(postModel.fromDocument(element.data()));
        });
      });
    });
  }

  List<userModel> userList = [];

  Future getAllUser() async {
    FirebaseFirestore.instance.collection("users").get().then((value) {
      setState(() {
        userList.clear();
        value.docs.forEach((element) {
          userList.add(userModel.fromDocument(element.data()));
        });
        userList.forEach((element) {
          print(element.id);
          if (element.id == uid) {
            setState(() {
              userList.remove(element);
            });
          }
        });
        print(userList);
      });
    });
    setState(() {});
  }

  File? imageFile;
  String link = '';

  late String urlImage = '';

  @override
  void initState() {
    getPostList();
    getAllUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        child: Scaffold(
            body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              color: white,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 32, right: 16, left: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Form(
                          // key: formKey,
                          child: Container(
                            width: 327,
                            height: 40,
                            padding: EdgeInsets.only(left: 2, right: 24),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: white,
                                border: Border.all(color: gray)),
                            alignment: Alignment.topCenter,
                            child: TextFormField(
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14,
                                    color: black,
                                    fontWeight: FontWeight.w400),
                                controller: searchController,
                                keyboardType: TextInputType.text,
                                onChanged: (val) {
                                  search = val;
                                  searchCaption();
                                  searchName();
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Container(
                                      child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                        Icon(Iconsax.search_normal_1,
                                            size: 20, color: black)
                                      ])),
                                  border: InputBorder.none,
                                  hintText: "What are you looking for?",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      color: black,
                                      fontWeight: FontWeight.w400),
                                )),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => atClassifyImageScreen(
                                          uid: uid,
                                        )));
                          },
                          child: Icon(Iconsax.scan, size: 24, color: black)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Post',
                      style: TextStyle(
                          fontFamily: 'Recoleta',
                          fontSize: 24,
                          color: black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                      width: 327 + 24,
                      padding: EdgeInsets.only(bottom: 8),
                      // height: 400,
                      child: GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemCount: postList.length,
                        // userList.length.clamp(0, 3),
                        itemBuilder: (context, index) {
                          // (postList.length == 0)
                          //     ? Container()
                          //     :
                          return (postList[index].urlImage != '')
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                postNotification(context,
                                                    uid: uid,
                                                    postId:
                                                        postList[index].id))));
                                  },
                                  child: Container(
                                    child: ImageWidget(
                                      src: postList[index].urlImage,
                                      postId: postList[index].id,
                                      uid: uid,
                                      position: index.toString(),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                postNotification(context,
                                                    uid: uid,
                                                    postId:
                                                        postList[index].id))));
                                  },
                                  child: Container(
                                    child: VideoWidget(
                                      src: postList[index].urlVideo,
                                      postId: postList[index].id,
                                      uid: uid,
                                      position: index.toString(),
                                    ),
                                  ),
                                );
                        },
                      )),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'User',
                      style: TextStyle(
                          fontFamily: 'Recoleta',
                          fontSize: 24,
                          color: black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Container(
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.only(top: 8),
                              shrinkWrap: true,
                              itemCount: userList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    width: 327 + 24,
                                    margin: EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(color: gray),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    atProfileScreen(
                                                      context,
                                                      ownerId:
                                                          userList[index].id,
                                                    ))));
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            margin: EdgeInsets.only(
                                                left: 16, bottom: 16, top: 16),
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      // userList[index]
                                                      //     .avatar
                                                      (userList[index].avatar !=
                                                              '')
                                                          ? userList[index]
                                                              .avatar
                                                          : 'https://i.imgur.com/RUgPziD.jpg'),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            width: 183 + 24,
                                            margin: EdgeInsets.only(left: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userList[index].userName,
                                                  style: TextStyle(
                                                    color: black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  userList[index].email,
                                                  style: TextStyle(
                                                    color: gray,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              }),
                        )),
                  )
                ],
              ),
            ),
            margin: EdgeInsets.only(bottom: 32 + 24),
          )
        ])));
  }
}
