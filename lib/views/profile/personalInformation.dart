import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferce_app/constants/images.dart';
import 'package:ferce_app/models/userModel.dart';
import 'package:ferce_app/views/authentication/verificationEmail.dart';
import 'package:ferce_app/views/authentication/verificationPhone.dart';
import 'package:ferce_app/views/widget/dialogWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

//import others
import 'package:meta/meta.dart';

///add constants
import 'package:ferce_app/constants/colors.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class atPersonalInformationScreen extends StatefulWidget {
  String uid;
  atPersonalInformationScreen(required, {Key? key, required this.uid})
      : super(key: key);

  @override
  _atPersonalInformationScreen createState() =>
      _atPersonalInformationScreen(uid);
}

class _atPersonalInformationScreen extends State<atPersonalInformationScreen> {
  String uid = '';
  _atPersonalInformationScreen(this.uid);

  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> usernameFormKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> phoneNumberFormKey = GlobalKey<FormState>();

  TextEditingController genderController = TextEditingController();
  final GlobalKey<FormState> genderFormKey = GlobalKey<FormState>();

  TextEditingController dayController = TextEditingController();
  final GlobalKey<FormState> dayFormKey = GlobalKey<FormState>();

  TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> bioFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  Color notiColorEmail = red;
  Color notiColorPassword = red;

