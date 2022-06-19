//import 'dart:js';

import 'package:ds_learner/Academics.dart';
import 'package:ds_learner/Analysis.dart';
import 'package:ds_learner/Cheer.dart';
import 'package:ds_learner/Dashboard.dart';
import 'package:ds_learner/DemoStart.dart';
import 'package:ds_learner/DragDrop.dart';
import 'package:ds_learner/Drawing.dart';
import 'package:ds_learner/Report.dart';
import 'package:ds_learner/Shapes/Shapes_flash.dart';
import 'package:ds_learner/Shapes/Shapes_game_1.dart';
import 'package:ds_learner/Social.dart';
import 'package:ds_learner/videoPlay.dart';
import 'package:flutter/material.dart';
import 'package:ds_learner/Profile.dart';
import 'package:ds_learner/login.dart';
import 'package:ds_learner/splash.dart';
import 'package:ds_learner/registration.dart';
import 'package:ds_learner/Shapes/Shapes.dart';
import 'DailyActivities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'MCQ.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'splash',
    routes: {
      'splash': (context)=> Splash(),
      'login': (context)=> Login(),
      'register': (context)=> Registration(),
      'profile': (context)=> Profile(passedAge: '',),
      'dashboard': (context) =>Dashboard(),
      'daily_activities': (context) => DailyActivities(),
      'academics': ((context)=> Academics()),
      'social':((context)=>Social()),
      'shapes':((context) => Shapes(topic: '',)),
      'shapes_flash': ((context) => Shapes_flash()),
      'videoPlay' : ((context) => videoPlay(path: '',)),
      'Shapes_game_1' : ((context) => Shapes_game_1()),
      'drawing' : ((context) => Drawing()),
      'analysis' : ((context) => Analysis()),
      'mcq': ((context) => Mcq(topic: '',)),
      'demoStart' : ((context) => DemoStart()),
      'report': ((context)=>Report())
    },
  ));
}