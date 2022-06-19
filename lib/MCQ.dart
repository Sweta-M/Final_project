import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ds_learner/Cheer.dart';
import 'package:ds_learner/CountDownTimer.dart';
import 'package:ds_learner/DragDrop.dart';
import 'package:ds_learner/FixedTimer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'getImage.dart';

class Mcq extends StatefulWidget {
  final String topic;
  const Mcq({Key? key,required this.topic}) : super(key: key);

  @override
  State<Mcq> createState() => _McqState();
}

class _McqState extends State<Mcq> {

  bool isFirstTime = false;
  int isAnswered=0;
  List<DocumentSnapshot> data=[];
  int currentIndex=0;
  final Storage storage=Storage();
  late int currentTime;
  late Timer timer;
  FixedTimer ft=FixedTimer();
  late double total;
  double avgTime=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total=0;
    getData();
    ft.startTime();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(ft.time<1){
        showSnackBar(context, "Time Up!!", Colors.red);
        currentTime=ft.AnswerTime();
        setData(currentIndex, "incorrect", currentTime);
        if(currentIndex==data.length-1){
          //Navigator.pushReplacementNamed(context, 'academics');
          getNextTopic(widget.topic);
        }
        else{
          setState(() {
            ft.startTime();
            currentIndex+=1;
            currentTime=30;
            isAnswered=0;
          });
        }
      }
    });
    currentTime=30;
    /*timer=Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime-=1;
      });
      if(currentTime==0){
        Future.delayed(Duration(milliseconds: 500),()
        {
          setData(currentIndex, "incorrect", (30-currentTime));
          if(currentIndex==data.length-1){
            //Navigator.pushReplacementNamed(context, 'academics');
            getNextTopic(widget.topic);
          }
          else{
            setState(() {
              currentIndex+=1;
              currentTime=30;
              isAnswered=0;
            });
          }
        });
      }
    });*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isFirstTime=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              SizedBox(
                height: 15,
                child: SizedBox(
                  height: 15,
                  child: CountDownTimer(
                    secondsRemaining: 120,
                    whenTimeExpires: () {

                    },
                    countDownTimerStyle: TextStyle(
                      color: Color(0XFFf5a623),
                      fontSize: 17.0,
                      height: 1.2,
                    ),
                  ),
                /*ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: currentTime/30,
                    backgroundColor: Colors.tealAccent,
                    color: Colors.teal,
                  ),
                )*/
              ),),
              SizedBox(height: 40,),
              Text('${data[currentIndex]["question"]}',style: TextStyle(
                fontSize: 30
              ),),
              SizedBox(
                  height: 600,
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 180,
                        child: Card(
                          color: index==data[currentIndex]["correct"] && isAnswered==1
                              ? Color(0xff80ff80)
                              : (index!=data[currentIndex]["correct"]&&isAnswered==2
                              ? Color(0xffff4d4d)
                              : Colors.white),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          child: InkWell(
                            child: FutureBuilder(
                                future: storage.downloadURL(data[currentIndex]["answers"][index]),
                                builder: (context,snapshot){
                                  if(snapshot.connectionState==ConnectionState.done){
                                    return Container(
                                      width: 100,
                                      height: 100,
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
                            onTap: (){
                              double value;
                              int time;
                              if(index==data[currentIndex]["correct"])
                                {
                                    setState(() {
                                      isAnswered=1;
                                    });
                                    value=1;
                                    currentTime=ft.AnswerTime();
                                    showSnackBar(context, "Well Done...!", Colors.green);
                                    //setData(currentIndex, "correct", (30-currentTime));
                                }
                              else
                                {
                                  setState(() {
                                    isAnswered=2;
                                  });
                                  value=0;
                                  currentTime=ft.AnswerTime();
                                  showSnackBar(context, "Oops...!", Colors.red);
                                  //setData(currentIndex, "incorrect", (30-currentTime));
                                }
                              time=30-currentTime;
                              avgTime+=time;
                              double score,full=5,mpq=1;//mpq is the marks per question
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
                              total+=score;
                              Future.delayed(Duration(milliseconds: 1000),(){
                                if(currentIndex==data.length-1){
                                  avgTime=avgTime/4;
                                  storeData();
                                  //Navigator.pushReplacementNamed(context, 'academics');
                                  if(total<10){
                                    //Since full marks is 20, cut-off being 50%
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => DragDrop(topic: widget.topic))));
                                  }
                                  else{
                                    getNextTopic(widget.topic);
                                  }
                                }
                                else{
                                  ft.startTime();
                                  setState(() {
                                    currentIndex+=1;
                                    currentTime=30;
                                    isAnswered=0;
                                  });
                                }
                              });
                            },
                          ),
                          /*ListTile(
                            title: Text(
                              '${data[currentIndex]["answers"][index]}',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),*/
                        ),
                      );
                    },
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async{
    if(!isFirstTime){
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Questions")
          .where("topic",isEqualTo: widget.topic)
          .where("method",isEqualTo: "choice")
          .get();
      isFirstTime = true;
      setState(() {
        data.addAll(snap.docs);
      });
    }
  }

  getNextTopic(String current) async{
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
      if(i==l && topics[0]["Academics"][i]==widget.topic)
        {
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
    /*for(int i=0;i<topics1.length;i++){
      if (i==topics1.length-1 && topics[0]["Academics"][i]==widget.topic){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => DemoStart())));
      }
      else {
         if(topics[0]["Academics"][i]==widget.topic)
           MaterialPageRoute(builder: ((context) => DragDrop(topic: topics[0]["Academics"][i+1])));
      }
    }*/
  }

  Future<void> setData(int index, String value,int time) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("user").toString();
    DocumentReference user=FirebaseFirestore.instance.collection("UserDummyData").doc(name);
    user.update({
      "${widget.topic} 2.$index score":value,
      "${widget.topic} 2.$index response": time,
    });
  }

  Future<void> storeData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("username").toString();
    DocumentReference user=FirebaseFirestore.instance.collection("User").doc(name);
    user.update({
      "Total_Score.${widget.topic}":total,
      "Method Number.${widget.topic}": 1,
      "Response_Time.${widget.topic}": avgTime,
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

