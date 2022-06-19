import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ds_learner/DemoTopic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'Dashboard.dart';
import 'DemoNewLevel.dart';

class Cheer extends StatefulWidget {
  final String path;

  const Cheer({Key? key,required this.path}) : super(key: key);

  @override
  State<Cheer> createState() => _CheerState();
}

class _CheerState extends State<Cheer>{

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.network(widget.path);
    _initializeVideoPlayerFuture=_controller.initialize();
    _controller.setLooping(false);
    playVideo();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

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
              FutureBuilder(
                future:_initializeVideoPlayerFuture,
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.done)
                  {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  }
                  else
                  {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.pink,),
                    );
                  }
                },
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String name = prefs.getString("username").toString();
                  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                  FirebaseFirestore.instance.collection('User').doc(name).get()
                      .then((value) {
                          setState(() async {
                            if (value.data()!["current_topic"] != "higher_level") {
                              String downloadURL=await storage.ref().child("Animations/${value.data()!["current_topic"]}.mp4").getDownloadURL();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => DemoTopic(
                                              topic: value.data()!["current_topic"],
                                              path: downloadURL,
                                            ))));
                              } else
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => DemoNewLevel(),));
                          });
                      })
                      .catchError((e){
                        print(e);
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  primary: Color(0XFF1B7547),
                  shape: StadiumBorder(),
                ),
                child: Text('Go To Next Topic', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Dashboard()));
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    primary: Color(0XFF1B7547),
                    shape: StadiumBorder(),
                ),
                child: Text('Go Back To Dashboard', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  playVideo() async{
    await Future.delayed(Duration(milliseconds: 1000),() {});
    _controller.play();
  }
}
