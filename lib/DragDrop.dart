import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:ds_learner/Cheer.dart';
import 'package:ds_learner/CountDownTimer.dart';
import 'package:ds_learner/FixedTimer.dart';
import 'package:ds_learner/getImage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class DragDrop extends StatefulWidget {
  final String topic;
  const DragDrop({Key? key,required this.topic}) : super(key: key);
  

  @override
  State<DragDrop> createState() => _DragDropState();
}

class _DragDropState extends State<DragDrop> {

  Map<String,bool> score ={};
  List<DocumentSnapshot> data=[];
  final random=new Random();
  int marks = 0;
  final Storage storage=Storage();
  final Map<String,String> choices={};
  String ans="shapes";
  int correct=0;
  late int currentTime;
  bool flag=false;
  FixedTimer ft=FixedTimer();

  //late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    currentTime=30;
    ft.startTime();
    Timer.periodic(Duration(seconds: 1), (timer){
      if(ft.time==0){
        setData(widget.topic, marks, 99);
        showSnackBar(context, "Time Up!!", Colors.red);
        _nav_to_next(1000);
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //timer.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
          title: Text(widget.topic,style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.black)),
        ) ,
      ),
      body: Column(
        children: [
          SizedBox(height: 40,),
          SizedBox(
            height: 15,
            child: CountDownTimer(
              secondsRemaining: 30,
              whenTimeExpires: () {
              },
              countDownTimerStyle: TextStyle(
                color: Color(0XFFf5a623),
                fontSize: 17.0,
                height: 1.2,
              ),
            )
            /*ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: currentTime/30,
                backgroundColor: Colors.tealAccent,
                color: Colors.teal,
              ),
            ),*/
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("Drag the "+"$ans "+data[0]["question"], style: TextStyle(fontSize: 25,)),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: data.length>0?Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: GridView.count(
                          crossAxisCount: choices.length%3==0?3:2,
                          childAspectRatio: choices.length>4?(5/5):(3/2),
                          children: choices.keys.map((key) {
                              return Draggable<String>(
                                data: key,
                                child: SizedBox(
                                  height: 20,
                                  width: 80,
                                  child: score[key]==true
                                      ? Icon(Icons.done,color:Colors.lightGreen,size: 80,)
                                      : FutureBuilder(
                                      future: storage.downloadURL(key),
                                      builder: (context,snapshot){
                                        if(snapshot.connectionState==ConnectionState.done){
                                          return Container(
                                            width: 50,
                                            height: 50,
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
                                feedback: FutureBuilder(
                                    future: storage.downloadURL(key),
                                    builder: (context,snapshot){
                                      if(snapshot.connectionState==ConnectionState.done){
                                        return Container(
                                          width: 40,
                                          height: 50,
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
                                childWhenDragging: Container(),
                              );
                            }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:50),
                      child: buildTarget(ans),
                    )
                  ],
                ):Container(),
          ),
        ],
      ),
    );
  }


  _nav_to_next(int time) async{
    await Future.delayed(Duration(milliseconds: time),() {});
    //Navigator.pushReplacementNamed(context, 'mcq',arguments: widget.topic);
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => Mcq(topic: widget.topic))));
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Topics")
        .get();
    List<DocumentSnapshot> topics=[];
    setState(() {
      topics.addAll(snap.docs);
    });
    int l=4;
    for(int i=0; i<=l;i++){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String name = prefs.getString("username").toString();
      DocumentReference user=FirebaseFirestore.instance.collection("User").doc(name);
      firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
      String downloadURL=await storage.ref().child("Animations/HURRAY.mp4").getDownloadURL();
      if(i==l && topics[0]["Academics"][i]==widget.topic){
        user.update({
          "current_topic":"higher_level",
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Cheer(path: downloadURL,),));
      }
      else{
        if(topics[0]["Academics"][i]==widget.topic) {
          user.update({
            "current_topic":topics[0]["Academics"][i+1],
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Cheer(path: downloadURL,),));
        }
      }
    }
  }

  Future<void> getData() async {
    QuerySnapshot snap= await FirebaseFirestore.instance
        .collection("Questions")
        .where("topic",isEqualTo: widget.topic)
        .where("method",isEqualTo: "drag")
        .get();
    setState(() {
      data.addAll(snap.docs);
    });
    List<String> items=List.from(data[0]["left"]);
    for(int i = 0 ; i < items.length; i++ )
      {
        String key=data[0]["left"][i];
        String value=data[0]["right"][i];
        choices[key]=value;
      }
    String element=choices.keys.toList()[random.nextInt(choices.keys.toList().length)];
    if(widget.topic=="fruits")
      ans="fruit";
    else if(widget.topic=="vegetables")
      ans="vegetable";
    else
      ans= choices[element].toString();
    for(String c in choices.values)
      {
        if(c==ans)
          correct++;
      }
    print("there are $correct correct answers");
  }

  String getValue(String key){
    String value=choices[key].toString();
    return value;
  }

  Widget buildTarget(String answer){
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 250,
          width: 250,
          child: Image(image: AssetImage("assets/DragDropBox.jpg"),height: 250,width: 200,));
      },
      onWillAccept: (data)
      {
        if(choices[data]==answer) {
          return true;
        } else {
          return false;
        }
      },
      onAccept: (data){
        if(choices[data]==answer)
        {
          setState(() {
            score[data.toString()]=true;
            marks++;
            if(marks==correct){
              flag=true;
              currentTime=ft.AnswerTime();
              String k=widget.topic;
              setData(k,marks,(30-currentTime));
              showSnackBar(context, "Well Done...!", Colors.green);
              _nav_to_next(2500);
            }
          });
        }
        print("Wrong Attempt");
      },
      onLeave: (data){
      },
    );
  }

  Future<void> setData(String key, int value,int time) async{
    double score,total,full=5,mpq=2;//mpq is the marks per question
    if (time==99){
      score=value * mpq;
    }
    else if(time>0 && time<=10){
      score=value * mpq * full; // time between 0-10, 0% depreciation
    }
    else if(time>10 && time<=20){
      score=value * mpq * (full-(full*0.4)); // time between 10-20, 40% depreciation
    }
    else{
      score=value * mpq * (full-(full*0.8)); // time between 20-30, 80% depreciation
    }
    total=score-(score*0.1); //10% depreciation on answers given within time
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("username").toString();
    DocumentReference user=FirebaseFirestore.instance.collection("User").doc(name);
    user.update({
      "Total_Score.${widget.topic}": total,
      "Method Number.${widget.topic}": 2,
      "Response_Time.${widget.topic}": time,
    });
  }

  void showSnackBar(BuildContext context, String msg, Color color){
    final snackBar=SnackBar(
      content: Text(msg,
        style: TextStyle(fontSize: 16),),
      shape: StadiumBorder(),
      duration: Duration(milliseconds: 1000),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context)..showSnackBar(snackBar);
  }

}


