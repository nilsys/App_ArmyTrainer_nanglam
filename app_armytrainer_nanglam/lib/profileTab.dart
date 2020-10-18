import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pushProfileTab.dart';
import 'sitProfileTab.dart';
import 'editProfile.dart';
import 'routineManagement.dart';
import 'dart:convert';
import 'dart:io';

class ProfileApp extends StatefulWidget {
  @override
  _ProfileApp createState() => _ProfileApp();
}

class _ProfileApp extends State<ProfileApp> with TickerProviderStateMixin {
  Uint8List _byteImage;
  TabController _tabController;
  double _sizeHeight;
  double _paddingTop;
  String _profileName;
  int _pushRecord;
  String base64Image;

  File image;

  List<Widget> list = [
    Tab(
      child: Text(
        'Push-Up',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'MainFont',
          fontSize: 24,
        ),
      ),
    ),
    Tab(
        child: Text(
      'Sit-Up',
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'MainFont',
        fontSize: 24,
      ),
    ))
  ];
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: list.length);
    _loadValue();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      _profileName = (prefs.getString('profileName') ?? 'Name');
      _pushRecord = (prefs.getInt('pushRecord') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    _sizeHeight = MediaQuery.of(context).size.height;
    _paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff191C2B),
      appBar: null,
      body: Column(
        children: [
          SizedBox(height: _paddingTop + 5),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'MainFont',
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: _byteImage == null
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('Images/user.png'),
                              backgroundColor: Color(0xff191C2B),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: MemoryImage(_byteImage),
                              backgroundColor: Color(0xff191C2B),
                            ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_profileName',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'MainFont',
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: 235,
                  height: 97,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                '$_pushRecord',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'MainFont',
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '415',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'MainFont',
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TabBar(
                        tabs: list,
                        controller: _tabController,
                        indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 4, color: Color(0xffE32A51)),
                          insets: EdgeInsets.symmetric(horizontal: 35.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
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
                      moveToEdit();
                    },
                    color: Colors.white.withOpacity(0),
                    child: Center(
                      child: Text(
                        "Edit Profile",
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
                      moveToRoutine();
                    },
                    color: Colors.white.withOpacity(0),
                    child: Center(
                      child: Text(
                        "Routine management",
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
          SizedBox(
            height: _sizeHeight - 280,
            child: TabBarView(
              controller: _tabController,
              children: [
                PushProfile(),
                SitProfile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void moveToEdit() async {
    await Navigator.push(
      this.context,
      CupertinoPageRoute(builder: (context) => EditProfile()),
    );
    setState(() {
      _loadValue();
    });
  }

  void moveToRoutine() async {
    await Navigator.push(
      this.context,
      CupertinoPageRoute(builder: (context) => RoutineManagement()),
    );
    setState(() {
      _loadValue();
    });
  }
}
