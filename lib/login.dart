//import 'dart:html';
import 'dart:ui';

import 'package:ds_learner/Dashboard.dart';
import 'package:ds_learner/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class  Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _validateUser = false;
  bool _validatePass =false;
  bool _pass = true;
  static const snackBar = SnackBar(
    content: Text('Either username or password is wrong!'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0XFF3BA35C),
          title: Text('DeekSha',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
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
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.1,
                  right: MediaQuery.of(context).size.width*0.1,
                  left: MediaQuery.of(context).size.width*0.1 ),
                child: Column(
                  children: [
                    Container(
                      //padding: EdgeInsets.only(left: 40,top: 30),
                      child: Text('Welcome',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Icon(Icons.account_circle,
                      color: Colors.black,
                      size: 100,),
                    ),
                    TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'Username',
                        hintText: 'Email/Phone Number',
                        errorText: _validateUser ? 'Please enter the username' : (_pass ? null : ''),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                        icon: Icon(Icons.account_circle,color: Colors.black,)
                      )
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width*0.095,
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Password',
                          hintText: 'Password',
                          errorText: _validatePass ? 'Please enter the password' : (_pass ? null : 'Username or Password Incorrect'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          icon: Icon(Icons.key_rounded,color: Colors.black,)
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width*0.095,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        try{
                          FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _username.text.trim(),
                              password: _password.text
                          ).then((value) async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('username', _username.text.trim());
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) =>
                                Dashboard()));
                          }).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            _pass = false;
                          });
                          setState(() {
                            _username.text.isEmpty ? _validateUser=true : _validateUser=false;
                            _password.text.isEmpty ? _validatePass=true : _validatePass=false;
                            //passCheck() ? _pass=true : _pass=false;
                          });
                        }on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }catch(e){
                          print(e);
                          print('hello');
                        }
                        /*if(_username.text.isNotEmpty && _password.text.isNotEmpty && _pass==true) {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) =>
                              Dashboard()));
                        }*/
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        primary: Color(0XFF3BA35C)),
                      child: Text('Login', style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width*0.1,
                    ),
                    TextButton(
                      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> Registration()));},
                      child: Text('Do not have an Account? \nRegister here...',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0XFF914333), decoration: TextDecoration.underline),),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
  // passCheck() {
  //   if(_password.text == '1234')
  //     {
  //       return true;
  //     }
  //   else
  //     {
  //       return false;
  //     }
  // }
}


