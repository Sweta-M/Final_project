import 'dart:ui';

import 'package:ds_learner/MCQ.dart';
import 'package:flutter/material.dart';
import 'getImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Learning extends StatefulWidget {
  final String topic;
  const Learning({Key? key,required this.topic}) : super(key: key);

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {

  int position=0;
  List images=[];
  final Storage storage=Storage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
          title: Text('Learning',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.black)),
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
                SizedBox(height: 30,),
                Text('${widget.topic} FlashCards',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 100,),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      setState(() {
                        // Swiping in right direction.
                        if (details.primaryVelocity! > 0) {position=increase();}

                        // Swiping in left direction.
                        if (details.primaryVelocity! < 0) {position=decrease();}
                      });
                    },
                  child: Container(
                    height: 280,
                    width: 280,
                    color: Colors.white,
                    child: FutureBuilder(
                        future: storage.downloadURL(images[position]["link"]),
                        builder: (context,snapshot){
                          if(snapshot.connectionState==ConnectionState.done){
                            return Container(
                              width: 200,
                              height: 200,
                              child: Image.network(
                                snapshot.data.toString(),
                                fit: BoxFit.scaleDown,
                              ),
                            );
                          }
                          if(snapshot.connectionState==ConnectionState.waiting)
                          {
                            return CircularProgressIndicator();
                          }
                          throw Exception('No image');
                        }),
                  ),
                ),
                ),
                SizedBox(height: 100,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: (){Navigator.pushReplacement(context,MaterialPageRoute(builder: ((context) => Mcq(topic: widget.topic))));},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Continue to assessments',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0XFF914333), decoration: TextDecoration.underline),),
                        Icon(Icons.arrow_forward,color: Colors.redAccent,)
                      ],
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
  int decrease() {
    position=(position+1)%images.length;
    return position;
  }
  int increase() {
    position=(position+images.length-1)%images.length;
    return position;
  }

  void getMaterials() async{
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Flashcards")
        .where("topic",isEqualTo: widget.topic)
        .get();
    setState(() {
      images.addAll(snap.docs);
    });
  }
}
