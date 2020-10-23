import 'package:app_armytrainer_nanglam/main.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_armytrainer_nanglam/sqlite/db_helper.dart';
import 'package:app_armytrainer_nanglam/sqlite/models/models.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:all_sensors/all_sensors.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class PushTab extends StatefulWidget {
  @override
  _PushTab createState() => _PushTab();
}

class _PushTab extends State<PushTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool notToday = false;
  String _setRoutine;
  int _setTime;
  bool _setEnd = false;
  double _sizeWidth;
  String _pushDate = '';
  int _pushRecord = 0;
  int _pushTotal = 0;
  int _pushToday = 0;
  int _idx;
  var _now = new DateTime.now();
  var _formatter = new DateFormat('yyyy-MM-dd');

  Future<PushRoutine> _loadPushRoutine() async {
    PushRoutine routine;
    List<PushRoutine> list = await DBHelper().getAllPushRoutine();
    routine = await DBHelper().getPushRoutine(list[0].idx);
    await Future.forEach(list, (element) async {
      if (element.idx == _idx) {
        routine = await DBHelper().getPushRoutine(_idx);
      }
    });
    return routine;
  }

  _loadPushValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        String formattedDate = _formatter.format(_now);
        _pushRecord = (prefs.getInt('pushRecord') ?? 0);
        _pushTotal = (prefs.getInt('pushTotal') ?? 0);
        _idx = (prefs.getInt('pushIdx') ?? 0);
        _pushDate = formattedDate;
        if (_pushDate != (prefs.getString('pushDate') ?? '')) {
          notToday = true;
          prefs.setString('pushDate', _pushDate);
          prefs.setInt('pushToday', 0);
        }
        _pushToday = (prefs.getInt('pushToday') ?? 0);
      });
    if (notToday) {
      DBHelper()
          .createPushData(Push(date: _pushDate, countRecord: 0, countLevel: 0));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPushValue();
    _loadPushRoutine();
  }

  @override
  Widget build(BuildContext context) {
    _sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff191C2B),
      appBar: null,
      body: Column(
        children: [
          Text(
            'Push-Up Trainer',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'MainFont',
              fontSize: 40,
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: _sizeWidth * 0.125,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Record : $_pushRecord',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MainFont',
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    'Today : $_pushToday',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MainFont',
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 47,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: _sizeWidth * 0.125,
              ),
              Expanded(
                  child: SizedBox(
                height: 47,
              )),
              SizedBox(
                width: _sizeWidth * 0.125,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () {
                  moveDialogScreen();
                  setState(() {});
                },
                child: FutureBuilder(
                  future: _loadPushRoutine(),
                  builder: (context, AsyncSnapshot<PushRoutine> snapshot) {
                    _setEnd = false;
                    if (snapshot.hasData == false) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        "Not Found",
                        style: TextStyle(
                            fontSize: 34,
                            color: Colors.white.withOpacity(0.9),
                            fontFamily: 'MainFont'),
                      ));
                    } else {
                      _setRoutine = snapshot.data.routine;
                      _setTime = snapshot.data.time;
                      _setEnd = true;
                      return Center(
                          child: Text(
                        snapshot.data.routine,
                        style: TextStyle(
                            fontSize: 34,
                            color: Colors.white.withOpacity(0.9),
                            fontFamily: 'MainFont'),
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 130,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  FlatButton(
                    height: 50,
                    onPressed: () {
                      if (_setEnd) {
                        moveToPushUp();
                      }
                    },
                    child: Text(
                      '운동 시작',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 34,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: 4,
                      width: 70,
                      color: Color(0xffE32A51),
                    ),
                    left: 27,
                    bottom: 2,
                  ),
                ],
              ),
              Stack(
                children: [
                  FlatButton(
                    height: 50,
                    onPressed: () {
                      moveToPushUpR();
                    },
                    child: Text(
                      '기록 시작',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 34,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: 4,
                      width: 70,
                      color: Color(0xffE32A51),
                    ),
                    right: 27,
                    bottom: 2,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void moveDialogScreen() async {
    int idx = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return RDialog();
        });
    setState(() {
      if (idx != null) {
        _idx = idx;
      }
    });
    if (idx != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setInt('pushIdx', _idx);
      });
    }
  }

  void moveToPushUp() async {
    final count = await Navigator.push(
      this.context,
      CupertinoPageRoute(
        builder: (context) => PushUpScreen(),
        settings: RouteSettings(
            arguments:
                PushRoutine(idx: 0, routine: _setRoutine, time: _setTime)),
      ),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushToday = (prefs.getInt('pushToday') ?? 0);
      _pushToday += count;
      prefs.setInt('pushToday', _pushToday);
      _pushTotal = (prefs.getInt('pushTotal') ?? 0);
      _pushTotal += count;
      prefs.setInt('pushTotal', _pushTotal);
    });
    Push _res = await DBHelper().getPush(_pushDate);
    if (_res != null) {
      _res.countLevel += count;
      DBHelper().updatePush(_res);
    } else {
      _res = Push(countLevel: count, countRecord: 0, date: _pushDate);
      DBHelper().createPushData(_res);
    }
  }

  moveToPushUpR() async {
    final _list = await Navigator.push(
      this.context,
      CupertinoPageRoute(builder: (context) => PushUpScreenR()),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushToday = (prefs.getInt('pushToday') ?? 0);
      _pushToday += _list[0];
      prefs.setInt('pushToday', _pushToday);
      _pushTotal = (prefs.getInt('pushTotal') ?? 0);
      _pushTotal += _list[0];
      prefs.setInt('pushTotal', _pushTotal);
      if (_list[1] == 0) {
        _pushRecord = (prefs.getInt('pushRecord') ?? 0);
        if (_pushRecord < _list[0]) {
          prefs.setInt('pushRecord', _list[0]);
          _pushRecord = _list[0];
        }
      }
    });
    Push _res = await DBHelper().getPush(_pushDate);
    if (_res != null) {
      if ((_list[1] == 0) && (_list[0] > _res.countRecord)) {
        _res.countRecord = _list[0];
        DBHelper().updatePush(_res);
      } else {
        _res.countLevel += _list[0];
        DBHelper().updatePush(_res);
      }
    } else {
      if ((_list[1] == 0) && (_list[0] > _res.countRecord)) {
        _res = Push(countLevel: 0, countRecord: _list[0], date: _pushDate);
        DBHelper().createPushData(_res);
      } else {
        _res = Push(countLevel: _list[0], countRecord: 0, date: _pushDate);
        DBHelper().createPushData(_res);
      }
    }
  }
}

