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
  String base64Image;
  int _pushrecord;
  int _profileAge;
  int _sitrecord;
  String _profileSex;
  String _profileJob;

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
      _pushrecord = (prefs.getInt('pushRecord') ?? 0);
      _sitrecord = (prefs.getInt('sitRecord') ?? 0);
      _profileAge = (prefs.getInt('profileAge') ?? 0);
      _profileSex = (prefs.getString('profileSex') ?? '남자');
      _profileJob = (prefs.getString('profileJob') ?? '군인');
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
                            child: FutureBuilder(
                              future: _loadPushLevel(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Center(
                                    child: Text(
                                      snapshot.data,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'MainFont',
                                        fontSize: 32,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: _loadSitLevel(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData) {
                                  return Center(
                                    child: Text(
                                      snapshot.data,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'MainFont',
                                        fontSize: 32,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
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

  Future<String> _loadPushLevel() async {
    if (_profileSex == '남자') {
      if (_profileJob == '군인') {
        if (_profileAge <= 25) {
          if (_pushrecord <= 47) {
            return "불합격";
          } else if (_pushrecord <= 55) {
            return "3급";
          } else if (_pushrecord <= 63) {
            return "2급";
          } else if (_pushrecord <= 71) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_pushrecord <= 45) {
            return "불합격";
          } else if (_pushrecord <= 53) {
            return "3급";
          } else if (_pushrecord <= 61) {
            return "2급";
          } else if (_pushrecord <= 67) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_pushrecord <= 43) {
            return "불합격";
          } else if (_pushrecord <= 51) {
            return "3급";
          } else if (_pushrecord <= 59) {
            return "2급";
          } else if (_pushrecord <= 67) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_pushrecord <= 40) {
            return "불합격";
          } else if (_pushrecord <= 48) {
            return "3급";
          } else if (_pushrecord <= 56) {
            return "2급";
          } else if (_pushrecord <= 67) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_pushrecord <= 36) {
            return "불합격";
          } else if (_pushrecord <= 44) {
            return "3급";
          } else if (_pushrecord <= 52) {
            return "2급";
          } else if (_pushrecord <= 60) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_pushrecord <= 32) {
            return "불합격";
          } else if (_pushrecord <= 40) {
            return "3급";
          } else if (_pushrecord <= 48) {
            return "2급";
          } else if (_pushrecord <= 56) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_pushrecord <= 29) {
            return "불합격";
          } else if (_pushrecord <= 34) {
            return "3급";
          } else if (_pushrecord <= 42) {
            return "2급";
          } else if (_pushrecord <= 50) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_pushrecord <= 26) {
            return "불합격";
          } else if (_pushrecord <= 34) {
            return "3급";
          } else if (_pushrecord <= 45) {
            return "2급";
          } else if (_pushrecord <= 50) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_pushrecord <= 24) {
            return "불합격";
          } else if (_pushrecord <= 32) {
            return "3급";
          } else if (_pushrecord <= 40) {
            return "2급";
          } else if (_pushrecord <= 48) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_pushrecord <= 22) {
            return "불합격";
          } else if (_pushrecord <= 30) {
            return "3급";
          } else if (_pushrecord <= 38) {
            return "2급";
          } else if (_pushrecord <= 46) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_pushrecord <= 19) {
            return "불합격";
          } else if (_pushrecord <= 27) {
            return "3급";
          } else if (_pushrecord <= 35) {
            return "2급";
          } else if (_pushrecord <= 43) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_pushrecord <= 17) {
            return "불합격";
          } else if (_pushrecord <= 25) {
            return "3급";
          } else if (_pushrecord <= 33) {
            return "2급";
          } else if (_pushrecord <= 41) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_pushrecord <= 15) {
            return "불합격";
          } else if (_pushrecord <= 23) {
            return "3급";
          } else if (_pushrecord <= 31) {
            return "2급";
          } else if (_pushrecord <= 39) {
            return "1급";
          } else {
            return "특급";
          }
        }
      } else if (_profileJob == '군무원') {
        if (_profileAge <= 25) {
          if (_pushrecord <= 42) {
            return "불합격";
          } else if (_pushrecord <= 49) {
            return "3급";
          } else if (_pushrecord <= 57) {
            return "2급";
          } else if (_pushrecord <= 64) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_pushrecord <= 41) {
            return "불합격";
          } else if (_pushrecord <= 48) {
            return "3급";
          } else if (_pushrecord <= 55) {
            return "2급";
          } else if (_pushrecord <= 62) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_pushrecord <= 39) {
            return "불합격";
          } else if (_pushrecord <= 46) {
            return "3급";
          } else if (_pushrecord <= 53) {
            return "2급";
          } else if (_pushrecord <= 60) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_pushrecord <= 36) {
            return "불합격";
          } else if (_pushrecord <= 43) {
            return "3급";
          } else if (_pushrecord <= 50) {
            return "2급";
          } else if (_pushrecord <= 58) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_pushrecord <= 32) {
            return "불합격";
          } else if (_pushrecord <= 40) {
            return "3급";
          } else if (_pushrecord <= 47) {
            return "2급";
          } else if (_pushrecord <= 54) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_pushrecord <= 29) {
            return "불합격";
          } else if (_pushrecord <= 36) {
            return "3급";
          } else if (_pushrecord <= 43) {
            return "2급";
          } else if (_pushrecord <= 50) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_pushrecord <= 26) {
            return "불합격";
          } else if (_pushrecord <= 33) {
            return "3급";
          } else if (_pushrecord <= 40) {
            return "2급";
          } else if (_pushrecord <= 48) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_pushrecord <= 23) {
            return "불합격";
          } else if (_pushrecord <= 31) {
            return "3급";
          } else if (_pushrecord <= 38) {
            return "2급";
          } else if (_pushrecord <= 45) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_pushrecord <= 22) {
            return "불합격";
          } else if (_pushrecord <= 29) {
            return "3급";
          } else if (_pushrecord <= 36) {
            return "2급";
          } else if (_pushrecord <= 43) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_pushrecord <= 20) {
            return "불합격";
          } else if (_pushrecord <= 27) {
            return "3급";
          } else if (_pushrecord <= 34) {
            return "2급";
          } else if (_pushrecord <= 41) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_pushrecord <= 18) {
            return "불합격";
          } else if (_pushrecord <= 25) {
            return "3급";
          } else if (_pushrecord <= 32) {
            return "2급";
          } else if (_pushrecord <= 39) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_pushrecord <= 16) {
            return "불합격";
          } else if (_pushrecord <= 23) {
            return "3급";
          } else if (_pushrecord <= 30) {
            return "2급";
          } else if (_pushrecord <= 37) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_pushrecord <= 14) {
            return "불합격";
          } else if (_pushrecord <= 21) {
            return "3급";
          } else if (_pushrecord <= 28) {
            return "2급";
          } else if (_pushrecord <= 35) {
            return "1급";
          } else {
            return "특급";
          }
        }
      } else {
        if (_profileAge <= 25) {
          if (_pushrecord <= 42) {
            return "불합격";
          } else if (_pushrecord <= 49) {
            return "3급";
          } else if (_pushrecord <= 57) {
            return "2급";
          } else if (_pushrecord <= 64) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_pushrecord <= 41) {
            return "불합격";
          } else if (_pushrecord <= 48) {
            return "3급";
          } else if (_pushrecord <= 55) {
            return "2급";
          } else if (_pushrecord <= 62) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_pushrecord <= 39) {
            return "불합격";
          } else if (_pushrecord <= 46) {
            return "3급";
          } else if (_pushrecord <= 53) {
            return "2급";
          } else if (_pushrecord <= 60) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_pushrecord <= 36) {
            return "불합격";
          } else if (_pushrecord <= 43) {
            return "3급";
          } else if (_pushrecord <= 50) {
            return "2급";
          } else if (_pushrecord <= 58) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_pushrecord <= 32) {
            return "불합격";
          } else if (_pushrecord <= 40) {
            return "3급";
          } else if (_pushrecord <= 47) {
            return "2급";
          } else if (_pushrecord <= 54) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_pushrecord <= 29) {
            return "불합격";
          } else if (_pushrecord <= 36) {
            return "3급";
          } else if (_pushrecord <= 43) {
            return "2급";
          } else if (_pushrecord <= 50) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_pushrecord <= 26) {
            return "불합격";
          } else if (_pushrecord <= 33) {
            return "3급";
          } else if (_pushrecord <= 40) {
            return "2급";
          } else if (_pushrecord <= 48) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_pushrecord <= 23) {
            return "불합격";
          } else if (_pushrecord <= 31) {
            return "3급";
          } else if (_pushrecord <= 38) {
            return "2급";
          } else if (_pushrecord <= 45) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_pushrecord <= 22) {
            return "불합격";
          } else if (_pushrecord <= 29) {
            return "3급";
          } else if (_pushrecord <= 36) {
            return "2급";
          } else if (_pushrecord <= 43) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_pushrecord <= 20) {
            return "불합격";
          } else if (_pushrecord <= 27) {
            return "3급";
          } else if (_pushrecord <= 34) {
            return "2급";
          } else if (_pushrecord <= 41) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_pushrecord <= 18) {
            return "불합격";
          } else if (_pushrecord <= 25) {
            return "3급";
          } else if (_pushrecord <= 32) {
            return "2급";
          } else if (_pushrecord <= 39) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_pushrecord <= 16) {
            return "불합격";
          } else if (_pushrecord <= 23) {
            return "3급";
          } else if (_pushrecord <= 30) {
            return "2급";
          } else if (_pushrecord <= 37) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_pushrecord <= 14) {
            return "불합격";
          } else if (_pushrecord <= 21) {
            return "3급";
          } else if (_pushrecord <= 28) {
            return "2급";
          } else if (_pushrecord <= 35) {
            return "1급";
          } else {
            return "특급";
          }
        }
      }
    } else {
      if (_profileJob == '군인') {
        if (_profileAge <= 25) {
          if (_pushrecord <= 22) {
            return "불합격";
          } else if (_pushrecord <= 26) {
            return "3급";
          } else if (_pushrecord <= 30) {
            return "2급";
          } else if (_pushrecord <= 34) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_pushrecord <= 21) {
            return "불합격";
          } else if (_pushrecord <= 25) {
            return "3급";
          } else if (_pushrecord <= 28) {
            return "2급";
          } else if (_pushrecord <= 32) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_pushrecord <= 19) {
            return "불합격";
          } else if (_pushrecord <= 22) {
            return "3급";
          } else if (_pushrecord <= 26) {
            return "2급";
          } else if (_pushrecord <= 30) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_pushrecord <= 17) {
            return "불합격";
          } else if (_pushrecord <= 21) {
            return "3급";
          } else if (_pushrecord <= 24) {
            return "2급";
          } else if (_pushrecord <= 28) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_pushrecord <= 15) {
            return "불합격";
          } else if (_pushrecord <= 18) {
            return "3급";
          } else if (_pushrecord <= 22) {
            return "2급";
          } else if (_pushrecord <= 25) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_pushrecord <= 14) {
            return "불합격";
          } else if (_pushrecord <= 17) {
            return "3급";
          } else if (_pushrecord <= 20) {
            return "2급";
          } else if (_pushrecord <= 23) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_pushrecord <= 12) {
            return "불합격";
          } else if (_pushrecord <= 15) {
            return "3급";
          } else if (_pushrecord <= 18) {
            return "2급";
          } else if (_pushrecord <= 21) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_pushrecord <= 10) {
            return "불합격";
          } else if (_pushrecord <= 13) {
            return "3급";
          } else if (_pushrecord <= 16) {
            return "2급";
          } else if (_pushrecord <= 18) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_pushrecord <= 8) {
            return "불합격";
          } else if (_pushrecord <= 11) {
            return "3급";
          } else if (_pushrecord <= 13) {
            return "2급";
          } else if (_pushrecord <= 16) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_pushrecord <= 7) {
            return "불합격";
          } else if (_pushrecord <= 9) {
            return "3급";
          } else if (_pushrecord <= 12) {
            return "2급";
          } else if (_pushrecord <= 14) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_pushrecord <= 6) {
            return "불합격";
          } else if (_pushrecord <= 8) {
            return "3급";
          } else if (_pushrecord <= 10) {
            return "2급";
          } else if (_pushrecord <= 12) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_pushrecord <= 5) {
            return "불합격";
          } else if (_pushrecord <= 7) {
            return "3급";
          } else if (_pushrecord <= 9) {
            return "2급";
          } else if (_pushrecord <= 11) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_pushrecord <= 4) {
            return "불합격";
          } else if (_pushrecord <= 6) {
            return "3급";
          } else if (_pushrecord <= 8) {
            return "2급";
          } else if (_pushrecord <= 10) {
            return "1급";
          } else {
            return "특급";
          }
        }
      } else if (_profileJob == '군무원') {
        if (_profileAge <= 25) {
          if (_pushrecord <= 20) {
            return "불합격";
          } else if (_pushrecord <= 23) {
            return "3급";
          } else if (_pushrecord <= 27) {
            return "2급";
          } else if (_pushrecord <= 31) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_pushrecord <= 19) {
            return "불합격";
          } else if (_pushrecord <= 22) {
            return "3급";
          } else if (_pushrecord <= 25) {
            return "2급";
          } else if (_pushrecord <= 29) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_pushrecord <= 17) {
            return "불합격";
          } else if (_pushrecord <= 20) {
            return "3급";
          } else if (_pushrecord <= 23) {
            return "2급";
          } else if (_pushrecord <= 27) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_pushrecord <= 15) {
            return "불합격";
          } else if (_pushrecord <= 19) {
            return "3급";
          } else if (_pushrecord <= 22) {
            return "2급";
          } else if (_pushrecord <= 25) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_pushrecord <= 14) {
            return "불합격";
          } else if (_pushrecord <= 16) {
            return "3급";
          } else if (_pushrecord <= 20) {
            return "2급";
          } else if (_pushrecord <= 22) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_pushrecord <= 13) {
            return "불합격";
          } else if (_pushrecord <= 15) {
            return "3급";
          } else if (_pushrecord <= 18) {
            return "2급";
          } else if (_pushrecord <= 21) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_pushrecord <= 11) {
            return "불합격";
          } else if (_pushrecord <= 13) {
            return "3급";
          } else if (_pushrecord <= 16) {
            return "2급";
          } else if (_pushrecord <= 19) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_pushrecord <= 9) {
            return "불합격";
          } else if (_pushrecord <= 12) {
            return "3급";
          } else if (_pushrecord <= 14) {
            return "2급";
          } else if (_pushrecord <= 16) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_pushrecord <= 7) {
            return "불합격";
          } else if (_pushrecord <= 10) {
            return "3급";
          } else if (_pushrecord <= 12) {
            return "2급";
          } else if (_pushrecord <= 14) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_pushrecord <= 6) {
            return "불합격";
          } else if (_pushrecord <= 8) {
            return "3급";
          } else if (_pushrecord <= 11) {
            return "2급";
          } else if (_pushrecord <= 13) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_pushrecord <= 5) {
            return "불합격";
          } else if (_pushrecord <= 7) {
            return "3급";
          } else if (_pushrecord <= 9) {
            return "2급";
          } else if (_pushrecord <= 11) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_pushrecord <= 4) {
            return "불합격";
          } else if (_pushrecord <= 6) {
            return "3급";
          } else if (_pushrecord <= 8) {
            return "2급";
          } else if (_pushrecord <= 10) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_pushrecord <= 3) {
            return "불합격";
          } else if (_pushrecord <= 5) {
            return "3급";
          } else if (_pushrecord <= 7) {
            return "2급";
          } else if (_pushrecord <= 9) {
            return "1급";
          } else {
            return "특급";
          }
        }
      } else {
        if (_profileAge <= 25) {
          if (_pushrecord <= 20) {
            return "불합격";
          } else if (_pushrecord <= 23) {
            return "3급";
          } else if (_pushrecord <= 27) {
            return "2급";
          } else if (_pushrecord <= 31) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_pushrecord <= 19) {
            return "불합격";
          } else if (_pushrecord <= 22) {
            return "3급";
          } else if (_pushrecord <= 25) {
            return "2급";
          } else if (_pushrecord <= 29) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_pushrecord <= 17) {
            return "불합격";
          } else if (_pushrecord <= 20) {
            return "3급";
          } else if (_pushrecord <= 23) {
            return "2급";
          } else if (_pushrecord <= 27) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_pushrecord <= 15) {
            return "불합격";
          } else if (_pushrecord <= 19) {
            return "3급";
          } else if (_pushrecord <= 22) {
            return "2급";
          } else if (_pushrecord <= 25) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_pushrecord <= 14) {
            return "불합격";
          } else if (_pushrecord <= 16) {
            return "3급";
          } else if (_pushrecord <= 20) {
            return "2급";
          } else if (_pushrecord <= 22) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_pushrecord <= 13) {
            return "불합격";
          } else if (_pushrecord <= 15) {
            return "3급";
          } else if (_pushrecord <= 18) {
            return "2급";
          } else if (_pushrecord <= 21) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_pushrecord <= 11) {
            return "불합격";
          } else if (_pushrecord <= 13) {
            return "3급";
          } else if (_pushrecord <= 16) {
            return "2급";
          } else if (_pushrecord <= 19) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_pushrecord <= 9) {
            return "불합격";
          } else if (_pushrecord <= 12) {
            return "3급";
          } else if (_pushrecord <= 14) {
            return "2급";
          } else if (_pushrecord <= 16) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_pushrecord <= 7) {
            return "불합격";
          } else if (_pushrecord <= 10) {
            return "3급";
          } else if (_pushrecord <= 12) {
            return "2급";
          } else if (_pushrecord <= 14) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_pushrecord <= 6) {
            return "불합격";
          } else if (_pushrecord <= 8) {
            return "3급";
          } else if (_pushrecord <= 11) {
            return "2급";
          } else if (_pushrecord <= 13) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_pushrecord <= 5) {
            return "불합격";
          } else if (_pushrecord <= 7) {
            return "3급";
          } else if (_pushrecord <= 9) {
            return "2급";
          } else if (_pushrecord <= 11) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_pushrecord <= 4) {
            return "불합격";
          } else if (_pushrecord <= 6) {
            return "3급";
          } else if (_pushrecord <= 8) {
            return "2급";
          } else if (_pushrecord <= 10) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_pushrecord <= 3) {
            return "불합격";
          } else if (_pushrecord <= 5) {
            return "3급";
          } else if (_pushrecord <= 7) {
            return "2급";
          } else if (_pushrecord <= 9) {
            return "1급";
          } else {
            return "특급";
          }
        }
      }
    }
    return null;
  }

  Future<String> _loadSitLevel() async {
    if (_profileSex == '남자') {
      if (_profileJob == '군인') {
        if (_profileAge <= 25) {
          if (_sitrecord <= 61) {
            return "불합격";
          } else if (_sitrecord <= 69) {
            return "3급";
          } else if (_sitrecord <= 77) {
            return "2급";
          } else if (_sitrecord <= 85) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_sitrecord <= 59) {
            return "불합격";
          } else if (_sitrecord <= 67) {
            return "3급";
          } else if (_sitrecord <= 75) {
            return "2급";
          } else if (_sitrecord <= 83) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_sitrecord <= 56) {
            return "불합격";
          } else if (_sitrecord <= 64) {
            return "3급";
          } else if (_sitrecord <= 71) {
            return "2급";
          } else if (_sitrecord <= 79) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_sitrecord <= 51) {
            return "불합격";
          } else if (_sitrecord <= 59) {
            return "3급";
          } else if (_sitrecord <= 67) {
            return "2급";
          } else if (_sitrecord <= 75) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_sitrecord <= 47) {
            return "불합격";
          } else if (_sitrecord <= 55) {
            return "3급";
          } else if (_sitrecord <= 63) {
            return "2급";
          } else if (_sitrecord <= 71) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_sitrecord <= 43) {
            return "불합격";
          } else if (_sitrecord <= 51) {
            return "3급";
          } else if (_sitrecord <= 59) {
            return "2급";
          } else if (_sitrecord <= 67) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_sitrecord <= 40) {
            return "불합격";
          } else if (_sitrecord <= 48) {
            return "3급";
          } else if (_sitrecord <= 56) {
            return "2급";
          } else if (_sitrecord <= 64) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_sitrecord <= 37) {
            return "불합격";
          } else if (_sitrecord <= 45) {
            return "3급";
          } else if (_sitrecord <= 53) {
            return "2급";
          } else if (_sitrecord <= 61) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_sitrecord <= 35) {
            return "불합격";
          } else if (_sitrecord <= 41) {
            return "3급";
          } else if (_sitrecord <= 49) {
            return "2급";
          } else if (_sitrecord <= 57) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_sitrecord <= 33) {
            return "불합격";
          } else if (_sitrecord <= 41) {
            return "3급";
          } else if (_sitrecord <= 49) {
            return "2급";
          } else if (_sitrecord <= 57) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_sitrecord <= 31) {
            return "불합격";
          } else if (_sitrecord <= 39) {
            return "3급";
          } else if (_sitrecord <= 47) {
            return "2급";
          } else if (_sitrecord <= 55) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_sitrecord <= 29) {
            return "불합격";
          } else if (_sitrecord <= 37) {
            return "3급";
          } else if (_sitrecord <= 45) {
            return "2급";
          } else if (_sitrecord <= 53) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_sitrecord <= 27) {
            return "불합격";
          } else if (_sitrecord <= 35) {
            return "3급";
          } else if (_sitrecord <= 43) {
            return "2급";
          } else if (_sitrecord <= 51) {
            return "1급";
          } else {
            return "특급";
          }
        }
      } else if (_profileJob == '군무원') {
        if (_profileAge <= 25) {
          if (_sitrecord <= 55) {
            return "불합격";
          } else if (_sitrecord <= 62) {
            return "3급";
          } else if (_sitrecord <= 70) {
            return "2급";
          } else if (_sitrecord <= 77) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_sitrecord <= 54) {
            return "불합격";
          } else if (_sitrecord <= 61) {
            return "3급";
          } else if (_sitrecord <= 68) {
            return "2급";
          } else if (_sitrecord <= 75) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_sitrecord <= 51) {
            return "불합격";
          } else if (_sitrecord <= 58) {
            return "3급";
          } else if (_sitrecord <= 64) {
            return "2급";
          } else if (_sitrecord <= 71) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_sitrecord <= 46) {
            return "불합격";
          } else if (_sitrecord <= 53) {
            return "3급";
          } else if (_sitrecord <= 61) {
            return "2급";
          } else if (_sitrecord <= 68) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_sitrecord <= 43) {
            return "불합격";
          } else if (_sitrecord <= 50) {
            return "3급";
          } else if (_sitrecord <= 57) {
            return "2급";
          } else if (_sitrecord <= 64) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_sitrecord <= 39) {
            return "불합격";
          } else if (_sitrecord <= 46) {
            return "3급";
          } else if (_sitrecord <= 53) {
            return "2급";
          } else if (_sitrecord <= 61) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_sitrecord <= 36) {
            return "불합격";
          } else if (_sitrecord <= 44) {
            return "3급";
          } else if (_sitrecord <= 51) {
            return "2급";
          } else if (_sitrecord <= 58) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_sitrecord <= 34) {
            return "불합격";
          } else if (_sitrecord <= 41) {
            return "3급";
          } else if (_sitrecord <= 48) {
            return "2급";
          } else if (_sitrecord <= 55) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_sitrecord <= 32) {
            return "불합격";
          } else if (_sitrecord <= 39) {
            return "3급";
          } else if (_sitrecord <= 46) {
            return "2급";
          } else if (_sitrecord <= 53) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_sitrecord <= 30) {
            return "불합격";
          } else if (_sitrecord <= 37) {
            return "3급";
          } else if (_sitrecord <= 44) {
            return "2급";
          } else if (_sitrecord <= 52) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_sitrecord <= 29) {
            return "불합격";
          } else if (_sitrecord <= 36) {
            return "3급";
          } else if (_sitrecord <= 44) {
            return "2급";
          } else if (_sitrecord <= 51) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_sitrecord <= 28) {
            return "불합격";
          } else if (_sitrecord <= 35) {
            return "3급";
          } else if (_sitrecord <= 43) {
            return "2급";
          } else if (_sitrecord <= 50) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_sitrecord <= 26) {
            return "불합격";
          } else if (_sitrecord <= 33) {
            return "3급";
          } else if (_sitrecord <= 41) {
            return "2급";
          } else if (_sitrecord <= 48) {
            return "1급";
          } else {
            return "특급";
          }
        }
      } else {
        if (_profileAge <= 25) {
          if (_sitrecord <= 55) {
            return "불합격";
          } else if (_sitrecord <= 62) {
            return "3급";
          } else if (_sitrecord <= 70) {
            return "2급";
          } else if (_sitrecord <= 77) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_sitrecord <= 54) {
            return "불합격";
          } else if (_sitrecord <= 61) {
            return "3급";
          } else if (_sitrecord <= 68) {
            return "2급";
          } else if (_sitrecord <= 75) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_sitrecord <= 51) {
            return "불합격";
          } else if (_sitrecord <= 58) {
            return "3급";
          } else if (_sitrecord <= 64) {
            return "2급";
          } else if (_sitrecord <= 71) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_sitrecord <= 46) {
            return "불합격";
          } else if (_sitrecord <= 53) {
            return "3급";
          } else if (_sitrecord <= 61) {
            return "2급";
          } else if (_sitrecord <= 68) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_sitrecord <= 43) {
            return "불합격";
          } else if (_sitrecord <= 50) {
            return "3급";
          } else if (_sitrecord <= 57) {
            return "2급";
          } else if (_sitrecord <= 64) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_sitrecord <= 39) {
            return "불합격";
          } else if (_sitrecord <= 46) {
            return "3급";
          } else if (_sitrecord <= 53) {
            return "2급";
          } else if (_sitrecord <= 61) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_sitrecord <= 36) {
            return "불합격";
          } else if (_sitrecord <= 44) {
            return "3급";
          } else if (_sitrecord <= 51) {
            return "2급";
          } else if (_sitrecord <= 58) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_sitrecord <= 34) {
            return "불합격";
          } else if (_sitrecord <= 41) {
            return "3급";
          } else if (_sitrecord <= 48) {
            return "2급";
          } else if (_sitrecord <= 55) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_sitrecord <= 32) {
            return "불합격";
          } else if (_sitrecord <= 39) {
            return "3급";
          } else if (_sitrecord <= 46) {
            return "2급";
          } else if (_sitrecord <= 53) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_sitrecord <= 30) {
            return "불합격";
          } else if (_sitrecord <= 37) {
            return "3급";
          } else if (_sitrecord <= 44) {
            return "2급";
          } else if (_sitrecord <= 52) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_sitrecord <= 29) {
            return "불합격";
          } else if (_sitrecord <= 36) {
            return "3급";
          } else if (_sitrecord <= 44) {
            return "2급";
          } else if (_sitrecord <= 51) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_sitrecord <= 28) {
            return "불합격";
          } else if (_sitrecord <= 35) {
            return "3급";
          } else if (_sitrecord <= 43) {
            return "2급";
          } else if (_sitrecord <= 50) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_sitrecord <= 26) {
            return "불합격";
          } else if (_sitrecord <= 33) {
            return "3급";
          } else if (_sitrecord <= 41) {
            return "2급";
          } else if (_sitrecord <= 48) {
            return "1급";
          } else {
            return "특급";
          }
        }
      }
    } else {
      if (_profileJob == '군인') {
        if (_profileAge <= 25) {
          if (_sitrecord <= 46) {
            return "불합격";
          } else if (_sitrecord <= 54) {
            return "3급";
          } else if (_sitrecord <= 62) {
            return "2급";
          } else if (_sitrecord <= 70) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_sitrecord <= 44) {
            return "불합격";
          } else if (_sitrecord <= 51) {
            return "3급";
          } else if (_sitrecord <= 59) {
            return "2급";
          } else if (_sitrecord <= 67) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_sitrecord <= 41) {
            return "불합격";
          } else if (_sitrecord <= 49) {
            return "3급";
          } else if (_sitrecord <= 57) {
            return "2급";
          } else if (_sitrecord <= 65) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_sitrecord <= 38) {
            return "불합격";
          } else if (_sitrecord <= 46) {
            return "3급";
          } else if (_sitrecord <= 54) {
            return "2급";
          } else if (_sitrecord <= 62) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_sitrecord <= 35) {
            return "불합격";
          } else if (_sitrecord <= 43) {
            return "3급";
          } else if (_sitrecord <= 51) {
            return "2급";
          } else if (_sitrecord <= 59) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_sitrecord <= 32) {
            return "불합격";
          } else if (_sitrecord <= 40) {
            return "3급";
          } else if (_sitrecord <= 48) {
            return "2급";
          } else if (_sitrecord <= 56) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_sitrecord <= 30) {
            return "불합격";
          } else if (_sitrecord <= 38) {
            return "3급";
          } else if (_sitrecord <= 46) {
            return "2급";
          } else if (_sitrecord <= 54) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_sitrecord <= 29) {
            return "불합격";
          } else if (_sitrecord <= 37) {
            return "3급";
          } else if (_sitrecord <= 45) {
            return "2급";
          } else if (_sitrecord <= 53) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_sitrecord <= 28) {
            return "불합격";
          } else if (_sitrecord <= 36) {
            return "3급";
          } else if (_sitrecord <= 44) {
            return "2급";
          } else if (_sitrecord <= 52) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_sitrecord <= 27) {
            return "불합격";
          } else if (_sitrecord <= 35) {
            return "3급";
          } else if (_sitrecord <= 43) {
            return "2급";
          } else if (_sitrecord <= 51) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_sitrecord <= 25) {
            return "불합격";
          } else if (_sitrecord <= 33) {
            return "3급";
          } else if (_sitrecord <= 41) {
            return "2급";
          } else if (_sitrecord <= 49) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_sitrecord <= 24) {
            return "불합격";
          } else if (_sitrecord <= 32) {
            return "3급";
          } else if (_sitrecord <= 40) {
            return "2급";
          } else if (_sitrecord <= 47) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_sitrecord <= 23) {
            return "불합격";
          } else if (_sitrecord <= 30) {
            return "3급";
          } else if (_sitrecord <= 38) {
            return "2급";
          } else if (_sitrecord <= 45) {
            return "1급";
          } else {
            return "특급";
          }
        }
      } else if (_profileJob == '군무원') {
        if (_profileAge <= 25) {
          if (_sitrecord <= 42) {
            return "불합격";
          } else if (_sitrecord <= 49) {
            return "3급";
          } else if (_sitrecord <= 56) {
            return "2급";
          } else if (_sitrecord <= 63) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_sitrecord <= 40) {
            return "불합격";
          } else if (_sitrecord <= 46) {
            return "3급";
          } else if (_sitrecord <= 53) {
            return "2급";
          } else if (_sitrecord <= 61) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_sitrecord <= 37) {
            return "불합격";
          } else if (_sitrecord <= 44) {
            return "3급";
          } else if (_sitrecord <= 52) {
            return "2급";
          } else if (_sitrecord <= 59) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_sitrecord <= 35) {
            return "불합격";
          } else if (_sitrecord <= 42) {
            return "3급";
          } else if (_sitrecord <= 49) {
            return "2급";
          } else if (_sitrecord <= 56) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_sitrecord <= 32) {
            return "불합격";
          } else if (_sitrecord <= 39) {
            return "3급";
          } else if (_sitrecord <= 46) {
            return "2급";
          } else if (_sitrecord <= 53) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_sitrecord <= 29) {
            return "불합격";
          } else if (_sitrecord <= 36) {
            return "3급";
          } else if (_sitrecord <= 44) {
            return "2급";
          } else if (_sitrecord <= 51) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_sitrecord <= 28) {
            return "불합격";
          } else if (_sitrecord <= 35) {
            return "3급";
          } else if (_sitrecord <= 42) {
            return "2급";
          } else if (_sitrecord <= 49) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_sitrecord <= 27) {
            return "불합격";
          } else if (_sitrecord <= 34) {
            return "3급";
          } else if (_sitrecord <= 41) {
            return "2급";
          } else if (_sitrecord <= 48) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_sitrecord <= 26) {
            return "불합격";
          } else if (_sitrecord <= 33) {
            return "3급";
          } else if (_sitrecord <= 40) {
            return "2급";
          } else if (_sitrecord <= 47) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_sitrecord <= 25) {
            return "불합격";
          } else if (_sitrecord <= 32) {
            return "3급";
          } else if (_sitrecord <= 39) {
            return "2급";
          } else if (_sitrecord <= 46) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_sitrecord <= 24) {
            return "불합격";
          } else if (_sitrecord <= 31) {
            return "3급";
          } else if (_sitrecord <= 38) {
            return "2급";
          } else if (_sitrecord <= 45) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_sitrecord <= 22) {
            return "불합격";
          } else if (_sitrecord <= 29) {
            return "3급";
          } else if (_sitrecord <= 37) {
            return "2급";
          } else if (_sitrecord <= 44) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_sitrecord <= 21) {
            return "불합격";
          } else if (_sitrecord <= 28) {
            return "3급";
          } else if (_sitrecord <= 36) {
            return "2급";
          } else if (_sitrecord <= 43) {
            return "1급";
          } else {
            return "특급";
          }
        }
      } else {
        if (_profileAge <= 25) {
          if (_sitrecord <= 42) {
            return "불합격";
          } else if (_sitrecord <= 49) {
            return "3급";
          } else if (_sitrecord <= 56) {
            return "2급";
          } else if (_sitrecord <= 63) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 30) {
          if (_sitrecord <= 40) {
            return "불합격";
          } else if (_sitrecord <= 46) {
            return "3급";
          } else if (_sitrecord <= 53) {
            return "2급";
          } else if (_sitrecord <= 61) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 35) {
          if (_sitrecord <= 37) {
            return "불합격";
          } else if (_sitrecord <= 44) {
            return "3급";
          } else if (_sitrecord <= 52) {
            return "2급";
          } else if (_sitrecord <= 59) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 40) {
          if (_sitrecord <= 35) {
            return "불합격";
          } else if (_sitrecord <= 42) {
            return "3급";
          } else if (_sitrecord <= 49) {
            return "2급";
          } else if (_sitrecord <= 56) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 43) {
          if (_sitrecord <= 32) {
            return "불합격";
          } else if (_sitrecord <= 39) {
            return "3급";
          } else if (_sitrecord <= 46) {
            return "2급";
          } else if (_sitrecord <= 53) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 46) {
          if (_sitrecord <= 29) {
            return "불합격";
          } else if (_sitrecord <= 36) {
            return "3급";
          } else if (_sitrecord <= 44) {
            return "2급";
          } else if (_sitrecord <= 51) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 49) {
          if (_sitrecord <= 28) {
            return "불합격";
          } else if (_sitrecord <= 35) {
            return "3급";
          } else if (_sitrecord <= 42) {
            return "2급";
          } else if (_sitrecord <= 49) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 51) {
          if (_sitrecord <= 27) {
            return "불합격";
          } else if (_sitrecord <= 34) {
            return "3급";
          } else if (_sitrecord <= 41) {
            return "2급";
          } else if (_sitrecord <= 48) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 53) {
          if (_sitrecord <= 26) {
            return "불합격";
          } else if (_sitrecord <= 33) {
            return "3급";
          } else if (_sitrecord <= 40) {
            return "2급";
          } else if (_sitrecord <= 47) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 55) {
          if (_sitrecord <= 25) {
            return "불합격";
          } else if (_sitrecord <= 32) {
            return "3급";
          } else if (_sitrecord <= 39) {
            return "2급";
          } else if (_sitrecord <= 46) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 57) {
          if (_sitrecord <= 24) {
            return "불합격";
          } else if (_sitrecord <= 31) {
            return "3급";
          } else if (_sitrecord <= 38) {
            return "2급";
          } else if (_sitrecord <= 45) {
            return "1급";
          } else {
            return "특급";
          }
        } else if (_profileAge <= 59) {
          if (_sitrecord <= 22) {
            return "불합격";
          } else if (_sitrecord <= 29) {
            return "3급";
          } else if (_sitrecord <= 37) {
            return "2급";
          } else if (_sitrecord <= 44) {
            return "1급";
          } else {
            return "특급";
          }
        } else {
          if (_sitrecord <= 21) {
            return "불합격";
          } else if (_sitrecord <= 28) {
            return "3급";
          } else if (_sitrecord <= 36) {
            return "2급";
          } else if (_sitrecord <= 43) {
            return "1급";
          } else {
            return "특급";
          }
        }
      }
    }
    return null;
  }
}
