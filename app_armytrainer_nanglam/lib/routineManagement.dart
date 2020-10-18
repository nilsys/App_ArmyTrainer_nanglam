import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sqlite/db_helper.dart';
import 'sqlite/models/models.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutineManagement extends StatefulWidget {
  @override
  _RoutineManagement createState() => _RoutineManagement();
}

class _RoutineManagement extends State<RoutineManagement> {
  double _sizeWidth;
  double _sizeHeight;
  int _indexPush;
  int _indexSit;

  _loadValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _indexPush = (prefs.getInt('indexPush') ?? 0);
      _indexSit = (prefs.getInt('indexSit') ?? 0);
    });
  }

  _savePushValue(int indexPush) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('indexPush', indexPush);
    });
  }

  _saveSitValue(int indexSit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('indexSit', indexSit);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  @override
  Widget build(BuildContext context) {
    _sizeHeight = MediaQuery.of(context).size.height;
    _sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff191C2B),
      appBar: AppBar(
        backgroundColor: Color(0xff191C2B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
        title: Text(
          'Edit Routine',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MainFont',
            fontSize: 24,
          ),
        ),
      ),
      body: WillPopScope(
        child: Column(children: [
          SizedBox(height: _sizeHeight * 0.045),
          Row(
            children: [
              SizedBox(width: _sizeWidth * 0.045),
              Stack(
                overflow: Overflow.visible,
                children: [
                  Text(
                    'Push-Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MainFont',
                      fontSize: 30,
                    ),
                  ),
                  Positioned(
                    left: 115,
                    bottom: 0,
                    child: Text(
                      '(SETㅣRest)',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: SizedBox(width: 10),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  dialogPushScreen();
                  setState(() {});
                },
              ),
              SizedBox(width: _sizeWidth * 0.045),
            ],
          ),
          Divider(
            color: Colors.white.withOpacity(0.6),
            height: 20,
            thickness: 1,
            indent: _sizeWidth * 0.045,
            endIndent: _sizeWidth * 0.045,
          ),
          SizedBox(
            height: _sizeHeight * 0.300,
            child: FutureBuilder(
              future: DBHelper().getAllPushRoutine(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PushRoutine>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      PushRoutine item = snapshot.data[index];
                      _savePushValue(item.idx);
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          DBHelper().deletePushRoutine(item.idx);
                          setState(() {});
                        },
                        child: ListTile(
                          leading: Text(
                            index.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'MainFont',
                              fontSize: 28,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                item.routine,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'MainFont',
                                  fontSize: 28,
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
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.clear),
                            color: Colors.redAccent,
                            onPressed: () {
                              DBHelper().deletePushRoutine(item.idx);
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Row(
            children: [
              SizedBox(width: _sizeWidth * 0.045),
              Stack(
                overflow: Overflow.visible,
                children: [
                  Text(
                    'Sit-Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MainFont',
                      fontSize: 30,
                    ),
                  ),
                  Positioned(
                    left: 115,
                    bottom: 0,
                    child: Text(
                      '(SETㅣRest)',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: SizedBox(width: 10),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white, size: 30),
                onPressed: () {
                  dialogSitScreen();
                  setState(() {});
                },
              ),
              SizedBox(width: _sizeWidth * 0.045),
            ],
          ),
          Divider(
            color: Colors.white.withOpacity(0.6),
            height: 20,
            thickness: 1,
            indent: _sizeWidth * 0.045,
            endIndent: _sizeWidth * 0.045,
          ),
          SizedBox(
            height: _sizeHeight * 0.300,
            child: FutureBuilder(
              future: DBHelper().getAllSitRoutine(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<SitRoutine>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      SitRoutine item = snapshot.data[index];
                      _saveSitValue(item.idx);
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          DBHelper().deletePushRoutine(item.idx);
                          setState(() {
                            dialogSitScreen();
                            setState(() {});
                          });
                        },
                        child: ListTile(
                          leading: Text(
                            index.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'MainFont',
                              fontSize: 28,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                item.routine,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'MainFont',
                                  fontSize: 28,
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
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.clear),
                            color: Colors.redAccent,
                            onPressed: () {
                              DBHelper().deleteSitRoutine(item.idx);
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ]),
        onWillPop: () {},
      ),
    );
  }

  void dialogPushScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _indexPush = (prefs.getInt('indexPush') ?? 0);
    });
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return PushEDialog(_indexPush);
        });
  }

  void dialogSitScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _indexSit = (prefs.getInt('indexSit') ?? 0);
    });
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return SitEDialog(_indexSit);
        });
  }
}