class PushUpScreen extends StatefulWidget {
  @override
  _PushUpScreen createState() => _PushUpScreen();
}

class _PushUpScreen extends State<PushUpScreen> {
  double _paddingTop;
  double _sizeHeight;
  double _sizeWidth;
  int _count = 0;
  bool _proximityValues = false;
  bool _state = true;
  bool _touch = false;
  int _idx = 0;
  int _sumcount = 0;
  int _buildcnt = 0;
  PushRoutine routine;
  List<int> _routine = List<int>();
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  String _text = "";
  void updateState(bool state) {
    setState(() => _state = state);
  }

  _stringToList() {
    List _tmp = routine.routine.split('-');
    _tmp.forEach((element) {
      _routine.add(int.parse(element));
    });
  }

  void dialogScreen() async {
    final state = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return EDialog(routine.time);
        });
    updateState(state);
  }

  @override
  void dispose() {
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
      setState(() {
        if (_state) {
          _proximityValues = event.getValue();
          if (_proximityValues && !_touch) {
            final player = AudioCache();
            player.play('cursor.mp3');
            _routine[_idx]--;
            _sumcount++;
            if (_routine[_idx] == 0) {
              _idx++;
              if (_idx == _routine.length) {
                _text = "운동이 종료되었습니다.";
                _idx--;
                _touch = true;
              } else {
                _state = false;
                _proximityValues = false;
                dialogScreen();
              }
            }
          }
        }
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    routine = ModalRoute.of(context).settings.arguments;
    if (_buildcnt == 0) {
      _stringToList();
      _buildcnt++;
    }
    _sizeHeight = MediaQuery.of(context).size.height;
    _sizeWidth = MediaQuery.of(context).size.width;
    _paddingTop = MediaQuery.of(context).padding.top;
    _count = _routine[_idx];

    return Scaffold(
      backgroundColor: Color(0xff191C2B),
      appBar: null,
      body: WillPopScope(
        child: Column(
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
                    Navigator.pop(context, _sumcount);
                  },
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(height: 50),
                ),
                Stack(
                  children: [
                    Text(
                      '[' + routine.routine + ']',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 24,
                      ),
                    ),
                    Positioned(
                      child: Container(
                        height: 3,
                        width: 50,
                        color: Color(0xffE32A51),
                      ),
                      right: 25,
                      bottom: 0,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: _sizeWidth,
              height: _sizeHeight - 50 - _paddingTop - 5,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    if ((_idx == _routine.length - 1) && _touch) {
                      Navigator.pop(context, _sumcount);
                    } else if (_proximityValues == false) {
                      final player = AudioCache();
                      player.play('cursor.mp3');
                      _routine[_idx]--;
                      _sumcount++;
                      if (_routine[_idx] == 0) {
                        _idx++;
                        if (_idx == _routine.length) {
                          _text = "운동이 종료되었습니다.";
                          _idx--;
                          _touch = true;
                        } else {
                          _state = false;
                          dialogScreen();
                        }
                      }
                    }
                  });
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_count',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MainFont',
                          fontSize: 50,
                        ),
                      ),
                      Text(
                        '$_text',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MainFont',
                          fontSize: 32,
                        ),
                      )
                    ]),
              ),
            ),
          ],
        ),
        onWillPop: () {},
      ),
    );
  }
}

class PushUpScreenR extends StatefulWidget {
  @override
  _PushUpScreenR createState() => _PushUpScreenR();
}

