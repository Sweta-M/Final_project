import 'dart:async';

import 'package:flutter/material.dart';


class FixedTimer{
  late Timer timer;
  int time=30;

  void startTime(){
    time=30;
    timer=Timer.periodic(Duration(seconds: 1), (timer){
      time-=1;
      if(time==0){
        timer.cancel();
      }
    });
  }

  int AnswerTime(){
    timer.cancel();
    return time;
  }
}