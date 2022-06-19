
import 'dart:ui';

import 'package:flutter/material.dart';

class Drawing extends StatefulWidget {
  const Drawing({Key? key}) : super(key: key);

  @override
  State<Drawing> createState() => _DrawingState();
}

class _DrawingState extends State<Drawing> {

  List<Offset> points = <Offset>[];
  DateTime now=DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.close),
        onPressed: () {
          points.clear();
        },
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
          title: Text('DRAWING BOARD',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFFD16BA5),
              Color(0xFF86A8E7),
              Color(0xFF5FFBF1)
            ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: 40),
                Text('Draw inside the box \n', style: TextStyle(fontSize: 20),),
                SizedBox(height: 2),
                Container(
                  height: MediaQuery.of(context).size.height*0.7,
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2.0)
                  ),
                  child: GestureDetector(
                    onPanUpdate: (DragUpdateDetails details){
                      Offset localPosition = details.localPosition;
                      print(now.hour.toString()+' : '+now.minute.toString());
                      setState(() {
                        if(localPosition.dx >=0 &&
                        localPosition.dx<=MediaQuery.of(context).size.width*0.9 &&
                        localPosition.dy >= 0 &&
                        localPosition.dy <= MediaQuery.of(context).size.height*0.7){
                          points.add(localPosition);
                        }
                      });
                    },
                    onPanEnd: (DragEndDetails details){
                      points.add(Offset.infinite);
                    },
                    child: CustomPaint(
                      painter: Painter(points: points),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Painter extends CustomPainter {
  late final List<Offset> points;
  Painter({required this.points});

  final Paint paintDetails = Paint()
  ..style= PaintingStyle.stroke
  ..strokeWidth=4.0
  ..color=Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    for(int i=0;i<points.length -1;i++){
      if(points[i]!=Offset.infinite && points[i+1]!=Offset.infinite){
        canvas.drawLine(points[i], points[i+1], paintDetails);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
