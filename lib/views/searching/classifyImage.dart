import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferce_app/constants/colors.dart';
import 'package:ferce_app/models/postModel.dart';
import 'package:ferce_app/models/userModel.dart';
import 'package:ferce_app/views/notification/postNotification.dart';
import 'package:ferce_app/views/profile/image.dart';
import 'package:ferce_app/views/profile/video.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:intl/intl.dart';

import 'package:tflite/tflite.dart';

class atClassifyImageScreen extends StatefulWidget {
  String uid;
  atClassifyImageScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _atClassifyImageScreen createState() => _atClassifyImageScreen(this.uid);
}

class _atClassifyImageScreen extends State<atClassifyImageScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  _atClassifyImageScreen(this.uid);
  String imageFile = '';
  String link = '';

  TextEditingController captionController = TextEditingController();
  final GlobalKey<FormState> captionFormKey = GlobalKey<FormState>();

  List<postModel> postList = [];
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
          print((element.caption
                  .toUpperCase()
                  .contains(search.toUpperCase().trim())) ==
              true);
          if (((element.caption + " ")
                  .toUpperCase()
                  .contains(search.toUpperCase().trim())) ==
              true) {
            postList.add(element);
            print(postList.length);
          }
        });
      });
    });
  }

  List<userModel> userSearch = [];
  List<userModel> userList = [];
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

  handleTakePhoto() async {
    Navigator.pop(context);
  }

  String search = '';
  String resultError = '';

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
            model: "assets/model.tflite", labels: "assets/labels.txt")
        .onError((error, stackTrace) {
      resultError = 'PLease choose another image';
      return null;
    }))!;

    print("Models loading status: $res");
  }

  List _results = [];
  Future handleTakeGallery() async {
    Navigator.pop(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowCompression: false,
    );
    print('result');
    print(result);
    if (result != null) {
      // Upload file
      print(result.files.first.name);
      print(result.files.first.path);
      if (result.files.first.path != null) {
        print(result.files.first.path.toString());
        final List? recognitions = await Tflite.runModelOnImage(
          path: result.files.first.path.toString(),
          numResults: 1,
          threshold: 0.05,
          imageMean: 127.5,
          imageStd: 127.5,
        );
        setState(() {
          imageFile = result.files.first.path.toString();
          _results = recognitions!;
        });
      }
    }
  }

  selectImage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Choose Resource",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: black),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Photo with Camera",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text(
                  "Photo with Gallery",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                onPressed: handleTakeGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    loadModel();
  }

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
            color: white,
          ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Container(
                      margin:
                          EdgeInsets.only(left: 24, right: 24, top: 20 + 20),
                      child: Column(children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Iconsax.back_square, size: 28),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                searchName();
                                searchCaption();
                              },
                              child: Icon(Iconsax.search_favorite, size: 28),
                            )
                          ],
                        ),
                        SizedBox(height: 24),
                        Container(
                            // margin: EdgeInsets.only(
                            //     left: 24, right: 24, top: 20 + 20),
                            child: Column(children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Classify',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: black),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 192,
                              height: 0.5,
                              decoration: BoxDecoration(
                                color: gray,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 144,
                              height: 0.5,
                              decoration: BoxDecoration(
                                color: gray,
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              (imageFile != '')
                                  ? GestureDetector(
                                      onTap: () {
                                        selectImage(context);
                                      },
                                      child: Container(
                                        width: 360,
                                        height: 340,
                                        padding: EdgeInsets.only(
                                            top: 24, bottom: 16),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.file(
                                            File(imageFile),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(24),
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: gray, width: 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: Colors.transparent),
                                        child: IconButton(
                                            icon: Icon(Iconsax.add,
                                                size: 30, color: gray),
                                            onPressed: () =>
                                                selectImage(context)),
                                      ),
                                    )
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Classify: ',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 16),
                          (_results.isEmpty)
                              ? Container()
                              : SingleChildScrollView(
                                  child: Column(
                                    children: _results.map((result) {
                                      setState(() {
                                        search = "${result['label']} ";
                                      });
                                      return Card(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text("${result['label']} ",
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  color: black,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                          SizedBox(height: 24),
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
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
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
                                      ? Container(
                                          child: ImageWidget(
                                            src: postList[index].urlImage,
                                            postId: postList[index].id,
                                            uid: uid,
                                            position: index.toString(),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        postNotification(
                                                            context,
                                                            uid: uid,
                                                            postId:
                                                                postList[index]
                                                                    .id))));
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
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                                child: Container(
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                                print('tap');
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 44,
                                                    height: 44,
                                                    margin: EdgeInsets.only(
                                                        left: 16,
                                                        bottom: 16,
                                                        top: 16),
                                                    decoration:
                                                        new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              // userList[index]
                                                              //     .avatar
                                                              (userList[index]
                                                                          .avatar !=
                                                                      '')
                                                                  ? userList[
                                                                          index]
                                                                      .avatar
                                                                  : 'https://i.imgur.com/RUgPziD.jpg'),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 183 + 24,
                                                    margin: EdgeInsets.only(
                                                        left: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          userList[index]
                                                              .userName,
                                                          style: TextStyle(
                                                            color: black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          userList[index].email,
                                                          style: TextStyle(
                                                            color: gray,
                                                            fontWeight:
                                                                FontWeight.w400,
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
                        ]))
                      ]))))
        ])));
  }
}
