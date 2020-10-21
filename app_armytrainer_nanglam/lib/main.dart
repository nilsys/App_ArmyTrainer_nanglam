import 'package:app_armytrainer_nanglam/pushTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pushTab.dart';
import 'sitTab.dart';
import 'profileTab.dart';
import 'package:app_armytrainer_nanglam/sqlite/db_helper.dart';
import 'package:app_armytrainer_nanglam/sqlite/models/models.dart';

void main() => runApp(
      MaterialApp(
        title: 'MyApp',
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> with TickerProviderStateMixin {
  TabController _tabController;
  double _sizeHeight;
  double _sizeWidth;
  double _deviceRatio;
  double _paddingTop;

  List<Widget> list = [
    Tab(
        child: Text(
      'Push-Up',
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'MainFont',
        fontSize: 24,
      ),
    )),
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

  _loadValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      bool key = (prefs.getBool('key') ?? false);
      if (key != true) {
        await dialogScreen();
        DBHelper().createPushRoutineData(
            PushRoutine(idx: 0, routine: "1-2-3-4-5", time: 30));
        DBHelper().createSitRoutineData(
            SitRoutine(idx: 0, routine: "1-2-3-4-5", time: 30));
      }
      prefs.setBool('key', true);
    });
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: list.length);
    _loadValue();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _sizeHeight = MediaQuery.of(context).size.height;
    _sizeWidth = MediaQuery.of(context).size.width;
    _deviceRatio = MediaQuery.of(context).devicePixelRatio;
    _paddingTop = MediaQuery.of(context).padding.top;
    _sizeHeight -= _paddingTop;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff191C2B),
      appBar: null,
      body: SizedBox(
        height: _sizeHeight * _deviceRatio,
        width: _sizeWidth * _deviceRatio,
        child: Column(children: [
          SizedBox(height: _paddingTop + 5),
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 48,
              ),
              IconButton(
                icon: Icon(
                  Icons.bar_chart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileApp(),
                      ));
                },
              ),
              Expanded(
                flex: 1,
                child: SizedBox(height: 48),
              ),
              SizedBox(
                width: 235,
                height: 35,
                child: TabBar(
                  tabs: list,
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4, color: Color(0xffE32A51)),
                    insets: EdgeInsets.symmetric(horizontal: 35.0),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
                height: 48,
              ),
            ],
          ),
          SizedBox(height: _sizeHeight * 0.045),
          SizedBox(
            width: _sizeWidth * _deviceRatio,
            height: _sizeHeight * 0.819,
            child: TabBarView(
              controller: _tabController,
              children: [
                PushTab(),
                SitTab(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void dialogScreen() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return EDialog();
        });
  }
}

class EDialog extends StatefulWidget {
  @override
  _EDialog createState() => new _EDialog();
}

class _EDialog extends State<EDialog> {
  String dropdownValueJob;
  String dropdownValueSex;
  double _sizeWidth;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _saveRoutine;
  bool _check = false;
  int _index;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  _checkValue() {
    if (_ageController.text != '' &&
        _nameController.text != '' &&
        dropdownValueJob != null &&
        dropdownValueSex != null) {
      _check = true;
    }
  }

  _saveValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileName', _nameController.text);
    prefs.setString('profileAge', _ageController.text);
    prefs.setString('profileJob', dropdownValueJob);
    prefs.setString('profileSex', dropdownValueSex);
  }

  @override
  Widget build(BuildContext context) {
    _sizeWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      child: AlertDialog(
        backgroundColor: Color(0xff191C2B),
        title: Text(
          '개인 정보',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MainFont',
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: 'MainFont',
                        fontSize: 18,
                      ),
                      labelText: '이름',
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
                Expanded(
                    child: SizedBox(
                  width: 1,
                )),
                Expanded(
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
              ]),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
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
                      child: SizedBox(
                    width: 1,
                  )),
                  Expanded(
                    child: Column(
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
              )
            ],
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.check, color: Colors.blueAccent),
              onPressed: () {
                _checkValue();
                if (_check == true) {
                  _saveValue();
                  Navigator.pop(context);
                }
              })
        ],
      ),
      onWillPop: () {
        setState(() {});
      },
    );
  }
}
