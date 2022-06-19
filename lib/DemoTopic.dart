
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ds_learner/DemoEnd.dart';
import 'package:ds_learner/Learning.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class DemoTopic extends StatefulWidget {
  final String topic,path;
  const DemoTopic({Key? key,required this.topic,required this.path}) : super(key: key);

  @override
  State<DemoTopic> createState() => _DemoTopicState();
}

class _DemoTopicState extends State<DemoTopic> {

  List data=[];
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
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String name = prefs.getString("username").toString();
                    FirebaseFirestore.instance.collection('User').doc(name).get()
                        .then((value) {
                      setState(() {
                        //print(value.data()!["current_topic"]);
                        if(value.data()!["current_topic"]!="higher_level")
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: ((context) => Learning(topic: value.data()!["current_topic"]))));
                        else
                          Navigator.push(context, MaterialPageRoute(builder: (context) => End(),));
                      });
                    });

                  },
                  child: Text('Start',style: TextStyle(fontSize: 25),),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      primary: Colors.green),
                ),
                SizedBox(height: 100,)
              ],
            ),
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
