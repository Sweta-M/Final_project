import 'package:flutter/material.dart';

class Shapes_game_1 extends StatefulWidget {
  const Shapes_game_1({Key? key}) : super(key: key);

  @override
  State<Shapes_game_1> createState() => _Shapes_game_1State();
}

class _Shapes_game_1State extends State<Shapes_game_1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Draggable<String>(
                  // Data is the value this Draggable stores.
                  data: 'ball',
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    child: Center(
                      child: Icon(Icons.sports_baseball, color: Colors.red,size: 100,),
                    ),
                  ),
                  feedback: Container(
                    height: 120.0,
                    width: 120.0,
                    child: Center(
                      child: Icon(Icons.sports_baseball, color: Colors.red,size: 100,),
                    ),
                  ),
                  childWhenDragging: Container(),
                ),
                DragTarget<String>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ){
                    return Container(
                      child: Container()
                    );
                  },
                  onWillAccept: (data){
                    return data=='ball';
                  },
                ),
              ],
            ),
          ),
        )
    );
  }
}
