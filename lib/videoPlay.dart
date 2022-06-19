import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class videoPlay extends StatefulWidget {
  final String path;
  const videoPlay({Key? key, required this.path}) : super(key: key);

  @override
  State<videoPlay> createState() => _videoPlayState();
}

class _videoPlayState extends State<videoPlay> {

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.asset(widget.path);
    _initializeVideoPlayerFuture=_controller.initialize();
    _controller.setLooping(false);
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
          leading: Icon(Icons.home),
          title: Text('DAILY ACTIVITIES',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.black)),
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
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          FloatingActionButton(
            onPressed: (){
              setState(() {
                if(_controller.value.isPlaying)
                {
                  _controller.pause();
                }
                else
                {
                  _controller.play();
                }
              });
            },
            child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}
