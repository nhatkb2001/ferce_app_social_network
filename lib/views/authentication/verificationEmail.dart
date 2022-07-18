import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
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

class verificationMailScreen extends StatefulWidget {
  String uid;
  verificationMailScreen({Key? key, required this.uid}) : super(key: key);
  @override
  _verificationMailScreen createState() => _verificationMailScreen(this.uid);
}

class _verificationMailScreen extends State<verificationMailScreen> {
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
  bool _enabledEmail = true;
  bool isSendVerifyCodePhone = false;
  Color notiColorPhoneNumber = red;
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> confirmPasswordFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  TextEditingController newEmailController = TextEditingController();
  final GlobalKey<FormState> newEmailFormKey = GlobalKey<FormState>();

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
        emailController.text = user.email;

        // dobController.text = user.dob;
      });
    });
  }

  bool checkEmail = false;
  bool checkPassword = false;

  Future updatePEmail() async {
    if (checkPassword == true && checkEmail == true) {
      print('dung r ne');
      FirebaseFirestore.instance.collection("users").doc(uid).update({
        'email': newEmailController.text,
      }).then((value) {
        auth.currentUser!.updateEmail(newEmailController.text);
        showSnackBar(context, 'Change email successfully!', 'success');
        Navigator.pop(context);
      });
    } else {
      showSnackBar(context, 'Please check your information!', 'error');
    }
  }

  Future<void> check(currentPassword) async {
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
    if (await myauth.verifyOTP(otp: smsCode) == true) {
      showSnackBar(context, "OTP is verified", 'success');
      setState(() {
        checkEmail = true;
      });
    } else {
      showSnackBar(context, "Invalid OTP", 'error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid OTP"),
      ));
    }
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
        }).then((value) => updatePEmail());
      } on FirebaseAuthException {
        showSnackBar(context, 'Your current password is wrong!', 'error');
      }
    } on FirebaseAuthException {
      showSnackBar(context, 'Your current password is wrong!', 'error');
    }
  }

  late String verificationId;
  Email_OTP myauth = Email_OTP();
  String uid = '';
  _verificationMailScreen(this.uid);

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
                      'Change Mail Number',
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
                      'You need to enter the OTP Code sent to new email and confirm current password!',
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
                            'Current Email',
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
                                    controller: emailController,
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
                                      hintText: "Enter your current email",
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
                        key: newEmailFormKey,
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
                              controller: newEmailController,
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
                                hintText: "Enter your new email",
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
                      (_enabledEmail)
                          ? GestureDetector(
                              onTap: () async {
                                if (newEmailController.text == '') {
                                  showSnackBar(context,
                                      "Please fill your email", 'error');
                                } else {
                                  myauth.setConfig(
                                    appEmail: "binkstore2022@gmail.com",
                                    appName: "Email OTP",
                                    userEmail: newEmailController.text,
                                  );
                                  if (await myauth.sendOTP() == true) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("OTP has been sent"),
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Oops, OTP send failed"),
                                    ));
                                  }
                                  setState(() {
                                    _enabledEmail = false;
                                  });
                                }
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
                                  _enabledEmail = true;
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
                      // changePassword(confirmPasswordController.text, context);
                      check(confirmPasswordController.text);
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
