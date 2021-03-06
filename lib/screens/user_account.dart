import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flushbar/flushbar.dart';

import 'login_screen.dart';
import 'package:craftrip_app/services/collections.dart';
import 'user_preference.dart';
import 'package:craftrip_app/services/resetpw.dart';



class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {

  Future<List<String>> userInfo;
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar:PreferredSize(    
        preferredSize:Size.fromHeight(65.0) ,
        
        child: AppBar(
          backgroundColor: Color(0xff2675eb),
          
          title: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: <Widget>[
                Text(
                    'USER ACCOUNT',
                    style: TextStyle(
                        fontSize: 25.0,
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w400
                    )
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                      width:30.0,
                      child: Image.asset('assets/TravelDiaryIcon.png'),
                    ),
                    Text('CrafTrip',
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

// END OF APP BAR

      body: displayUserInfo(userInfo),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              // Sign out, to LoginScreen()
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (r) => false);
            },
            label: Text('SIGN OUT',
              style: TextStyle(color: Colors.black87),),
            icon: Icon(Icons.exit_to_app, color: Colors.black87,),
            backgroundColor: Colors.grey[200],
          ),
        )
        
    );
  }

Widget displayUserInfo(userInfo) => FutureBuilder<dynamic> (
  future: userInfo,
  builder: (context, snapshot) {

    if (!snapshot.hasData) return Container(

      height: 300,
      width: 400,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          Center(
          child: Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.all(5),
            child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.grey)
              ),
            ),
          ),
        ],
      )
    );

    if (snapshot.data.length == 0) {
      return Container(
        height: 300,
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
            child: Container(
            height: 200,
            width: 200,
            margin: EdgeInsets.all(5),

            child: Text("Data currently unavailable!", 
              style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.center),

              ),
            ),
          ],
        )
      );
    }

    return Container(
        padding: EdgeInsets.symmetric(vertical:10.0, horizontal: 50.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: <Widget>[
            SizedBox(height:50.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
              child: Text("NAME", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),

            SizedBox(height:8.0),
            
            Container(decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ), height: 36.0, width: 380.0, child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${snapshot.data[0]}',  style: TextStyle(fontSize: 16.0)),
            )),

            SizedBox(height:20.0),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
              child: Text("EMAIL-ID", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),

            SizedBox(height:8.0),
            
            Container(decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ), height: 36.0, width: 380.0, child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${snapshot.data[1]}',  style: TextStyle(fontSize: 16.0)),
            )),

            SizedBox(height:20.0),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6.0),
              child: Text("MANAGE PREFERENCES", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            
            SizedBox(height:8.0),
            
            Container(
                height: 36.0, width: 380.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),

                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,0,0,0),
                      child: Text('Travel Tags',  style: TextStyle(fontSize: 16.0)),
                    ),
                    
                    SizedBox(
                        width:30,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => UserPreference()));
                          },
                          child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20.0,),
                        )
                    )
                  ],
                )
            ),

            SizedBox(height:20.0),

            Text("CHANGE PASSWORD", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),

            //Old Password
            SizedBox(height:10.0),

          // Change Password
          Center(
            child: FlatButton(
              color: Colors.grey[200],
              child: Text('SEND RECOVERY E-MAIL'),
              textColor: Colors.black,
              padding: EdgeInsets.all(15.0),
                onPressed:  () async{
                  showMoreInfoFlushbar(context);
                  String username = usernameController.text;

                  var sessToken = await ResetModel().handleForgotPw(username);

                }),
          ),
          ]),
    );
  }
);
      // SIGN OUT BUTTON



void initState() {

  super.initState();

  setState( () {
    userInfo = Collections().getUserInfo(); 
      }
    );
  }

  void showMoreInfoFlushbar(BuildContext context) {
    Flushbar(
      title: 'Reset Link',
      message: 'The password reset link will be sent to you registered e-mail ID.',
      icon: Icon(
        Icons.send,
        size: 28,
        color: Colors.white,
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }
}