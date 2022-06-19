import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Analysis extends StatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  State<Analysis> createState() => _AnalysisState();
}

var docs;
String selectedOpt='none';


@override
void initState() {
  initState();
  getCount();
  getQuestion();
  getOptions();
}

Future<List> getOptions() => FirebaseFirestore.instance
    .collection('Profile_Analysis')
    .doc('PA1') //your collectionref
    .get()
    .then((value) {
  List options = [];
  options=value.data()!['Options'];
  return options;
});

Future<String> getQuestion() async => FirebaseFirestore.instance
    .collection('Profile_Analysis')
    .doc('PA1') //your collectionref
    .get()
    .then((value) {
  String question = '';
  question=value.data()!['Question'];
  return question;
});


Future<int> getCount() async => FirebaseFirestore.instance
      .collection('Profile_Analysis') //your collectionref
      .get()
      .then((value) {
    var count = 0;
    count = value.docs.length;

    return count;
    });



class _AnalysisState extends State<Analysis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
          title: Text('PROFILE ANALYSIS',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.black)),
        ) ,
      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<int>(
                future: getCount(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if(snapshot.hasData){
                    return Center(child: Text('Number Of documents : ${snapshot.data}',style: TextStyle(fontSize: 30),));
                  }
                  return Container();
                },
              ),
              FutureBuilder<String>(
                future: getQuestion(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if(snapshot.hasData){
                    return Center(child: Text('Question : ${snapshot.data}',style: TextStyle(fontSize: 20),));
                  }
                  return Container();
                },
              ),
              FutureBuilder<List>(
                future: getOptions(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if(snapshot.hasData){
                    return DropdownButton<String>(
                        hint: Text("---Select---"),
                        value: selectedOpt.isNotEmpty?selectedOpt:null,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOpt = newValue!;
                          });
                        },
                        items: snapshot.data?.map((view) {
                          return DropdownMenuItem<String>(
                            child: Text(view),
                            value: view,
                          );
                        }).toList(),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