class _PushUpScreenR extends State<PushUpScreenR> {
  Timer _timer;
  int _time = 120;
  double _paddingTop;
  double _sizeHeight;
  double _sizeWidth;
  int _count = 0;
  bool _proximityValues = false;
  String _profileJob;
  String _profileSex;
  int _profileAge;

  int _pushrecord;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  String _text = "";
  String _levelText = "";

  _loadValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileAge = (prefs.getInt('profileAge') ?? 0);
      _profileJob = (prefs.getString('profileJob') ?? "군인");
      _profileSex = (prefs.getString('profileSex') ?? "남자");
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_time < 1) {
            _text = "기록이 종료되었습니다.";
            timer.cancel();
            for (StreamSubscription<dynamic> subscription
                in _streamSubscriptions) {
              subscription.cancel();
            }
            _pushrecord = _count;
            _levelText = _loadPushLevel();
          } else {
            _time--;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  bool _isKakaoTalkInstalled = true;
  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadValue();
    _initKakaoTalkInstalled();
    _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
      setState(() {
        _proximityValues = event.getValue();
        if (_proximityValues == true) {
          if (_count == 0) {
            startTimer();
          }

          final player = AudioCache();
          player.play('cursor.mp3');
          _count++;
        }
      });
    }));
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } catch (e) {
      print("error on issuing access token: $e");
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch (e) {
      print(e);
    }
  }

  _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = "20ad57fbf96854ff342e2b538131ba6c";
    _sizeHeight = MediaQuery.of(context).size.height;
    _sizeWidth = MediaQuery.of(context).size.width;
    _paddingTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Color(0xff191C2B),
      appBar: null,
      body: WillPopScope(
        child: Column(
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
                    List _list = [_count, _time];
                    Navigator.pop(context, _list);
                  },
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(height: 50),
                ),
                Stack(
                  children: [
                    Text(
                      '시간(초) : $_time',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 24,
                      ),
                    ),
                    Positioned(
                      child: Container(
                        height: 3,
                        width: 70,
                        color: Color(0xffE32A51),
                      ),
                      right: 20,
                      bottom: 2,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: _sizeWidth,
              height: _sizeHeight - 50 - _paddingTop - 5,
              child: FlatButton(
                onPressed: () {
                  if (_count == 0) {
                    startTimer();
                  }
                  setState(() {
                    if (_proximityValues == false && _time > 0) {
                      final player = AudioCache();
                      player.play('cursor.mp3');
                      _count++;
                    }
                  });
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_count',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MainFont',
                          fontSize: 50,
                        ),
                      ),
                      Text(
                        '$_levelText',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MainFont',
                          fontSize: 32,
                        ),
                      ),
                      Text(
                        '$_text',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MainFont',
                          fontSize: 32,
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.share, color: Colors.white),
                          onPressed: () {
                            if (_isKakaoTalkInstalled != null &&
                                _isKakaoTalkInstalled) {
                              _loginWithTalk();
                            } else {
                              _loginWithKakao();
                            }
                          }),
                    ]),
              ),
            ),
          ],
        ),
        onWillPop: () {},
      ),
    );
  }

  String _loadPushLevel() {
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
}

class EDialog extends StatefulWidget {
  int _time;
  EDialog(int time) {
    this._time = time;
  }
  @override
  _EDialog createState() => new _EDialog(_time);
}

class _EDialog extends State<EDialog> {
  Timer _timer;
  int _time;

  _EDialog(int time) {
    this._time = time;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_time < 1) {
            timer.cancel();
            Navigator.pop(context, true);
          } else {
            _time = _time - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: AlertDialog(
        backgroundColor: Color(0xff191C2B),
        title: Text(
          'Rest Time',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MainFont',
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          '$_time',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MainFont',
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            onPressed: () {
              if (_timer != null) {
                _timer.cancel();
              }
              Navigator.pop(context, true);
            },
            child: Text(
              'Skip',
              style: TextStyle(fontSize: 20, fontFamily: 'MainFont'),
            ),
          ),
        ],
      ),
      onWillPop: () {
        setState(() {});
      },
    );
  }
}

class RDialog extends StatefulWidget {
  _RDialog createState() => new _RDialog();
}

class _RDialog extends State<RDialog> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: FutureBuilder(
        future: DBHelper().getAllPushRoutine(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PushRoutine>> snapshot) {
          if (snapshot.hasData) {
            return AlertDialog(
              backgroundColor: Color(0xff191C2B),
              content: SizedBox(
                height: 250,
                width: 280,
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    PushRoutine item = snapshot.data[index];
                    return ListTile(
                      title: FlatButton(
                        onPressed: () {
                          Navigator.pop(context, item.idx);
                        },
                        child: Row(
                          children: [
                            Text(
                              item.routine,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'MainFont',
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              "ㅣ",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'MainFont',
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              item.time.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'MainFont',
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: Icon(Icons.check, color: Colors.blueAccent),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      onWillPop: () {
        setState(() {});
      },
    );
  }
}
