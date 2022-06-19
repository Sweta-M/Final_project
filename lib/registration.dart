import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController guardianEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passEditingController = TextEditingController();
  String selectedAge='',selectedGender='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Color(0XFFEB972A),
            title: Text('REGISTRATION', style: TextStyle(fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
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
            Container(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: nameEditingController,
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.only(top: 17),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(Icons.person_sharp,
                                  color: Colors.black,), // icon is 48px widget.
                              ),
                              hintText: 'Enter name of the child',
                              hintStyle: TextStyle(
                                  fontSize: 18, color: Colors.black)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter the name';
                            else
                              return null;
                          },
                        ),
                        DropdownButtonFormField(
                          value: selectedAge,
                          isExpanded: true,
                          items: [
                            DropdownMenuItem<String>(child: Text('--Select Age--'),value: '',),
                            DropdownMenuItem<String>(child: Text('3 years'),value: '3',),
                            DropdownMenuItem<String>(child: Text('4 years'),value: '4',),
                            DropdownMenuItem<String>(child: Text('5 years'),value: '5',),
                            DropdownMenuItem<String>(child: Text('6 years'),value: '6',),
                            DropdownMenuItem<String>(child: Text('7 years'),value: '7',),
                            DropdownMenuItem<String>(child: Text('8 years'),value: '8',),
                            DropdownMenuItem<String>(child: Text('9 years'),value: '9',),
                            DropdownMenuItem<String>(child: Text('10 years'),value: '10',),
                            DropdownMenuItem<String>(child: Text('11 years'),value: '11',),
                            DropdownMenuItem<String>(child: Text('12 years'),value: '12',),
                            DropdownMenuItem<String>(child: Text('13 years'),value: '13',),
                            DropdownMenuItem<String>(child: Text('14 years'),value: '14',),
                            DropdownMenuItem<String>(child: Text('15 years'),value: '15',),
                          ],
                          onChanged: (String? value){
                            setState(() {
                              selectedAge=value!;
                            });
                          },
                          validator: (value){
                            if(selectedAge=='')
                              return 'Please select the age!';
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(Icons.calendar_today,
                                color: Colors.black,),
                              ),
                          )
                        ),
                        DropdownButtonFormField(
                            value: selectedGender,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem<String>(child: Text('--Select Gender--'),value: '',),
                              DropdownMenuItem<String>(child: Text('Male'),value: 'male',),
                              DropdownMenuItem<String>(child: Text('Female'),value: 'female',),
                            ],
                            onChanged: (String? value){
                              setState(() {
                                selectedGender=value!;
                              });
                            },
                            validator: (value){
                              if(selectedGender=='')
                                return 'Please select the gender!';
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(Icons.calendar_today,
                                  color: Colors.black,),
                              ),
                            )
                        ),
                        TextFormField(
                          controller: guardianEditingController,
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.only(top: 17),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(Icons.person_pin_rounded,
                                  color: Colors.black,), // icon is 48px widget.
                              ),
                              hintText: 'Enter name of the guardian',
                              hintStyle: TextStyle(
                                  fontSize: 18, color: Colors.black)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter the name';
                            else
                              return null;
                          },
                        ),
                        TextFormField(
                          controller: phoneEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.only(top: 17),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(Icons.phone,
                                  color: Colors.black,), // icon is 48px widget.
                              ),
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                  fontSize: 18, color: Colors.black)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter the Phone Number';
                            else if(value.length!=10)
                              return 'Enter a valid 10-digit phone number';
                            else
                              return null;
                          },
                        ),
                        TextFormField(
                          controller: emailEditingController,
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.only(top: 17),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(Icons.email_outlined,
                                  color: Colors.black,), // icon is 48px widget.
                              ),
                              hintText: 'Enter the email ID',
                              hintStyle: TextStyle(
                                  fontSize: 18, color: Colors.black)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter the email ID';
                            else if (!value.contains('@') || !value.endsWith('.com'))
                              return 'Enter a valid email ID';
                            else
                              return null;
                          },
                        ),
                        TextFormField(
                          controller: passEditingController,
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.only(top: 17),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(Icons.key,
                                  color: Colors.black,), // icon is 48px widget.
                              ),
                              hintText: 'Enter the password',
                              hintStyle: TextStyle(
                                  fontSize: 18, color: Colors.black)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter the password';
                            else if(value.length<6)
                              return 'Password should have atleast 6 characters';
                            else
                              return null;
                          },
                          obscureText: true,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.only(top: 17),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Icon(Icons.vpn_key_outlined,
                                  color: Colors.black,), // icon is 48px widget.
                              ),
                              hintText: 'Confirm your password',
                              hintStyle: TextStyle(
                                  fontSize: 18, color: Colors.black)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please confirm your password';
                            else if(value!=passEditingController.text)
                              return 'Passwords do not match';
                            else
                              return null;
                          },
                          obscureText: true,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()){
                                FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailEditingController.text.trim(),
                                password: passEditingController.text
                                ).then((value) {
                                  userSetup();
                                }).catchError((error)=> {
                                  if(error.code=="email-already-in-use")
                                    showSnackBar(context, "User already exists!")
                                  else{
                                    showSnackBar(context, "some error occured")
                                  }
                                });
                              }
                            },
                            child: Text('Sign Up'),
                          ),
                        )
                      ],
                    ),
                  ),
                )

            ),
          ],
        )
    );
  }

  void showSnackBar(BuildContext context, String msg){
    final snackBar=SnackBar(
      content: Text(msg,
        style: TextStyle(fontSize: 16),),
      shape: StadiumBorder(),
      duration: Duration(milliseconds: 1000),
      backgroundColor: Colors.deepOrangeAccent,
    );
    ScaffoldMessenger.of(context)..showSnackBar(snackBar);
  }

  userSetup() async{
    FirebaseFirestore.instance
        .collection('User')
        .doc(emailEditingController.text.trim())
        .set(
        {
          'name': nameEditingController.text,
          'age' : selectedAge,
          'gender' : selectedGender,
          'guardian' : guardianEditingController.text,
          'phone_no' : phoneEditingController.text,
          'email' : emailEditingController.text.trim(),
          'current_topic' : "shapes", //will depend on the age group
        });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', emailEditingController.text.trim());
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));
  }
}
  




