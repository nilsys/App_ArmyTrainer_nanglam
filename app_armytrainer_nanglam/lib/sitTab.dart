import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_armytrainer_nanglam/sqlite/db_helper.dart';
import 'package:app_armytrainer_nanglam/sqlite/models/models.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:all_sensors/all_sensors.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class SitTab extends StatefulWidget {
  @override
  _SitTab createState() => _SitTab();
}

class _SitTab extends State<SitTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool notToday = false;
  String _setRoutine;
  int _setTime;
  bool _setEnd = false;
  double _sizeWidth;
  String _sitDate = '';
  int _sitRecord = 0;
  int _sitTotal = 0;
  int _sitToday = 0;
  int _idx;
  var _now = new DateTime.now();
  var _formatter = new DateFormat('yyyy-MM-dd');

  Future<SitRoutine> _loadSitRoutine() async {
    SitRoutine routine;
    List<SitRoutine> list = await DBHelper().getAllSitRoutine();
    routine = await DBHelper().getSitRoutine(list[0].idx);
    await Future.forEach(list, (element) async {
      if (element.idx == _idx) {
        routine = await DBHelper().getSitRoutine(_idx);
      }
    });
    return routine;
  }

  _loadValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        String formattedDate = _formatter.format(_now);
        _sitRecord = (prefs.getInt('sitRecord') ?? 0);
        _sitTotal = (prefs.getInt('sitTotal') ?? 0);
        _idx = (prefs.getInt('sitIdx') ?? 0);
        _sitDate = formattedDate;
        if (_sitDate != (prefs.getString('sitDate') ?? '')) {
          notToday = true;
          prefs.setString('sitDate', _sitDate);
          prefs.setInt('sitToday', 0);
        }
        _sitToday = (prefs.getInt('sitToday') ?? 0);
      });
    if (notToday) {
      DBHelper()
          .createSitData(Sit(date: _sitDate, countRecord: 0, countLevel: 0));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadValue();
    _loadSitRoutine();
  }

  @override
  Widget build(BuildContext context) {
    _sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xff191C2B),
      appBar: null,
      body: Column(
        children: [
          Text(
            'Sit-Up Trainer',
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
                    'Record : $_sitRecord',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MainFont',
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    'Today : $_sitToday',
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
                  future: _loadSitRoutine(),
                  builder: (context, AsyncSnapshot<SitRoutine> snapshot) {
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
                        moveToSitUp();
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
                      moveToSitUpR();
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
        prefs.setInt('sitIdx', _idx);
      });
    }
  }

  void moveToSitUp() async {
    final count = await Navigator.push(
      this.context,
      CupertinoPageRoute(
        builder: (context) => SitUpScreen(),
        settings: RouteSettings(
            arguments:
                SitRoutine(idx: 0, routine: _setRoutine, time: _setTime)),
      ),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sitToday = (prefs.getInt('sitToday') ?? 0);
      _sitToday += count;
      prefs.setInt('sitToday', _sitToday);
      _sitTotal = (prefs.getInt('sitTotal') ?? 0);
      _sitTotal += count;
      prefs.setInt('sitTotal', _sitTotal);
    });
    Sit _res = await DBHelper().getSit(_sitDate);
    if (_res != null) {
      _res.countLevel += count;
      DBHelper().updateSit(_res);
    } else {
      _res = Sit(countLevel: count, countRecord: 0, date: _sitDate);
      DBHelper().createSitData(_res);
    }
  }

  moveToSitUpR() async {
    final _list = await Navigator.push(
      this.context,
      CupertinoPageRoute(builder: (context) => SitUpScreenR()),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sitToday = (prefs.getInt('sitToday') ?? 0);
      _sitToday += _list[0];
      prefs.setInt('sitToday', _sitToday);
      _sitTotal = (prefs.getInt('sitTotal') ?? 0);
      _sitTotal += _list[0];
      prefs.setInt('sitTotal', _sitTotal);
      if (_list[1] == 0) {
        _sitRecord = (prefs.getInt('sitRecord') ?? 0);
        if (_sitRecord < _list[0]) {
          prefs.setInt('sitRecord', _list[0]);
          _sitRecord = _list[0];
        }
      }
    });
    Sit _res = await DBHelper().getSit(_sitDate);
    if (_res != null) {
      if ((_list[1] == 0) && (_list[0] > _res.countRecord)) {
        _res.countRecord = _list[0];
        DBHelper().updateSit(_res);
      } else {
        _res.countLevel += _list[0];
        DBHelper().updateSit(_res);
      }
    } else {
      if ((_list[1] == 0) && (_list[0] > _res.countRecord)) {
        _res = Sit(countLevel: 0, countRecord: _list[0], date: _sitDate);
        DBHelper().createSitData(_res);
      } else {
        _res = Sit(countLevel: _list[0], countRecord: 0, date: _sitDate);
        DBHelper().createSitData(_res);
      }
    }
  }
}

class SitUpScreen extends StatefulWidget {
  @override
  _SitUpScreen createState() => _SitUpScreen();
}

class _SitUpScreen extends State<SitUpScreen> {
  double _paddingTop;
  double _sizeHeight;
  double _sizeWidth;
  int _count = 0;
  List<double> _gyroscopeValues;
  bool _state = true;
  bool _gyroState = true;
  int _idx = 0;
  int _sumcount = 0;
  int _buildcnt = 0;
  SitRoutine routine;
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        if (_state) {
          _gyroscopeValues = <double>[event.x, event.y, event.z];
          if (_gyroscopeValues[1] < -2.5) {
            if (_gyroState) {
              _routine[_idx]--;
              _sumcount++;
              _gyroState = false;
              if (_routine[_idx] == 0) {
                _idx++;
                if (_idx == _routine.length) {
                  _text = "운동이 종료되었습니다.";
                  _idx--;
                } else {
                  _state = false;
                  dialogScreen();
                }
              }
            }
          } else if (_gyroscopeValues[1] > 2.5) {
            if (_gyroState) {
              _gyroState = true;
            }
          }
        }
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
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
          ],
        ),
        onWillPop: () {},
      ),
    );
  }
}

class SitUpScreenR extends StatefulWidget {
  @override
  _SitUpScreenR createState() => _SitUpScreenR();
}

class _SitUpScreenR extends State<SitUpScreenR> {
  Timer _timer;
  int _time = 5;
  double _paddingTop;
  double _sizeHeight;
  double _sizeWidth;
  int _count = 0;
  List<double> _gyroscopeValues;
  bool _gyroState = true;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  String _text = "";

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];

        if (_gyroscopeValues[1] < -2.5) {
          if (_gyroState) {
            if (_count == 0) {
              startTimer();
            }
            _count++;
            _gyroState = false;
          }
        } else if (_gyroscopeValues[1] > 2.5) {
          if (!_gyroState) {
            _gyroState = true;
          }
        }
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
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
          ],
        ),
        onWillPop: () {},
      ),
    );
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
        future: DBHelper().getAllSitRoutine(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SitRoutine>> snapshot) {
          if (snapshot.hasData) {
            return AlertDialog(
              backgroundColor: Color(0xff191C2B),
              content: SizedBox(
                height: 250,
                width: 280,
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    SitRoutine item = snapshot.data[index];
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
