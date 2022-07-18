import 'package:ferce_app/constants/colors.dart';
import 'package:ferce_app/views/authentication/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';

Widget EmailTextFormField(
    {required String hintText,
    required TextEditingController textEditingController,
    required Size size,
    required String? Function(String?)? validator,
    required double padding}) {
  return Container(
    margin: EdgeInsets.only(left: 32, right: 32),
    width: size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: white,
    ),
    child: TextFormField(
      cursorColor: gray,
      controller: textEditingController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
      validator: validator,
      // decoration: InputDecoration(
      //   hintText: hintText,
      //   hintStyle: TextStyle(color: gray),
      //   border: InputBorder.none,
      // ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 8, right: 8),
        hintStyle: TextStyle(
          color: gray,
          fontFamily: 'Urbanist',
          fontSize: 20,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
        ),
        hintText: "Enter your Email",
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorStyle: TextStyle(
          color: Colors.transparent,
          fontSize: 0,
          height: 0,
        ),
      ),
    ),
  );
}

Widget PasswordTextFormField({
  required BuildContext context,
  required String hintText,
  required String? Function(String?)? validator,
  required TextEditingController textEditingController,
  required Size size,
  required bool isHiddenPassword,
}) {
  return Container(
    margin: EdgeInsets.only(left: 32, right: 32),
    width: size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: white,
    ),
    child: TextFormField(
      validator: validator,
      cursorColor: gray,
      controller: textEditingController,
      obscureText: isHiddenPassword,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: [AutofillHints.password],
      decoration: InputDecoration(
        suffixIcon: InkWell(
            onTap: () {
              isHiddenPassword = !isHiddenPassword;
            },
            child: isHiddenPassword
                ? Stack(alignment: Alignment.centerRight, children: [
                    Container(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Iconsax.eye, size: 24, color: gray))
                  ])
                : Stack(alignment: Alignment.centerRight, children: [
                    Container(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Iconsax.eye_slash, size: 24, color: gray))
                  ])),
        contentPadding: EdgeInsets.only(left: 8, right: 8),
        hintStyle: TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: gray,
        ),
        hintText: "Enter your Password",
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorStyle: TextStyle(
          color: Colors.transparent,
          fontSize: 0,
          height: 0,
        ),
      ),
    ),
  );
}

Widget switchAnotherAuthScreen(
    BuildContext context, String buttonNameFirst, String buttonNameLast) {
  return GestureDetector(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          buttonNameFirst,
          style: TextStyle(
            color: white,
            fontSize: 16.0,
          ),
        ),
        Text(
          buttonNameLast,
          style: TextStyle(
            color: red,
            fontFamily: 'Urbanist',
            fontSize: 20,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
    onTap: () {
      if (buttonNameLast == "Sign up for free")
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => signUpScreen()),
        );
      else
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => signUpScreen()),
        );
    },
  );
}

Widget RecoveryTextFormField(
    {required String hintText,
    required String? Function(String?)? validator,
    required TextEditingController textEditingController,
    required Size size}) {
  return Container(
    margin: EdgeInsets.only(left: 16, right: 16),
    width: size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: gray,
    ),
    child: TextFormField(
      validator: validator,
      cursorColor: white,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: white),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget InfomationTextFormField({
  required String hintText,
  required TextEditingController textEditingController,
  required Size size,
  required String? Function(String?)? validator,
}) {
  return Container(
    margin: EdgeInsets.only(left: 15, right: 15),
    width: size.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        border: Border.all(color: black)),
    child: TextFormField(
      cursorColor: white,
      controller: textEditingController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
      validator: validator,
      // decoration: InputDecoration(
      //   hintText: hintText,
      //   hintStyle: TextStyle(color: gray),
      //   border: InputBorder.none,
      // ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 8, right: 8),
        hintStyle: TextStyle(
          color: black,
          fontFamily: 'Urbanist',
          fontSize: 16,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
        hintText: hintText,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorStyle: TextStyle(
          color: Colors.transparent,
          fontSize: 0,
          height: 0,
        ),
      ),
    ),
  );
}
