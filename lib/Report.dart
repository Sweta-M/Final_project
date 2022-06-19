import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  late String name;
  int flag=1;
  CollectionReference users= FirebaseFirestore.instance.collection('User');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
    // hasField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0XFF231dc4),
          title: Text('Report',style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,color: Colors.white)),
        ) ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child:
              FutureBuilder<DocumentSnapshot>(
                future: users.doc(name).get(),
                builder:
                    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("Document not found!");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                    var values,result,sumRes,avgRes;
                    Map<String, dynamic> marks={},response={};

                    //Obtained Score and Total Score calculation
                    marks = data['Total_Score'] ?? {"none":0};//?? means "if null then"
                    response = data['Response_Time'] ?? {"none":0};
                    values = marks.values;
                    result = values.reduce((sum, element) => sum + element);
                    sumRes = response.values;//.....................................
                    avgRes = sumRes.reduce((sum, element) => sum + element)/response.length;//.................
                    int currentTotal=(marks['none']==0)?0:marks.length*20;
                    String grade=getGrade(result,currentTotal);

              return Column(
                      children: [
                        Center(child: Text("${data['name']}",style: TextStyle(fontSize: 35),)),
                        Card(
                          color: Color(0XFF9fede8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Score Board",style: TextStyle(fontSize: 25),),
                              ),
                              Row(
                                  children:[
                                    Text("${result.toStringAsFixed(2)}",style: TextStyle(fontSize: 40)),
                                    //multiplying length of map with full marks of each topic
                                    Text(" out of ${currentTotal}",style: TextStyle(fontSize: 20))]),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Card(
                          color: Color(0XFF9fede8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Grade",style: TextStyle(fontSize: 25),),
                              ),
                              Text(grade,style: TextStyle(fontSize: 40)),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Card(
                          color: Color(0XFF9fede8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text("Remarks",style: TextStyle(fontSize: 25),),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 100,),
                      ],
                    );
                  }
                  return Text("loading");
                },
              )
        ),
      ),
    );
  }

  void getUsername() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email=prefs.getString("username").toString();
    setState(() {
      name=email;
    });
  }

  void hasField() async{
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('User')
        .where('email',isEqualTo: name)
        .where('Total_Score'.length, isGreaterThan: 0)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if(documents.length==1)
      setState(() {
        flag=0;
      });
    else
      setState(() {
        flag=1;
      });
  }

  String getGrade(result, int currentTotal) {
    if (currentTotal==0)
      return "NA";
    else{
      double percent= result/currentTotal *100;
      if(percent>=80)
        return "A+";
      else if(percent>=60 && percent<80)
        return "A";
      else if(percent>=40 && percent<60)
        return "B";
      else
        return "C";
    }
  }
}
