import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferce_app/views/authentication/storage_method.dart';
import 'package:ferce_app/views/widget/snackBarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class CloudStoreDataManagement {
  final _collectionName = 'users';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkThisUserAlreadyPresentOrNot(
      {required String userName}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> findResults =
          await FirebaseFirestore.instance
              .collection(_collectionName)
              .where('user_name', isEqualTo: userName)
              .get();

      print('Debug 1: ${findResults.docs.isEmpty}');

      return findResults.docs.isEmpty ? true : false;
    } catch (e) {
      print(
          'Error in Checkj This User Already Present or not: ${e.toString()}');
      return false;
    }
  }

  Future<bool> registerNewUser(
      {required String userName,
      required String fullname,
      required File file,
      required String bio,
      required String phone,
      context}) async {
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);
      final String userEmail =
          FirebaseAuth.instance.currentUser!.email.toString();

      await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
        'avatar': photoUrl,
        'background': 'https://i.imgur.com/RUgPziD.jpg',
        'email': userEmail,
        'favoriteList': [],
        'fullName': fullname,
        'phonenumber': phone,
        'saveList': [],
        'state': '',
        'userId': _auth.currentUser!.uid,
        'userName': userName,
        'role': bio,
        'gender': '',
        'follow': [],
        'dob': ''
      });
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          showSnackBar(context, "Anonymous accounts are not enabled!", 'error');
          break;
        case "weak-password":
          showSnackBar(context, "Your password is too weak!", 'error');
          break;
        case "invalid-email":
          showSnackBar(
              context, "Your email is invalid, please check!", 'error');
          break;
        case "email-already-in-use":
          showSnackBar(context, "Email is used on different account!", 'error');
          break;
        case "invalid-credential":
          showSnackBar(
              context, "Your email is invalid, please check!", 'error');
          break;

        default:
          showSnackBar(context, "An undefined Error happened.", 'error');
      }
      return false;
    }
  }

  Future<bool> userRecordPresentOrNot({required String email}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .doc('${this._collectionName}/$email')
              .get();
      return documentSnapshot.exists;
    } catch (e) {
      print('Error in user Record Present or not: ${e.toString()}');
      return false;
    }
  }
}
