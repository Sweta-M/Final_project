import 'dart:ui';

import 'package:ds_learner/Academics.dart';
import 'package:ds_learner/Learning.dart';
import 'package:ds_learner/Report.dart';
import 'package:ds_learner/Social.dart';
import 'package:ds_learner/login.dart';
import 'package:flutter/material.dart';
import 'DailyActivities.dart';
import 'package:ds_learner/getImage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {

    final Storage storage=Storage();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
          title: Text('Dashboard',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.black)),
        ) ,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent
              ),
              child: Text('DS Learner',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: Text('Profile',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
              onTap: (){

              },
            ),
            ListTile(
              title: Text('Child\'s Progress',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Report(),));
              },
            ),
            ListTile(
              title: Text('Settings',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
              onTap: (){
              },
            ),
            ListTile(
              title: Text('Logout',style: TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
              },
            ),
          ],
        ),
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
                SizedBox(height: MediaQuery.of(context).size.height*0.02),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height*0.3
                  ),
                  child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width*0.7,
                    margin:EdgeInsets.all(8.0),
                    child:
                    GestureDetector(
                      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>DailyActivities()));},
                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height*0.02),
                            FutureBuilder(
                                future: storage.downloadURL('labels/daily_activities.jpg'),
                                builder: (context,snapshot){
                                  if(snapshot.connectionState==ConnectionState.done){
                                    return Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      height: MediaQuery.of(context).size.height*0.2,
                                      child: Image.network(
                                        snapshot.data.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                  if(snapshot.connectionState==ConnectionState.waiting)
                                  {
                                    return CircularProgressIndicator();
                                  }
                                  throw Exception('No image');
                                }),
                            Text('DAILY ACTIVITIES',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),

                  ),
                  )
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.02),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height*0.3
                    ),
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.7,
                        margin:EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Academics()));},
                            child: Card(
                              child: Column(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height*0.02),
                                  FutureBuilder(
                                      future: storage.downloadURL('labels/Academics.jpg'),
                                      builder: (context,snapshot){
                                        if(snapshot.connectionState==ConnectionState.done){
                                          return Container(
                                            width: MediaQuery.of(context).size.width*0.7,
                                            height: MediaQuery.of(context).size.height*0.2,
                                            child: Image.network(
                                              snapshot.data.toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }
                                        if(snapshot.connectionState==ConnectionState.waiting)
                                        {
                                          return CircularProgressIndicator();
                                        }
                                        throw Exception('No image');
                                      }),
                                  Text('ACADEMICS',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                        )
                      ),
                    )
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.02),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height*0.3
                    ),
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.3,
                        width: MediaQuery.of(context).size.width*0.7,
                        margin:EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Social()));},
                          child: Card(
                            child: Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height*0.02),
                                FutureBuilder(
                                    future: storage.downloadURL('labels/Social.png'),
                                    builder: (context,snapshot){
                                      if(snapshot.connectionState==ConnectionState.done){
                                        return Container(
                                          width: MediaQuery.of(context).size.width*0.7,
                                          height: MediaQuery.of(context).size.height*0.2,
                                          child: Image.network(
                                            snapshot.data.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }
                                      if(snapshot.connectionState==ConnectionState.waiting)
                                      {
                                        return CircularProgressIndicator();
                                      }
                                      throw Exception('No image');
                                    }),
                                Text('SOCIAL BEHAVIOUR',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),

                      ),
                    )
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
