import 'dart:ui';

import 'package:flutter/material.dart';

class DemoNewLevel extends StatefulWidget {
  const DemoNewLevel({Key? key}) : super(key: key);

  @override
  State<DemoNewLevel> createState() => _DemoNewLevelState();
}

class _DemoNewLevelState extends State<DemoNewLevel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
          title: Text(' ',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.black)),
        ) ,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFD16BA5),
                      Color(0xFF86A8E7),
                      Color(0xFF5FFBF1)
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft
                )
            ),
          ),
          Column(
            children: [
              SizedBox(height: 100,),
              Center(
                child: Text("Next Level Topics.",
                  style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white),),
              ),
              SizedBox(height: 100,),
              Icon(Icons.list_alt_sharp, color: Colors.white,size: 200,),
            ],
          )
        ],
      ),
    );
  }
}
