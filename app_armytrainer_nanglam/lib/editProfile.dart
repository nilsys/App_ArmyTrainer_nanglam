import 'dart:typed_data';

import 'package:app_armytrainer_nanglam/sqlite/db_helper.dart';
import 'package:app_armytrainer_nanglam/sqlite/models/models.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:image/image.dart' as ImageProcess;
import 'main.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  double _sizeHeight;
  String _profileName;
  String _profileImageBak;
  String base64Image;
  Uint8List _byteImage;
  File image;
  int _profileAge;
  String dropdownValueSex;
  String dropdownValueJob;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final picker = ImagePicker();

  void dialogScreen() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return EDialog();
        });
  }

  Future _imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        final _imageFile = ImageProcess.decodeImage(
          image.readAsBytesSync(),
        );
        base64Image = base64Encode(ImageProcess.encodePng(_imageFile));
        _byteImage = Base64Decoder().convert(base64Image);
      }
    });
  }

  Future _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        final _imageFile = ImageProcess.decodeImage(
          image.readAsBytesSync(),
        );
        base64Image = base64Encode(ImageProcess.encodePng(_imageFile));
        _byteImage = Base64Decoder().convert(base64Image);
      }
    });
  }

  bool _check() {
    if (_nameController.text != '' &&
        _ageController.text != '' &&
        dropdownValueJob != null &&
        dropdownValueSex != null) {
      return true;
    } else {
      return false;
    }
  }

  _saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('profileImage', base64Image);
      prefs.setString('profileName', _nameController.text);
      prefs.setInt('profileAge', int.parse(_ageController.text));
      prefs.setString('profileJob', dropdownValueJob);
      prefs.setString('profileSex', dropdownValueSex);
    });
  }

  _loadValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      base64Image = (prefs.getString('profileImage') ?? null);
      if (base64Image != null) {
        _byteImage = Base64Decoder().convert(base64Image);
      } else {
        _byteImage = null;
      }
      _profileImageBak = (prefs.getString('profileImage') ?? null);
      _profileName = (prefs.getString('profileName') ?? 'Name');
      _profileAge = (prefs.getInt('profileAge') ?? 0);
      dropdownValueJob = (prefs.getString('profileJob') ?? null);
      dropdownValueSex = (prefs.getString('profileSex') ?? null);
      _nameController.text = _profileName;
      _ageController.text = _profileAge.toString();
    });
  }

  _cancleValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('profileImage', _profileImageBak);
    });
  }

  _resetPush() async {
    await DBHelper().deleteAllPushRoutine();
    DBHelper().createPushRoutineData(
        PushRoutine(idx: 0, routine: "1-2-3-4-5", time: 30));
  }

  _resetSit() async {
    await DBHelper().deleteAllSitRoutine();
    DBHelper().createSitRoutineData(
        SitRoutine(idx: 0, routine: "1-2-3-4-5", time: 30));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(
                          fontFamily: 'MainFont',
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(
                      'Camera',
                      style: TextStyle(
                        fontFamily: 'MainFont',
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff191C2B),
      appBar: AppBar(
        backgroundColor: Color(0xff191C2B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              _cancleValue();
              Navigator.pop(context);
            },
            icon: Icon(Icons.clear, color: Colors.redAccent)),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MainFont',
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (_check()) {
                  _saveValue();
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.check, color: Colors.white)),
        ],
      ),
      body: WillPopScope(
        child: ListView(
          children: [
            SizedBox(height: _sizeHeight * 0.045),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                      child: _byteImage == null
                          ? CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage('Images/user.png'),
                              backgroundColor: Color(0xff191C2B),
                            )
                          : CircleAvatar(
                              radius: 40,
                              backgroundImage: MemoryImage(_byteImage),
                              backgroundColor: Color(0xff191C2B),
                            ),
                    ),
                    Positioned(
                      bottom: -13,
                      right: -13,
                      child: IconButton(
                        onPressed: () {
                          _showPicker(context);
                        },
                        icon: Icon(Icons.cached, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: _sizeHeight * 0.045),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: '$_profileName',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: 'MainFont',
                        fontSize: 18,
                      ),
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 24,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MainFont',
                      fontSize: 22,
                    ),
                    cursorColor: Colors.white,
                    onChanged: ((value) {
                      setState(() {
                        _profileName = value;
                      });
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    controller: _ageController,
                    decoration: InputDecoration(
                      hintText: '20',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: 'MainFont',
                        fontSize: 18,
                      ),
                      labelText: '나이',
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 24,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MainFont',
                      fontSize: 18,
                    ),
                    cursorColor: Colors.white,
                    onChanged: ((value) {
                      setState(() {});
                    }),
                  ),
                ),
                SizedBox(
                  height: _sizeHeight * 0.045,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '성별:',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'MainFont',
                              fontSize: 24,
                            ),
                          ),
                          DropdownButton<String>(
                            value: dropdownValueSex,
                            underline: Container(
                              height: 1,
                              color: Colors.white,
                            ),
                            dropdownColor: Color(0xff191C2B),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Colors.white),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'MainFont',
                              fontSize: 24,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValueSex = newValue;
                              });
                            },
                            items: <String>['남자', '여자']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '직업:',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'MainFont',
                              fontSize: 24,
                            ),
                          ),
                          DropdownButton<String>(
                            value: dropdownValueJob,
                            underline: Container(
                              height: 1,
                              color: Colors.white,
                            ),
                            dropdownColor: Color(0xff191C2B),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Colors.white),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'MainFont',
                              fontSize: 24,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValueJob = newValue;
                              });
                            },
                            items: <String>['군인', '군무원', '민간인']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: _sizeHeight * 0.045,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      child: Text(
                        'Reset Routine',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MainFont',
                          fontSize: 24,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white)),
                            onPressed: () {
                              _resetPush();
                            },
                            color: Colors.white.withOpacity(0),
                            child: Center(
                              child: Text(
                                "Push-Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'MainFont',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white)),
                            onPressed: () {
                              _resetSit();
                            },
                            color: Colors.white.withOpacity(0),
                            child: Center(
                              child: Text(
                                "Sit-Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'MainFont',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onWillPop: () {},
      ),
    );
  }
}
