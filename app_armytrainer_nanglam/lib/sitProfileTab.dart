import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_armytrainer_nanglam/sqlite/db_helper.dart';
import 'package:app_armytrainer_nanglam/sqlite/models/models.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class SitProfile extends StatefulWidget {
  @override
  _SitProfile createState() => _SitProfile();
}

class _SitProfile extends State<SitProfile> {
  double _sizeWidth;
  double _sizeHeight;
  int _sitTotal = 0;
  int _sitToday = 0;
  String _sitDate = '';
  int _max;
  var _date;
  var _now = DateTime.now();
  var _formatter = new DateFormat('yyyy-MM-dd');

  Future<List<Sit>> _loadSit(DateTime _date) async {
    List<String> list = List<String>();
    List<Sit> sitList = List<Sit>();
    _max = 0;
    if (_now == _date) {
      for (var i = -6; i < 1; i++) {
        list.add(
            _formatter.format(DateTime(_date.year, _date.month, _date.day + i))
                as String);
      }
      await Future.forEach(list, (element) async {
        Sit sit = (await DBHelper().getSit(element) ?? null);
        if (sit != null) {
          sitList.add(sit);
          if (_max < sit.countLevel + sit.countRecord) {
            _max = sit.countLevel + sit.countRecord;
          }
        } else {
          sitList.add(Sit(countLevel: 0, countRecord: 0, date: element));
        }
      });
      return sitList;
    } else {
      for (var i = -3; i < 4; i++) {
        list.add(
            _formatter.format(DateTime(_date.year, _date.month, _date.day + i))
                as String);
      }
      await Future.forEach(list, (element) async {
        Sit sit = (await DBHelper().getSit(element) ?? null);
        if (sit != null) {
          sitList.add(sit);
          if (_max < sit.countLevel + sit.countRecord) {
            _max = sit.countLevel + sit.countRecord;
          }
        } else {
          sitList.add(Sit(countLevel: 0, countRecord: 0, date: element));
        }
      });
      return sitList;
    }
  }

  String _dateToDate(String date) {
    List list = date.split('-');
    return list[2];
  }