/*//import 'dart:html';
import 'dart:ui';

import 'package:ds_learner/Profile.dart';
import 'package:flutter/material.dart';


class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  //String initial='3 years';
  var selectedAge,selectedGender,selectedRelation;
  //List ageList = ['3 years', '4 years','5 years', '6 years','7 years', '8 years','9 years', '10 years','11 years', '12 years','13 years', '14 years','15 years'];
  List ageList = ['3','4','5','6','7','8','9','10','11','12','13','14','15'];
  List genderList = ['Male','Female'];
  List relationList = ['Father','Mother','Caregiver'];
  int l=0;
  TextEditingController _name = TextEditingController();
  var _username='',age='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Color(0XFFEB972A),
          title: Text('DeekSha',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
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
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20,top: 20),
                  child: Text('REGISTRATION',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,),
                  ),
                ),
                Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.02,
                    right: MediaQuery.of(context).size.width*0.1,
                    left: MediaQuery.of(context).size.width*0.1 ),
                child: Column(
                  children: [
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Name of the Child',
                          errorText: _username!=''?_username:null,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Icon(Icons.account_circle,color: Colors.black,)
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                    Row(
                      children: [
                        Icon(Icons.date_range_rounded),
                        SizedBox(width: MediaQuery.of(context).size.width*0.04,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: DropdownButton(
                              items: ageList.map((value) => DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              )).toList(),
                              isExpanded: true,
                              onChanged: (selectAge){
                                setState(() {
                                  selectedAge=selectAge;
                                });
                              },
                              value: selectedAge,
                              hint: Text('Select Age(in years) of the child'),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                    Row(
                      children: [
                        Icon(Icons.wc_rounded),
                        SizedBox(width: MediaQuery.of(context).size.width*0.04,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: DropdownButton(
                              items: genderList.map((value) => DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              )).toList(),
                              isExpanded: true,
                              onChanged: (selectGender){
                                setState(() {
                                  selectedGender=selectGender;
                                });
                              },
                              value: selectedGender,
                              hint: Text('Select Gender of the child'),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                    TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Name of Guardian',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Icon(Icons.person_pin_rounded,color: Colors.black,)
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                    Row(
                      children: [
                        Icon(Icons.family_restroom_rounded),
                        SizedBox(width: MediaQuery.of(context).size.width*0.04,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: DropdownButton(
                                items: relationList.map((value) => DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                )).toList(),
                                isExpanded: true,
                                onChanged: (selectRelation){
                                  setState(() {
                                    selectedRelation=selectRelation;
                                  });
                                },
                                value: selectedRelation,
                                hint: Text('Guardian\'s relation with child'),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                    TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Phone Number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Icon(Icons.phone,color: Colors.black,)
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                    TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Email ID',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Icon(Icons.email_rounded, color: Colors.black,)
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Icon(Icons.key_rounded, color: Colors.black,)
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Icon(Icons.remove_red_eye_rounded, color: Colors.black,)
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width*0.025,),
                    ElevatedButton(onPressed: (){
                      setState(() {
                        _username=validUsername();
                        age=validAge();
                      });
                      if(validUsername()=='' && validAge()==''){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Profile(passedAge: selectedAge)));}
                    },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20),
                          primary: Color(0xff70b883)
                      ),
                      child: Text('Sign Up', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),),
                    SizedBox(height: MediaQuery.of(context).size.width*0.2,),
                  ],
                ),
              ),]
              )

          )
        ],
      ),
    );
  }

  String validUsername() {
    if (_name.text.isEmpty)
      {
        return 'Please enter the name of the child';
      }
    else
      {
        return '';
      }
  }

  String validAge() {
    if (selectedAge.toString().isEmpty)
    {
      return 'Please select an age';
    }
    else
    {
      return '';
    }
  }
} */
