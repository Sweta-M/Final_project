import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ds_learner/DemoTopic.dart';
import 'package:ds_learner/Drawing.dart';
import 'package:ds_learner/Shapes/Shapes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'DemoNewLevel.dart';

class Academics extends StatefulWidget {
  const Academics({Key? key}) : super(key: key);

  @override
  State<Academics> createState() => _AcademicsState();
}

class _AcademicsState extends State<Academics> {

  List Topics = ['Studies','Drawing'];
  List pages = [Shapes(topic: 'shapes',),
                Drawing()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
          title: Text('ACADEMICS',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.black)),
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
                Container(
                    height: 200,
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String name = prefs.getString("username").toString();
                        firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                        FirebaseFirestore.instance.collection('User').doc(name).get()
                            .then((value) {
                        setState(() async {
                          if(value.data()!["current_topic"]!="higher_level"){
                              String downloadURL=await storage.ref().child("Animations/${value.data()!["current_topic"]}.mp4").getDownloadURL();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => DemoTopic(
                                          topic: value
                                              .data()!["current_topic"], path: downloadURL,))));
                            }
                          else{
                            //If child completes this level, he/she moves on to the next level having new topics
                            //As of now a template
                            print(".......!!!!!!!!!!!..............!!!!!!!!");
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DemoNewLevel(),));
                          }
                          });
                        });
                        // Navigator.push(context,MaterialPageRoute(builder: (context) => DemoTopic(topic: "Shapes",),));
                        },
                      child : Card(
                        child: Row(
                          children: [
                            Icon(Icons.bubble_chart, color: Color(0xFF519E71),),
                            Text("Studies",style: TextStyle(fontSize: 30, color: Color(0xFF519E71)),),
                            Icon(Icons.arrow_forward_ios,size: 30,)
                          ],
                        ),
                        elevation: 40,
                        margin: EdgeInsets.all(20),
                        color: Colors.white,
                      ),
                    )
                ),
                SizedBox(height: 100,),
                Container(
                    height: 200,
                    child: GestureDetector(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: ((context) => Drawing())));},
                      child : Card(
                        child: Row(
                          children: [
                            Icon(Icons.bubble_chart, color: Color(0xFF519E71),),
                            Text("Drawing",style: TextStyle(fontSize: 30, color: Color(0xFF519E71)),),
                            Icon(Icons.arrow_forward_ios,size: 30,)
                          ],
                        ),
                        elevation: 40,
                        margin: EdgeInsets.all(20),
                        color: Colors.white,
                      ),
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}