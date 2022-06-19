

import 'package:ds_learner/videoPlay.dart';
import 'package:flutter/material.dart';

class DailyActivities extends StatefulWidget {
  const DailyActivities({Key? key}) : super(key: key);

  @override
  State<DailyActivities> createState() => _DailyActivitiesState();
}

class _DailyActivitiesState extends State<DailyActivities> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
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
          GestureDetector(
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>videoPlay(path: 'assets/videos/DailyActivities/brush.mp4',)));
              },
              child:Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width*0.45,
                margin:EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      Image(image: AssetImage("assets/daily/brush_image.jpg"),
                        width: MediaQuery.of(context).size.width*0.75,
                        height: MediaQuery.of(context).size.height*0.25,),
                      Text('Brushing',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              )

          ),
        ],
      ),
    );
  }
}