class PushEDialog extends StatefulWidget {
  int _index;
  PushEDialog(int index) {
    this._index = index;
  }
  @override
  _PushEDialog createState() => new _PushEDialog(_index);
}

class _PushEDialog extends State<PushEDialog> {
  final _routineController = TextEditingController();
  final _timeController = TextEditingController();
  String _saveRoutine;
  bool _check = false;
  int _index;

  _PushEDialog(int index) {
    this._index = index;
  }

  @override
  void dispose() {
    _routineController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  _checkValue() {
    _saveRoutine = '';
    if (_routineController.text != '') {
      List _tmp = _routineController.text.split('-');
      _tmp.forEach((element) {
        if (element != '' && element != 0) {
          if (int.parse(element) == 0) {
            return;
          } else {
            _saveRoutine += element.toString();
            _saveRoutine += '-';
          }
        }
      });
      if (_saveRoutine.length > 1) {
        _saveRoutine = _saveRoutine.substring(0, _saveRoutine.length - 1);
      }
    }
    if (_saveRoutine == '') {
      return;
    }
    if (_timeController.text == null) {
      return;
    }
    if (int.parse(_timeController.text) == 0) {
      return;
    }
    if (_routineController.text != '' && _timeController.text != '') {
      _check = true;
    }
  }

  _saveValue() async {
    PushRoutine pushRoutine = new PushRoutine(
        idx: _index + 1,
        routine: _saveRoutine,
        time: int.parse(_timeController.text));
    DBHelper().createPushRoutineData(pushRoutine);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: AlertDialog(
        backgroundColor: Color(0xff191C2B),
        title: Text(
          'Add Routine (Push)',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MainFont',
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          height: 175,
          child: Column(
            children: [
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9-]*')),
                ],
                controller: _routineController,
                decoration: InputDecoration(
                  hintText: '1-2-3-4-5',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontFamily: 'MainFont',
                    fontSize: 18,
                  ),
                  labelText: 'Routine',
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
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                controller: _timeController,
                decoration: InputDecoration(
                  hintText: '30',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontFamily: 'MainFont',
                    fontSize: 18,
                  ),
                  labelText: 'Time',
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
            ],
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.clear, color: Colors.redAccent),
              onPressed: () {
                Navigator.pop(context);
              }),
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

class SitEDialog extends StatefulWidget {
  int _index;
  SitEDialog(int index) {
    this._index = index;
  }
  @override
  _SitEDialog createState() => new _SitEDialog(_index);
}

class _SitEDialog extends State<SitEDialog> {
  final _routineController = TextEditingController();
  final _timeController = TextEditingController();
  String _saveRoutine;
  bool _check = false;
  int _index;

  _SitEDialog(int index) {
    this._index = index;
  }

  @override
  void dispose() {
    _routineController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  _checkValue() {
    _saveRoutine = '';
    if (_routineController.text != '') {
      List _tmp = _routineController.text.split('-');
      _tmp.forEach((element) {
        if (element != '' && element != 0) {
          if (int.parse(element) == 0) {
            return;
          } else {
            _saveRoutine += element.toString();
            _saveRoutine += '-';
          }
        }
      });
      if (_saveRoutine.length > 1) {
        _saveRoutine = _saveRoutine.substring(0, _saveRoutine.length - 1);
      }
    }
    if (_saveRoutine == '') {
      return;
    }
    if (_timeController.text == null) {
      return;
    }
    if (int.parse(_timeController.text) == 0) {
      return;
    }
    if (_routineController.text != '' && _timeController.text != '') {
      _check = true;
    }
  }

  _saveValue() async {
    SitRoutine sitRoutine = new SitRoutine(
        idx: _index + 1,
        routine: _saveRoutine,
        time: int.parse(_timeController.text));
    DBHelper().createSitRoutineData(sitRoutine);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: AlertDialog(
        backgroundColor: Color(0xff191C2B),
        title: Text(
          'Add Routine (Push)',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'MainFont',
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          height: 175,
          child: Column(
            children: [
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9-]*')),
                ],
                controller: _routineController,
                decoration: InputDecoration(
                  hintText: '1-2-3-4-5',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontFamily: 'MainFont',
                    fontSize: 18,
                  ),
                  labelText: 'Routine',
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
              TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                controller: _timeController,
                decoration: InputDecoration(
                  hintText: '30',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontFamily: 'MainFont',
                    fontSize: 18,
                  ),
                  labelText: 'Time',
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
            ],
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.clear, color: Colors.redAccent),
              onPressed: () {
                Navigator.pop(context);
              }),
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
