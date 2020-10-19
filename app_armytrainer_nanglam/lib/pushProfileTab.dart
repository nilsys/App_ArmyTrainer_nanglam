import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_armytrainer_nanglam/sqlite/db_helper.dart';
import 'package:app_armytrainer_nanglam/sqlite/models/models.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class PushProfile extends StatefulWidget {
  @override
  _PushProfile createState() => _PushProfile();
}

class _PushProfile extends State<PushProfile> {
  double _sizeWidth;
  double _sizeHeight;
  int _pushTotal = 0;
  int _pushToday = 0;
  String _pushDate = '';
  var _now = new DateTime.now();
  var _formatter = new DateFormat('yyyy-MM-dd');

  _loadValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        String formattedDate = _formatter.format(_now);
        _pushTotal = (prefs.getInt('pushTotal') ?? 0);
        _pushDate = formattedDate;
        if (_pushDate != (prefs.getString('pushDate') ?? '')) {
          prefs.setString('pushDate', _pushDate);
          prefs.setInt('pushToday', 0);
        }
        _pushToday = (prefs.getInt('pushToday') ?? 0);
      });
  }

  // Future<Push> _fetchPush() {
  //   return await DBHelper().getPush(_pushDate);
  // }

  // _loadToday() async {
  //   Future<Push> push = await _fetchPush();
  // }

  @override
  void initState() {
    super.initState();
    _loadValue();
    //_loadToday();
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
                'Total : $_pushTotal',
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
                'Today : $_pushToday',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MainFont',
                  fontSize: 24,
                ),
              ),
            ],
          ),
          Stack(
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
                      maxY: 20,
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
                                return '6';
                              case 1:
                                return '7';
                              case 2:
                                return '8';
                              case 3:
                                return '9';
                              case 4:
                                return '10';
                              case 5:
                                return '11';
                              case 6:
                                return '12';
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
                              y: 8,
                              colors: [
                                Color(0xffE32A51),
                                Colors.red,
                                Colors.redAccent,
                              ],
                              rodStackItems: [
                                BarChartRodStackItem(0, 3, Colors.red),
                                BarChartRodStackItem(3, 8, Colors.yellow)
                              ],
                            ),
                          ],
                          showingTooltipIndicators: [0],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(y: 10, colors: [
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
                            BarChartRodData(y: 14, colors: [
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
                            BarChartRodData(y: 1, colors: [
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
                            BarChartRodData(y: 13, colors: [
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
                            BarChartRodData(y: 10, colors: [
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
                            BarChartRodData(y: 2, colors: [
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
              Positioned(
                right: 10,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
