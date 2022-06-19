import 'package:ds_learner/DemoTopic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DemoStart extends StatefulWidget {
  const DemoStart({Key? key}) : super(key: key);

  @override
  State<DemoStart> createState() => _DemoStartState();
}

class _DemoStartState extends State<DemoStart> {

  TextEditingController _username = TextEditingController();
  bool _validateUser = false;
  bool _user = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("DeekSha Data Collection",style: TextStyle(fontSize: 25),),
              SizedBox(height: 50,),
              TextField(
                  controller: _username,
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      labelText: 'Username',
                      hintText: 'Full Name',
                      errorText: _validateUser ? 'Please enter your name' : (_user ? null : 'User Already exists'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      icon: Icon(Icons.account_circle,color: Colors.black,)
                  )
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _username.text.isEmpty ? _validateUser=true : _validateUser=false;
                    if(doesNameAlreadyExist(_username.text)==true)
                      {
                        _user=false;
                      }
                    else{
                      _user=true;
                    }
                  });
                  if(_validateUser==false && _user==true)
                    {
                      userSetup(_username.text);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => DemoTopic(topic: "shapes", path: '',))));
                    }
                },
                child: Text('Start',style: TextStyle(fontSize: 25),),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    primary: Colors.green),
              ),
              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> userSetup(String displayName) async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("UserDummyData").doc();
    var id=documentReference.id.toString();
    FirebaseFirestore.instance.collection("UserDummyData").doc(id).set({"aaauser": displayName,"ID": id});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', id);
    return;
  }
  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection("UserDummyData")
        .where('user', isEqualTo: name)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
}
