import 'package:flutter/material.dart';

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
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: list.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191C2B),
      appBar: null,
      body: Column(children: [
        SizedBox(height: 50),
        Row(
          children: [
            SizedBox(
              width: 40,
              height: 50,
            ),
            IconButton(
              icon: Icon(
                Icons.list,
                color: Colors.white,
              ),
              onPressed: null,
            ),
            Expanded(
              flex: 1,
              child: SizedBox(height: 35),
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
            ),
          ],
        ),
        SizedBox(height: 35),
        SizedBox(
          width: 300,
          height: 475,
          child: TabBarView(
            controller: _tabController,
            children: [
              Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MainFont',
                  fontSize: 24,
                ),
              ),
              Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MainFont',
                  fontSize: 24,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 70),
      ]),
    );
  }
}
