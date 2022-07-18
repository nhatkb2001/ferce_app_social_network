import 'dart:io';
import 'dart:io';

import 'package:ferce_app/constants/colors.dart';
import 'package:ferce_app/constants/images.dart';
import 'package:ferce_app/views/authentication/cloud_data_management.dart';
import 'package:ferce_app/views/authentication/loadingWidget.dart';
import 'package:ferce_app/views/authentication/signIn.dart';
import 'package:ferce_app/views/authentication/widgetAuth.dart';
import 'package:ferce_app/views/widget/snackBarWidget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:typed_data';

class InformationScreen extends StatefulWidget {
  InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _infoKey = GlobalKey<FormState>();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  File? _image;
  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();

  @override
  void dispose() {
    super.dispose();
    _fullname.dispose();
    _username.dispose();
    _phone.dispose();
    _bio.dispose();
  }

  pickImage(ImageSource source) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: false,
    );
    print('result');
    print(result);
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      return File(result.files.first.path.toString());
    }
    print('No Image Selected');
  }

  selectImage() async {
    File im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _infoKey,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/background/signInBackground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: _isLoading
                ? LoadingWidget()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 62,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Update Your Profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: black,
                              fontFamily: 'Recoleta',
                              fontSize: 24,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      GestureDetector(
                        onTap: selectImage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Row(
                                children: [
                                  _image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.file(
                                            _image!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(color: black),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Iconsax.camera,
                                                size: 24,
                                                color: black,
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          "Full Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InfomationTextFormField(
                        textEditingController: _fullname,
                        hintText: '  Enter your full name',
                        size: size,
                        validator: (inputVal) {
                          if (inputVal!.isEmpty) {
                            showSnackBar(
                                context,
                                'Password must be at least 6 characters',
                                'error');
                            return '';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          "User Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InfomationTextFormField(
                        textEditingController: _username,
                        hintText: '  Enter your user name',
                        size: size,
                        validator: (inputVal) {
                          if (inputVal!.isEmpty) {
                            showSnackBar(
                                context,
                                'Password must be at least 6 characters',
                                'error');
                            return '';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          "Phone number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InfomationTextFormField(
                        textEditingController: _phone,
                        hintText: '  Enter your phone number',
                        size: size,
                        validator: (inputVal) {
                          if (inputVal!.isEmpty) {
                            showSnackBar(
                                context,
                                'Password must be at least 10 characters',
                                'error');
                            return '';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          "Biography",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InfomationTextFormField(
                        textEditingController: _bio,
                        hintText: '  Enter your biography',
                        size: size,
                        validator: (inputVal) {
                          if (inputVal!.isEmpty) {
                            showSnackBar(
                                context,
                                'Password must be at least 10 characters',
                                'error');
                            return '';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ConFirmButton(context, 'Confirm', size),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget ConFirmButton(BuildContext context, String buttonName, Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 122, right: 122),
      child: GestureDetector(
        onTap: () async {
          if (this._infoKey.currentState!.validate()) {
            print('Validated');
            SystemChannels.textInput.invokeMethod('TextInput.hide');

            if (mounted) {
              setState(() {
                this._isLoading = true;
              });
            }

            String msg = '';

            final bool canRegisterNewUser = await _cloudStoreDataManagement
                .checkThisUserAlreadyPresentOrNot(
                    userName: this._username.text);

            if (!canRegisterNewUser)
              msg = 'User Name Already Present';
            else {
              final bool _userEntryResponse =
                  await _cloudStoreDataManagement.registerNewUser(
                fullname: this._fullname.text,
                userName: this._username.text,
                phone: this._phone.text,
                bio: this._bio.text,
                file: _image!,
              );

              if (_userEntryResponse) {
                msg = 'Create account Successfully';

                /// Calling Local Databases Methods To Intitialize Local Database with required MEthods
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => signInScreen(),
                    ),
                    (route) => false);
                showSnackBar(context, msg, 'success');
              } else
                msg = 'User Data Not Entry Successfully';
              showSnackBar(context, msg, 'error');
            }

            if (mounted) {
              setState(() {
                this._isLoading = true;
              });
            }
          } else {
            print('Not Validated');
          }
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
              buttonName,
              style: TextStyle(
                color: white,
                fontFamily: 'Urbanist',
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