  _loadValue() async {
    _date = _now;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        String formattedDate = _formatter.format(_now);
        _sitTotal = (prefs.getInt('sitTotal') ?? 0);
        _sitDate = formattedDate;
        if (_sitDate != (prefs.getString('sitDate') ?? '')) {
          prefs.setString('sitDate', _sitDate);
          prefs.setInt('sitToday', 0);
        }
        _sitToday = (prefs.getInt('sitToday') ?? 0);
      });
  }

  @override
  void initState() {
    super.initState();
    _loadValue();
  }

  @override
  Widget build(BuildContext context) {
    _sizeWidth = MediaQuery.of(context).size.width;
    _sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff191C2B),
      appBar: null,
      body: Column(
        children: [
          SizedBox(height: _sizeHeight * 0.045),
          Row(
            children: [
              SizedBox(width: _sizeWidth * 0.045),
              Text(
                'Total : $_sitTotal',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MainFont',
                  fontSize: 24,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: _sizeWidth * 0.045),
              Text(
                'Today : $_sitToday',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MainFont',
                  fontSize: 24,
                ),
              ),
              Expanded(
                  child: SizedBox(
                width: 10,
              )),
              IconButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2020, 1, 1),
                      maxTime: _now,
                      theme: DatePickerTheme(
                          headerColor: Color(0xff191C2B),
                          backgroundColor: Color(0xff191C2B),
                          itemStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          cancelStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
                      onConfirm: (date) {
                    setState(() {
                      _date = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.ko);
                },
                icon: Icon(Icons.calendar_today, color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: _loadSit(_date),
            builder: (BuildContext context, AsyncSnapshot<List<Sit>> snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.7,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          color: const Color(0xff191C2B),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: _max.toDouble(),
                              barTouchData: BarTouchData(
                                enabled: false,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.transparent,
                                  tooltipPadding: const EdgeInsets.all(0),
                                  tooltipBottomMargin: 8,
                                  getTooltipItem: (
                                    BarChartGroupData group,
                                    int groupIndex,
                                    BarChartRodData rod,
                                    int rodIndex,
                                  ) {
                                    return BarTooltipItem(
                                      rod.y.round().toString(),
                                      TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  getTextStyles: (value) => const TextStyle(
                                      color: Color(0xff7589a2),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                  margin: 20,
                                  getTitles: (double value) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return _dateToDate(
                                                snapshot.data[0].date) +
                                            '일';
                                      case 1:
                                        return _dateToDate(
                                                snapshot.data[1].date) +
                                            '일';
                                      case 2:
                                        return _dateToDate(
                                                snapshot.data[2].date) +
                                            '일';
                                      case 3:
                                        return _dateToDate(
                                                snapshot.data[3].date) +
                                            '일';
                                      case 4:
                                        return _dateToDate(
                                                snapshot.data[4].date) +
                                            '일';
                                      case 5:
                                        return _dateToDate(
                                                snapshot.data[5].date) +
                                            '일';
                                      case 6:
                                        return _dateToDate(
                                                snapshot.data[6].date) +
                                            '일';
                                      default:
                                        return '';
                                    }
                                  },
                                ),
                                leftTitles: SideTitles(showTitles: false),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      y: (snapshot.data[0].countLevel +
                                              snapshot.data[0].countRecord)
                                          .toDouble(),
                                      colors: [
                                        Color(0xffE32A51),
                                        Colors.red,
                                        Colors.redAccent,
                                      ],
                                    ),
                                  ],
                                  showingTooltipIndicators: [0],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                        y: (snapshot.data[1].countLevel +
                                                snapshot.data[1].countRecord)
                                            .toDouble(),
                                        colors: [
                                          Color(0xffE32A51),
                                          Colors.red,
                                          Colors.redAccent,
                                        ])
                                  ],
                                  showingTooltipIndicators: [0],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                        y: (snapshot.data[2].countLevel +
                                                snapshot.data[2].countRecord)
                                            .toDouble(),
                                        colors: [
                                          Color(0xffE32A51),
                                          Colors.red,
                                          Colors.redAccent,
                                        ])
                                  ],
                                  showingTooltipIndicators: [0],
                                ),
                                BarChartGroupData(
                                  x: 3,
                                  barRods: [
                                    BarChartRodData(
                                        y: (snapshot.data[3].countLevel +
                                                snapshot.data[3].countRecord)
                                            .toDouble(),
                                        colors: [
                                          Color(0xffE32A51),
                                          Colors.red,
                                          Colors.redAccent,
                                        ])
                                  ],
                                  showingTooltipIndicators: [0],
                                ),
                                BarChartGroupData(
                                  x: 4,
                                  barRods: [
                                    BarChartRodData(
                                        y: (snapshot.data[4].countLevel +
                                                snapshot.data[4].countRecord)
                                            .toDouble(),
                                        colors: [
                                          Color(0xffE32A51),
                                          Colors.red,
                                          Colors.redAccent,
                                        ])
                                  ],
                                  showingTooltipIndicators: [0],
                                ),
                                BarChartGroupData(
                                  x: 5,
                                  barRods: [
                                    BarChartRodData(
                                        y: (snapshot.data[5].countLevel +
                                                snapshot.data[5].countRecord)
                                            .toDouble(),
                                        colors: [
                                          Color(0xffE32A51),
                                          Colors.red,
                                          Colors.redAccent,
                                        ])
                                  ],
                                  showingTooltipIndicators: [0],
                                ),
                                BarChartGroupData(
                                  x: 6,
                                  barRods: [
                                    BarChartRodData(
                                        y: (snapshot.data[6].countLevel +
                                                snapshot.data[6].countRecord)
                                            .toDouble(),
                                        colors: [
                                          Color(0xffE32A51),
                                          Colors.red,
                                          Colors.redAccent,
                                        ])
                                  ],
                                  showingTooltipIndicators: [0],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
              return Center();
            },
          ),
        ],
      ),
    );
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
