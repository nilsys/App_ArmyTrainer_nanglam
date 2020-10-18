import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoutineManagement extends StatefulWidget {
  @override
  _RoutineManagement createState() => _RoutineManagement();
}

class _RoutineManagement extends State<RoutineManagement> {
  double _sizeWidth;
  double _sizeHeight;
  @override
  Widget build(BuildContext context) {
    _sizeHeight = MediaQuery.of(context).size.height;
    _sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
              Text(
                'Push-Up',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MainFont',
                  fontSize: 30,
                ),
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
                onPressed: () {},
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
              child: ListView(
                children: [
                  ListTile(
                    leading: Text(
                      ' 0',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 28,
                      ),
                    ),
                    title: Text(
                      '20-30-45-80-95 ㅣ 30',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 28,
                      ),
                    ),
                    trailing: Icon(
                      Icons.clear,
                      color: Colors.redAccent,
                    ),
                  )
                ],
              )),
          Row(
            children: [
              SizedBox(width: _sizeWidth * 0.045),
              Text(
                'Sit-Up',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MainFont',
                  fontSize: 30,
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(width: 10),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white, size: 30),
                onPressed: () {},
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
              child: ListView(
                children: [
                  ListTile(
                    leading: Text(
                      ' 0',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 28,
                      ),
                    ),
                    title: Text(
                      '2-5-67-5-2 ㅣ 30',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MainFont',
                        fontSize: 28,
                      ),
                    ),
                    trailing: Icon(
                      Icons.clear,
                      color: Colors.redAccent,
                    ),
                  )
                ],
              )),
        ]),
        onWillPop: () {},
      ),
    );
  }
}
