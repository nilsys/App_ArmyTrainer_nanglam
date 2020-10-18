import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:image/image.dart' as ImageProcess;

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
  final _nameController = TextEditingController();
  final picker = ImagePicker();

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

  _saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('profileImage', base64Image);
      prefs.setString('profileName', _profileName);
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
    });
  }

  _cancleValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('profileImage', _profileImageBak);
    });
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
                _saveValue();
                Navigator.pop(context);
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
              ],
            ),
          ],
        ),
        onWillPop: () {},
      ),
    );
  }
}
