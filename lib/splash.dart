import 'dart:ui';

import 'package:ds_learner/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ds_learner/getImage.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    _navigate_to_login();
  }

  _navigate_to_login() async{
    await Future.delayed(Duration(milliseconds: 2000),() {});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
  }

  @override
  Widget build(BuildContext context) {

    final Storage storage =Storage();

    return Scaffold(
        body:Column(
          children: [
            Center(
              child: Container(
                  margin: EdgeInsets.all(MediaQuery.of(context).size.width*0.2),
                  child: FutureBuilder(
                    future: storage.downloadURL('deeksha_logo.jpeg'),
                    builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.done && snapshot.hasData){
                        return Container(
                          width: 300,
                          height: 250,
                          child: Image.network(
                            snapshot.data.toString(),
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      if(snapshot.connectionState==ConnectionState.waiting || !snapshot.hasData)
                        {
                          return CircularProgressIndicator();
                        }
                      throw Exception('No image');
                    }),
                /*decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/deeksha_logo.jpeg"),
                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.clear)
                  )
                ),*/
                  )
              ),
            Center(
                child: Container(
                  margin: EdgeInsets.all(MediaQuery.of(context).size.width*0.2),
                  child: Image(
                    image: AssetImage("assets/deeksha.jpg"),
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/deeksha.jpg"),
                          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.clear)
                      )
                  ),
                )
            ),
          ],
        ),
    );
  }

}
