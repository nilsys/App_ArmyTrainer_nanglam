import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_armytrainer_nanglam/sqlite/db_helper.dart';
import 'package:app_armytrainer_nanglam/sqlite/models/models.dart';

class SitTab extends StatefulWidget {
  @override
  _SitTab createState() => _SitTab();
}

class _SitTab extends State<SitTab> {
  double _sizeWidth;

  @override
  Widget build(BuildContext context) {
    _sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    'Record : 82',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MainFont',
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    'Today : 30',
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
              IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: null),
              SizedBox(
                width: _sizeWidth * 0.125,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '15-20-30-40-6',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MainFont',
                  fontSize: 30,
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
                    onPressed: null,
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
                    onPressed: null,
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
}
