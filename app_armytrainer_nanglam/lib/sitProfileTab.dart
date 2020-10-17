import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SitProfile extends StatefulWidget {
  @override
  _SitProfile createState() => _SitProfile();
}

class _SitProfile extends State<SitProfile> {
  double _sizeWidth;
  double _sizeHeight;

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
                'Total : 328',
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
                'Today : 148',
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
                        enabled: true,
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
                                return 'Mn';
                              case 1:
                                return 'Te';
                              case 2:
                                return 'Wd';
                              case 3:
                                return 'Tu';
                              case 4:
                                return 'Fr';
                              case 5:
                                return 'St';
                              case 6:
                                return 'Sn';
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
                          x: 6,
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
                          x: 0,
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
                          x: 1,
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
                          x: 2,
                          barRods: [
                            BarChartRodData(y: 15, colors: [
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
                            BarChartRodData(y: 13, colors: [
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
                            BarChartRodData(y: 10, colors: [
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
