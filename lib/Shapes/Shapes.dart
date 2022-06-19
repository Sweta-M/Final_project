
import 'package:ds_learner/DragDrop.dart';
import 'package:ds_learner/Shapes/Shapes_flash.dart';
import 'package:flutter/material.dart';

class Shapes extends StatefulWidget {
  final String topic;
  const Shapes({Key? key,required this.topic}) : super(key: key);

  @override
  State<Shapes> createState() => _ShapesState();
}

class _ShapesState extends State<Shapes> {

  late String topic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    topic=widget.topic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
          title: Text(widget.topic,style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.black)),
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
              SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                        child : Container(
                          height: MediaQuery.of(context).size.height*0.35,
                          width: MediaQuery.of(context).size.width*0.85,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Shapes_flash()));
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  Image(image: AssetImage("assets/flashcard.jpg"),
                                    width: MediaQuery.of(context).size.width*0.75,
                                    height: MediaQuery.of(context).size.height*0.3,),
                                  Text('FLASH CARDS',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          )
                        )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.05),
                    Center(
                        child : Container(
                          height: MediaQuery.of(context).size.height*0.35,
                          width: MediaQuery.of(context).size.width*0.85,
                          child: GestureDetector(
                            onTap: (){
                                  //Navigator.pushNamed(context, 'drag_drop',arguments: topic);
                              //Navigator.push(context, MaterialPageRoute(builder: ((context) => DragDrop(topic: widget.topic))));
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  Image(image: AssetImage("assets/worksheet.jpg"),
                                    width: MediaQuery.of(context).size.width*0.75,
                                    height: MediaQuery.of(context).size.height*0.3,),
                                  Text('WORKSHEETS',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          )
                        )
                    )
                  ],
                ),
              ),
            ],
        )
    );
  }
}
