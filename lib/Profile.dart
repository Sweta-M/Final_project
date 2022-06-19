import 'dart:ui';

import 'package:ds_learner/Dashboard.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String passedAge;
  const Profile({Key? key,required this.passedAge}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //Static Data
  List quest_level_1= [
    'Can point to objects or body parts?',
    'Can hold a glass to drink by oneself?'
  ];
  List quest_level_2= [
    'Can write alphabets?',
    'Can read small words?',
    'Eats without spilling?'
  ];
  List quest_level_3= [
    'Understands the concept of days, weeks, months?',
    'Can perform tasks without any assistance?'
  ];
  List<int?> selectedValue=[-1,-1,-1];
  List questions=[];
  int? sValue=-1;
  int s=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Color(0XFF3BA35C),
        title: Text('DeekSha',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
      ),
      body:Stack(
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
                Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.025),
                    width: double.infinity,
                    child: Text('PROFILE ANALYSIS', style:
                    TextStyle(fontSize: 25,fontWeight: FontWeight.bold, decoration: TextDecoration.underline),textAlign: TextAlign.center,)
                ),
                Center(
                  child: getQuestionSet(),
                ),
                ListView.builder(
                    itemBuilder: (context,position){
                      return Card(
                          child: Column(
                              children: [
                                Center(
                                  child: incPos(position),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    child:Text('$s)'+questions[position],style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,)),
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text('Yes',style: TextStyle(fontSize: 20)),
                                            Radio(
                                              value: 1,
                                              groupValue: selectedValue[position],
                                              activeColor: Colors.green,
                                              onChanged: (int? val){
                                                setState(() {
                                                  selectedValue[position] = val;
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('No',style: TextStyle(fontSize: 20)),
                                            Radio(
                                              value: 2,
                                              groupValue: selectedValue[position],
                                              activeColor: Colors.green,
                                              onChanged: (int? val) {
                                                setState(() {
                                                  selectedValue[position] = val;
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('Sometimes',style: TextStyle(fontSize: 20)),
                                            Radio(
                                              value: 3,
                                              groupValue: selectedValue[position],
                                              activeColor: Colors.green,
                                              onChanged: (int? val) {
                                                setState(() {
                                                  selectedValue[position] = val;
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ]
                          )
                      );
                    },
                    itemCount: questions.length,
                    shrinkWrap: true),
                ElevatedButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));
                },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      primary: Color(0xff70b883)
                  ),
                  child: Text('Proceed', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),)
              ],
            ),
          ),
        ],
      ),
    );
  }

  getQuestionSet() {
    if(widget.passedAge=='3' || widget.passedAge=='4' || widget.passedAge=='5' || widget.passedAge=='6')
      {
        questions=quest_level_1;
      }
    else if(widget.passedAge=='7' || widget.passedAge=='8' || widget.passedAge=='9' || widget.passedAge=='10')
    {
      questions=quest_level_2;
    }
    if(widget.passedAge=='11' || widget.passedAge=='12' || widget.passedAge=='13' || widget.passedAge=='14' || widget.passedAge=='15')
    {
       questions=quest_level_3;
    }
  }

  incPos(int position) {
    s=position+1;
  }
}





/*
ListView.builder(itemBuilder: (context,position){
              return Card(
                child: Text(quest_level_1[position]),
              );
            },
            itemCount: quest_level_1.length,
            shrinkWrap: true),
 */

/*

 setSelectedRadio(int? val,int? sR) {
    setState(() {
      sR = val;
    });
  }

                  ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        Row(
                        children: [
                          Column(
                            children: [
                              Text('Yes'),
                              Radio(
                                value: 1,
                                groupValue: selectedRadio[0],
                                activeColor: Colors.green,
                                onChanged: (int? val){
                                  setState(() {
                                    val=value;
                                  });
                                },
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text('No'),
                              Radio(
                                value: 2,
                                groupValue: selectedRadio[1],
                                activeColor: Colors.green,
                                onChanged: (int? val){
                                  setSelectedRadio(val,selectedRadio[1]);
                                },
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text('Sometimes'),
                              Radio(
                                value: 3,
                                groupValue: selectedRadio[2],
                                activeColor: Colors.green,
                                onChanged: (int? val){
                                  setSelectedRadio(val, selectedRadio[2]);
                                },
                              )
                            ],
                          ),
                        ],
                        ),
                      ],
                    )
 */