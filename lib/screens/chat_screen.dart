// import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  static const String id= 'chat_Screen';
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? messageText;
  final _auth = FirebaseAuth.instance;
  final _firestore= FirebaseFirestore.instance;
  String? loggedInUser='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentUser();
  }
  void getcurrentUser() async
  {
    try {
      final user = await _auth.currentUser;
      if(user != null)
        {
          loggedInUser=user.email;
          // final email=user.email;

          print(loggedInUser);
        }
    }
    catch(e)
    {
      print(e);
    }

  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('Message').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.active)
                            {
                              if(snapshot.hasData)
                                {
                                  return Expanded(
                                    child: ListView.builder(itemBuilder: (context,index){
                                      var messagesender= snapshot.data!.docs[index]['Sender'];
                                      var messagetext=snapshot.data!.docs[index]['Text'];
                                    
                                    },),
                                  );
                                }
                              else if(snapshot.hasError){
                                return Center(child: Text("${snapshot.hasError.toString()+'hiiiiii'}"),);
                              }
                              else{
                                return Text("hi");
                              }

                            }
                          else{
                            return Center(child: CircularProgressIndicator(),);
                          }
                }),
            Container (
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      onChanged: (value)
                      {
                        messageText= value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('Message').add({'Sender': loggedInUser, 'Text': messageText,});
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