  late userModel user = userModel(
      avatar: '',
      background: '',
      email: '',
      favoriteList: [],
      fullName: '',
      id: '',
      phoneNumber: '',
      saveList: [],
      state: '',
      userName: '',
      follow: [],
      role: '',
      gender: '',
      dob: '');

  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .listen((value) {
      setState(() {
        user = userModel.fromDocument(value.docs.first.data());
        print(user.userName);
        usernameController.text = user.userName;
        emailController.text = user.email;
        phoneNumberController.text = user.phoneNumber;
        genderController.text = user.gender;
        bioController.text = user.role;
        dayController.text = user.dob;
        // dobController.text = user.dob;
      });
    });
  }

  Future editProfile() async {
    FirebaseFirestore.instance.collection("users").doc(uid).update({
      'userName': usernameController.text,
      'gender': genderController.text,
      'role': bioController.text,
      'dob': dayController.text,
    }).then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    getUserDetail();
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
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(profileBackground), fit: BoxFit.cover),
              ),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Container(
                      margin: EdgeInsets.only(left: 24, right: 24, top: 20),
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Iconsax.back_square,
                                      size: 28, color: black),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    print('more');
                                  },
                                  child: Icon(Iconsax.menu_1,
                                      size: 28, color: black),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Personal Information',
                              style: TextStyle(
                                  fontFamily: 'Recoleta',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: black),
                            ),
                          ),
                          SizedBox(height: 16),
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
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Username',
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 8),
                          Form(
                            key: usernameFormKey,
                            child: Container(
                              width: 327 + 24,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: gray,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 16,
                                      color: black,
                                      fontWeight: FontWeight.w400),
                                  //validator
                                  validator: (email) {
                                    // if (isEmailValid(email.toString())) {
                                    //   WidgetsBinding.instance!
                                    //       .addPostFrameCallback((_) {
                                    //     setState(() {
                                    //       notiColorEmail = green;
                                    //     });
                                    //   });
                                    //   return null;
                                    // } else {
                                    //   WidgetsBinding.instance!
                                    //       .addPostFrameCallback((_) {
                                    //     setState(() {
                                    //       notiColorEmail = red;
                                    //     });
                                    //   });
                                    //   return '';
                                    // }
                                  },
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 20, right: 12),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.5)),
                                    hintText: "Enter your username",
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorStyle: TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 0,
                                      height: 0,
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(height: 24),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Form(
                                key: emailFormKey,
                                child: Container(
                                  width: 275 + 16,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: gray,
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.topCenter,
                                  child: TextFormField(
                                      readOnly: true,
                                      style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          color: black,
                                          fontWeight: FontWeight.w400),
                                      //validator
                                      validator: (email) {
                                        // if (isEmailValid(email.toString())) {
                                        //   WidgetsBinding.instance!
                                        //       .addPostFrameCallback((_) {
                                        //     setState(() {
                                        //       notiColorEmail = green;
                                        //     });
                                        //   });
                                        //   return null;
                                        // } else {
                                        //   WidgetsBinding.instance!
                                        //       .addPostFrameCallback((_) {
                                        //     setState(() {
                                        //       notiColorEmail = red;
                                        //     });
                                        //   });
                                        //   return '';
                                        // }
                                      },
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofillHints: [AutofillHints.email],
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 20, right: 12),
                                        hintStyle: TextStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: black.withOpacity(0.5)),
                                        hintText: "Enter your email",
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                        ),
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                verificationMailScreen(
                                                  uid: uid,
                                                )));
                                  },
                                  child: Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                        color: black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Icon(
                                      Iconsax.cloud_change,
                                      size: 20,
                                      color: white,
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(height: 24),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Phone Number',
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Form(
                                key: phoneNumberFormKey,
                                child: Container(
                                  width: 275 + 16,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: gray,
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.topCenter,
                                  child: TextFormField(
                                      readOnly: true,
                                      style: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          color: black,
                                          fontWeight: FontWeight.w400),
                                      //validator
                                      validator: (email) {
                                        // if (isEmailValid(email.toString())) {
                                        //   WidgetsBinding.instance!
                                        //       .addPostFrameCallback((_) {
                                        //     setState(() {
                                        //       notiColorEmail = green;
                                        //     });
                                        //   });
                                        //   return null;
                                        // } else {
                                        //   WidgetsBinding.instance!
                                        //       .addPostFrameCallback((_) {
                                        //     setState(() {
                                        //       notiColorEmail = red;
                                        //     });
                                        //   });
                                        //   return '';
                                        // }
                                      },
                                      controller: phoneNumberController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofillHints: [AutofillHints.email],
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 20, right: 12),
                                        hintStyle: TextStyle(
                                            fontFamily: 'Urbanist',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: black.withOpacity(0.5)),
                                        hintText: "Enter your phone number",
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 0,
                                          height: 0,
                                        ),
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                verificationPhoneScreen(
                                                    uid: uid)));
                                  },
                                  child: Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                        color: black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Icon(
                                      Iconsax.cloud_change,
                                      size: 20,
                                      color: white,
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(height: 24),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Gender',
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 8),
                          Form(
                            key: genderFormKey,
                            child: Container(
                              width: 327 + 24,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: gray,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 16,
                                      color: black,
                                      fontWeight: FontWeight.w400),
                                  //validator
                                  validator: (email) {
                                    // if (isEmailValid(email.toString())) {
                                    //   WidgetsBinding.instance!
                                    //       .addPostFrameCallback((_) {
                                    //     setState(() {
                                    //       notiColorEmail = green;
                                    //     });
                                    //   });
                                    //   return null;
                                    // } else {
                                    //   WidgetsBinding.instance!
                                    //       .addPostFrameCallback((_) {
                                    //     setState(() {
                                    //       notiColorEmail = red;
                                    //     });
                                    //   });
                                    //   return '';
                                    // }
                                  },
                                  controller: genderController,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: [AutofillHints.email],
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 20, right: 12),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        genderDialog(
                                                context, genderController.text)
                                            .then((value) {
                                          genderController.text = value;
                                        });
                                        print(genderController.text);
                                      },
                                      child: Icon(
                                        Iconsax.export_3,
                                        color: black,
                                        size: 24,
                                      ),
                                    ),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.5)),
                                    hintText: "Enter your gender",
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorStyle: TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 0,
                                      height: 0,
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(height: 24),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Date of Birth',
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 8),
                          Form(
                            child: Container(
                              width: 327 + 24,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: gray,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                  controller: dayController,
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 16,
                                      color: black,
                                      fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 20, right: 12),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        datePickerDialog(
                                                context, DateTime.now(), 'dob')
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              dayController.text =
                                                  "${DateFormat('yMMMMd').format(value)}";
                                              print(dayController.text);
                                            });
                                          }
                                        });
                                      },
                                      child: Icon(Iconsax.calendar_1,
                                          size: 24, color: black),
                                    ),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.5)),
                                    hintText: "Enter your birthday",
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorStyle: TextStyle(
                                      color: black,
                                      fontSize: 0,
                                      height: 0,
                                    ),
                                  )),
                            ),
                          ),

                          SizedBox(height: 24),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Biography',
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 8),
                          Form(
                            key: bioFormKey,
                            child: Container(
                              width: 327 + 24,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: gray,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 16,
                                      color: black,
                                      fontWeight: FontWeight.w400),
                                  //validator
                                  validator: (email) {
                                    // if (isEmailValid(email.toString())) {
                                    //   WidgetsBinding.instance!
                                    //       .addPostFrameCallback((_) {
                                    //     setState(() {
                                    //       notiColorEmail = green;
                                    //     });
                                    //   });
                                    //   return null;
                                    // } else {
                                    //   WidgetsBinding.instance!
                                    //       .addPostFrameCallback((_) {
                                    //     setState(() {
                                    //       notiColorEmail = red;
                                    //     });
                                    //   });
                                    //   return '';
                                    // }
                                  },
                                  controller: bioController,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: [AutofillHints.email],
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 20, right: 12),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.5)),
                                    hintText: "Enter your biography",
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorStyle: TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 0,
                                      height: 0,
                                    ),
                                  )),
                            ),
                          ),
                          Container(
                            width: 327 + 24,
                            height: 44,
                            margin: EdgeInsets.only(top: 32),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: black,
                            ),
                            child: ElevatedButton(
                              //action navigate to dashboard screen
                              onPressed: () async {
                                if (isLoading) return;
                                setState(() {
                                  editProfile();
                                });
                                await Future.delayed(Duration(seconds: 3));
                                if (this.mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: black,
                                  onPrimary: Colors.white,
                                  shadowColor: black.withOpacity(0.25),
                                  elevation: 15,
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  // maximumSize: Size.fromWidth(200),
                                  minimumSize: Size(327 + 24, 44),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(16.0)),
                                  // BorderRadius.all(Radius.circular(16)),
                                  textStyle: TextStyle(
                                      color: white,
                                      fontFamily: 'SFProText',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18)),
                              child: isLoading
                                  ? Container(
                                      height: 48,
                                      width: 200,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                  color: white)),
                                          const SizedBox(width: 16),
                                          Text(
                                            "Please Wait...",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w600,
                                              color: white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w600,
                                          color: white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          // Container(
                          //   alignment: Alignment.topLeft,
                          //   child: Text(
                          //     'Address',
                          //     style: TextStyle(
                          //         fontFamily: 'Urbanist',
                          //         fontSize: 16,
                          //         color: black,
                          //         fontWeight: FontWeight.w500),
                          //   ),
                          // ),
                          // SizedBox(height: 8),
                          // Container(
                          //   width: 327 + 24,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Container(
                          //           width: 327 + 24,
                          //           decoration: BoxDecoration(),
                          //           child: ListView.builder(
                          //               physics:
                          //                   const NeverScrollableScrollPhysics(),
                          //               padding: EdgeInsets.only(top: 16),
                          //               scrollDirection: Axis.vertical,
                          //               shrinkWrap: true,
                          //               itemCount: 4,
                          //               itemBuilder: (context, index) {
                          //                 return (index == 0)
                          //                     ? Row(
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment.start,
                          //                         children: [
                          //                           Expanded(
                          //                             flex: 1,
                          //                             child: Container(
                          //                               height: 60,
                          //                               width: 32,
                          //                               decoration: BoxDecoration(
                          //                                   color: gray,
                          //                                   borderRadius: BorderRadius.only(
                          //                                       topLeft: Radius
                          //                                           .circular(
                          //                                               8),
                          //                                       topRight: Radius
                          //                                           .circular(
                          //                                               8))),
                          //                               child: Container(
                          //                                 alignment:
                          //                                     Alignment.center,
                          //                                 child: Text(
                          //                                   '01',
                          //                                   style: TextStyle(
                          //                                       fontFamily:
                          //                                           'Urbanist',
                          //                                       fontSize: 16,
                          //                                       color: white,
                          //                                       fontWeight:
                          //                                           FontWeight
                          //                                               .w500),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           SizedBox(width: 16),
                          //                           Expanded(
                          //                             flex: 7,
                          //                             child: Container(
                          //                               constraints:
                          //                                   BoxConstraints(
                          //                                       maxWidth: 254),
                          //                               decoration:
                          //                                   BoxDecoration(
                          //                                 borderRadius: BorderRadius.only(
                          //                                     topRight: Radius
                          //                                         .circular(
                          //                                             8.0),
                          //                                     bottomRight:
                          //                                         Radius
                          //                                             .circular(
                          //                                                 8.0),
                          //                                     bottomLeft: Radius
                          //                                         .circular(
                          //                                             8.0)),
                          //                                 color: gray,
                          //                               ),
                          //                               child: Container(
                          //                                 padding:
                          //                                     EdgeInsets.only(
                          //                                         top: 12.5,
                          //                                         bottom: 12.5,
                          //                                         left: 16,
                          //                                         right: 16),
                          //                                 alignment:
                          //                                     Alignment.center,
                          //                                 child: Text(
                          //                                   '39 Dong Hoa, Di An, Binh Duong',
                          //                                   textAlign:
                          //                                       TextAlign.left,
                          //                                   style: TextStyle(
                          //                                       fontFamily:
                          //                                           "Urbanist",
                          //                                       fontSize: 16.0,
                          //                                       color: white,
                          //                                       fontWeight:
                          //                                           FontWeight
                          //                                               .w400),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           )
                          //                         ],
                          //                       )
                          //                     : Row(
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment.start,
                          //                         children: [
                          //                           Expanded(
                          //                             flex: 1,
                          //                             child: Container(
                          //                               padding:
                          //                                   EdgeInsets.only(
                          //                                       top: 60),
                          //                               width: 32,
                          //                               decoration:
                          //                                   BoxDecoration(
                          //                                 color: gray,
                          //                                 // borderRadius: BorderRadius.only(
                          //                                 //     topLeft: Radius
                          //                                 //         .circular(
                          //                                 //             8),
                          //                                 //     topRight: Radius
                          //                                 //         .circular(
                          //                                 //             8))
                          //                               ),
                          //                               child: Container(
                          //                                 alignment:
                          //                                     Alignment.center,
                          //                                 child: Text(
                          //                                   '0' +
                          //                                       (index + 1)
                          //                                           .toString(),
                          //                                   style: TextStyle(
                          //                                       fontFamily:
                          //                                           'Urbanist',
                          //                                       fontSize: 16,
                          //                                       color: white,
                          //                                       fontWeight:
                          //                                           FontWeight
                          //                                               .w500),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           SizedBox(width: 16),
                          //                           Expanded(
                          //                             flex: 7,
                          //                             child: Container(
                          //                               margin: EdgeInsets.only(
                          //                                   top: 16),
                          //                               constraints:
                          //                                   BoxConstraints(
                          //                                       maxWidth: 254),
                          //                               decoration:
                          //                                   BoxDecoration(
                          //                                 borderRadius: BorderRadius.only(
                          //                                     topRight: Radius
                          //                                         .circular(
                          //                                             8.0),
                          //                                     bottomRight:
                          //                                         Radius
                          //                                             .circular(
                          //                                                 8.0),
                          //                                     bottomLeft: Radius
                          //                                         .circular(
                          //                                             8.0)),
                          //                                 color: white,
                          //                               ),
                          //                               child: Container(
                          //                                 margin:
                          //                                     EdgeInsets.only(
                          //                                         top: 12.5,
                          //                                         bottom: 12.5,
                          //                                         left: 16,
                          //                                         right: 16),
                          //                                 alignment:
                          //                                     Alignment.center,
                          //                                 child: Text(
                          //                                   '39 Dong Hoa, Di An, Binh Duong',
                          //                                   textAlign:
                          //                                       TextAlign.left,
                          //                                   style: TextStyle(
                          //                                       fontFamily:
                          //                                           "Urbanist",
                          //                                       fontSize: 16.0,
                          //                                       color: black,
                          //                                       fontWeight:
                          //                                           FontWeight
                          //                                               .w400),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           )
                          //                         ],
                          //                       );
                          //               })),
                          // Container(
                          //   height: 70,
                          //   width: 43,
                          //   decoration: BoxDecoration(
                          //       color: gray,
                          //       borderRadius: BorderRadius.only(
                          //           bottomLeft: Radius.circular(8),
                          //           bottomRight: Radius.circular(8))),
                          //   child: Container(
                          //     alignment: Alignment.center,
                          //     child: Icon(Iconsax.gps,
                          //         size: 24, color: white),
                          //   ),
                          // )
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
