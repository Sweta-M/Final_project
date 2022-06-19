import 'package:flutter/material.dart';

class Shapes_flash extends StatefulWidget {
  const Shapes_flash({Key? key}) : super(key: key);

  @override
  State<Shapes_flash> createState() => _Shapes_flashState();
}

class _Shapes_flashState extends State<Shapes_flash> {

  List images = [
    'assets/shapes/circle.jpg',
    'assets/shapes/square.png' ,
    'assets/shapes/triangle.png'
  ];
  List image_name = [
    'CIRCLE','SQUARE','TRIANGLE'
  ];
  int position=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Color(0XFFEB972A),
            title: Text('SHAPES',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.black)),
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
            Center(
              child: Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        setState(() {
                          position=decrease();
                        });
                      },
                      child:Icon(Icons.keyboard_arrow_left_rounded)
                  ),
                  GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      setState(() {
                        // Swiping in right direction.
                        if (details.primaryVelocity! > 0) {position=increase();}

                        // Swiping in left direction.
                        if (details.primaryVelocity! < 0) {position=decrease();}
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.5,
                      width: MediaQuery.of(context).size.width*0.85,
                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height*0.03),
                            Image(image: AssetImage(images[position]),
                              width: MediaQuery.of(context).size.width*0.75,
                              height: MediaQuery.of(context).size.height*0.3,),
                            SizedBox(height: MediaQuery.of(context).size.height*0.1),
                            Text(image_name[position],style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        position=increase();
                      });
                    },
                    child: Icon(Icons.keyboard_arrow_right_rounded),
                  ),
                ],
              )
            ),
          ],
        )
    );
  }

  int decrease() {
    position=(position+1)%images.length;
    return position;
  }
  int increase() {
    position=(position+images.length-1)%images.length;
    return position;
  }
}
