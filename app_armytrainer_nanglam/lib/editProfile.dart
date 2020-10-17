import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  double _sizeHeight;
  String _profilePath;
  String _profilePathBak;
  String _profileName;
  final _nameController = TextEditingController();
  final picker = ImagePicker();

  Future _imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _profilePath = pickedFile.path;
      } else {
        _profilePath = null;
      }
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('profilePath', _profilePath);
    });
  }

  Future _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profilePath = pickedFile.path;
      } else {
        _profilePath = null;
      }
    });
  }

  _saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('profilePath', _profilePath);
      prefs.setString('profileName', _profileName);
    });
  }

  _loadValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profilePath = (prefs.getString('profilePath') ?? null);
      _profilePathBak = (prefs.getString('profilePath') ?? null);
      _profileName = (prefs.getString('profileName') ?? 'Name');
    });
  }

  _cancleValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('profilePath', _profilePathBak);
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
                      child: _profilePath == null
                          ? CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage('Images/user.png'),
                              backgroundColor: Color(0xff191C2B),
                            )
                          : CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(_profilePath),
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
                    //controller: _bioController,
                    decoration: InputDecoration(
                      labelText: 'Bio',
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
                        //  _bioController.text = value;
                      });
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  child: TextField(
                    //  controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email address',
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
                        //    _emailController.text = value;
                      });
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
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
                        //  _phoneController.text = value;
                      });
                    }),
                  ),
                )
              ],
            ),
          ],
        ),
        onWillPop: () {},
      ),
    );
  }
}
