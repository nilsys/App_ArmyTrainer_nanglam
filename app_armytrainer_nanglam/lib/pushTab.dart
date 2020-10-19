import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_armytrainer_nanglam/sqlite/db_helper.dart';
import 'package:app_armytrainer_nanglam/sqlite/models/models.dart';
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
  double _sizeWidth;
  int _pushRecord = 0;
  int _pushTotal = 0;
  int _pushLevel = 0;
  int _pushToday = 0;
  int _idx;
  String exception;
  PushRoutine _routine = PushRoutine(idx: 0, routine: '', time: 0);
  String _pushDate = '';
  var _now = new DateTime.now();
  var _formatter = new DateFormat('yyyy-MM-dd');

  Future<PushRoutine> _loadRoutine() async {
    List list = await _fetchList();
    if (list.length > 0) {
      for (var i = 0; i < list.length; i++) {
        if (list[i].idx == _idx) {
          return await DBHelper().getPushRoutine(_idx);
        }
      }
      _idx = list[0].idx;
      return await DBHelper().getPushRoutine(_idx);
    }
  }

  Future<List> _fetchList() {
    return DBHelper().getAllPushRoutine();
  }

  _loadValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        String formattedDate = _formatter.format(_now);
        _pushRecord = (prefs.getInt('pushRecord') ?? 0);
        _pushTotal = (prefs.getInt('pushTotal') ?? 0);
        _pushLevel = (prefs.getInt('pushLevel') ?? 0);
        _idx = (prefs.getInt('pushIdx') ?? 0);
        _pushDate = formattedDate;
        if (_pushDate != (prefs.getString('pushDate') ?? '')) {
          print(_pushToday);
          prefs.setString('pushDate', _pushDate);
          prefs.setInt('pushToday', 0);
          DBHelper().createPushData(
              Push(date: _pushDate, countRecord: 0, countLevel: 0));
        }
        _pushToday = (prefs.getInt('pushToday') ?? 0);
      });
  }

  @override
  void initState() {
    super.initState();
    _loadValue();
    _loadRoutine();
  }

  @override
  Widget build(BuildContext context) {
    _sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
                  future: _loadRoutine(),
                  builder: (context, AsyncSnapshot<PushRoutine> snapshot) {
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
                      moveToPushUp();
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
        prefs.setInt('pushIdx', idx);
      });
      _routine = await DBHelper().getPushRoutine(_idx);
    }
  }

  void moveToPushUp() async {
    if (_routine != null) {
      final count = await Navigator.push(
        this.context,
        CupertinoPageRoute(
          builder: (context) => PushUpScreen(),
          settings: RouteSettings(arguments: _routine),
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
      _res.countLevel += count;
      DBHelper().updatePush(_res);
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
    if ((_list[1] == 0) && (_list[0] > _res.countRecord) && (_res != null)) {
      _res.countRecord = _list[0];
      DBHelper().updatePush(_res);
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
                        width: 90,
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
  int _time = 5;
  double _paddingTop;
  double _sizeHeight;
  double _sizeWidth;
  int _count = 0;
  bool _proximityValues = false;
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
      setState(() {
        _proximityValues = event.getValue();
        if (_proximityValues == true) {
          if (_count == 0) {
            startTimer();
          }
          _count++;
        }
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
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
