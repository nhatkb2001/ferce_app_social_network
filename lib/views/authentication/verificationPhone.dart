import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferce_app/models/userModel.dart';
import 'package:ferce_app/views/authentication/instructionManual.dart';
import 'package:ferce_app/views/authentication/signIn.dart';
import 'package:ferce_app/views/widget/snackBarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class verificationPhoneScreen extends StatefulWidget {
  String uid;
  verificationPhoneScreen({Key? key, required this.uid}) : super(key: key);
  @override
  _verificationPhoneScreen createState() => _verificationPhoneScreen(this.uid);
}

class _verificationPhoneScreen extends State<verificationPhoneScreen> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  String smsCode = '';
  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  bool _enabledPhone = true;
  bool isSendVerifyCodePhone = false;
  Color notiColorPhoneNumber = red;

  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> phoneNumberFormKey = GlobalKey<FormState>();

  TextEditingController newPhoneNumberController = TextEditingController();
  final GlobalKey<FormState> newPhoneNumberFormKey = GlobalKey<FormState>();

  TextEditingController phoneVerificationController = TextEditingController();
  final GlobalKey<FormState> phoneVerificationFormKey = GlobalKey<FormState>();

  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> confirmPasswordFormKey = GlobalKey<FormState>();

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
        phoneNumberController.text = user.phoneNumber;

        // dobController.text = user.dob;
      });
    });
  }

  late String verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  _verificationPhoneScreen(this.uid);

  Future sendOtpPhone() async {
    await auth.verifyPhoneNumber(
      phoneNumber: newPhoneNumberController.text,
      verificationCompleted: (phoneAuthCredential) async {},
      verificationFailed: (verificationFailed) async {
        showSnackBar(context, verificationFailed.message, 'error');
      },
      codeSent: (verificationId, respendingToken) async {
        setState(() {
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  bool checkPhone = false;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        setState(() {
          checkPhone = true;
        });
      }
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message, 'error');
    }
  }

  bool checkPassword = false;

  Future updatePhone() async {
    if (checkPassword == true && checkPhone == true) {
      print('dung r ne');
      FirebaseFirestore.instance.collection("users").doc(uid).update({
        'phonenumber': newPhoneNumberController.text,
      }).then((value) =>
          showSnackBar(context, 'Change Phone successfully!', 'success'));
    } else {
      showSnackBar(context, 'Please check your information!', 'error');
    }
  }

  Future<void> changePassword(currentPassword, context) async {
    setState(() {
      smsCode = _fieldOne.text +
          _fieldTwo.text +
          _fieldThree.text +
          _fieldFour.text +
          _fieldFive.text +
          _fieldSix.text;
    });
    print(smsCode);
    print(currentPassword);
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    signInWithPhoneAuthCredential(phoneAuthCredential);
    final user = FirebaseAuth.instance.currentUser!;
    try {
      try {
        await user
            .reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: (user.email).toString(),
            password: currentPassword,
          ),
        )
            .then((value) {
          setState(() {
            checkPassword = true;
          });
        }).then((value) => updatePhone());
      } on FirebaseAuthException {
        showSnackBar(context, 'Your current password is wrong!', 'error');
      }
    } on FirebaseAuthException {
      showSnackBar(context, 'Your current password is wrong!', 'error');
    }
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
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(otpCodeEmailBackground), fit: BoxFit.cover),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        alignment: Alignment.topLeft,
                        child:
                            Icon(Iconsax.back_square, size: 28, color: black)),
                  ),
                  SizedBox(height: 32 + 44 - 28),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Change Phone Number',
                      style: TextStyle(
                          fontFamily: 'Recoleta',
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: black),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 327 + 24,
                    child: Text(
                      'You need to enter the OTP Code sent to new phone number and confirm current password!',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: black),
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    alignment: Alignment.topLeft,
                    width: 327 + 24,
                    child: Column(
                      children: [
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
                                width: 327 + 24 - 6,
                                height: 44,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: gray,
                                      width: 1,
                                    ),
                                    color: gray),
                                alignment: Alignment.topLeft,
                                child: TextFormField(
                                    readOnly: true,
                                    style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        color: white,
                                        fontWeight: FontWeight.w400),
                                    controller: phoneNumberController,
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: [AutofillHints.email],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 20, right: 12),
                                      hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: white.withOpacity(0.5)),
                                      hintText:
                                          "Enter your current phone number",
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Form(
                        key: newPhoneNumberFormKey,
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
                          alignment: Alignment.topLeft,
                          child: TextFormField(
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w400),
                              validator: (phoneNumber) {},
                              controller: newPhoneNumberController,
                              autofillHints: [AutofillHints.telephoneNumber],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 20, right: 12),
                                hintStyle: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: black.withOpacity(0.5)),
                                hintText: "Enter your new phone number",
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
                      SizedBox(width: 8),
                      (_enabledPhone)
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _enabledPhone = false;
                                  isSendVerifyCodePhone =
                                      !isSendVerifyCodePhone;
                                  sendOtpPhone();
                                });
                              },
                              child: Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                    color: black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Icon(
                                  Iconsax.scan,
                                  size: 20,
                                  color: white,
                                ),
                              ))
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _enabledPhone = true;
                                });
                              },
                              child: Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Icon(
                                  Iconsax.repeat,
                                  size: 20,
                                  color: black,
                                ),
                              ))
                    ],
                  ),
                  SizedBox(height: 40),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Enter OTP Code',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 18,
                          color: black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 19),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OtpInput(_fieldOne, true),
                      OtpInput(_fieldTwo, false),
                      OtpInput(_fieldThree, false),
                      OtpInput(_fieldFour, false),
                      OtpInput(_fieldFive, false),
                      OtpInput(_fieldSix, false)
                    ],
                  ),
                  SizedBox(height: 48),
                  Container(
                    alignment: Alignment.topLeft,
                    width: 327 + 24,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Confirm with Your Password',
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
                              key: confirmPasswordFormKey,
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
                                alignment: Alignment.topLeft,
                                child: TextFormField(
                                    style: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        color: black,
                                        fontWeight: FontWeight.w400),
                                    controller: confirmPasswordController,
                                    obscureText: isHiddenConfirmPassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    autofillHints: [AutofillHints.password],
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 20, right: 12),
                                      hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: black.withOpacity(0.5)),
                                      hintText: "Confirm with Your Password",
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
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isHiddenConfirmPassword =
                                      !isHiddenConfirmPassword;
                                });
                              },
                              child: (isHiddenConfirmPassword)
                                  ? Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                          color: black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Icon(
                                        Iconsax.eye,
                                        size: 20,
                                        color: white,
                                      ),
                                    )
                                  : Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border:
                                              Border.all(color: gray, width: 1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Icon(
                                        Iconsax.eye_slash,
                                        size: 24,
                                        color: black,
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      changePassword(confirmPasswordController.text, context);
                    },
                    child: Container(
                      width: 327 + 24,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: black,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Change",
                          style: TextStyle(
                            color: white,
                            fontFamily: 'Urbanist',
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 327 + 24,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.transparent,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Urbanist',
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: gray, width: 1)),
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        style: TextStyle(
            color: black,
            fontSize: 18,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w500),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
