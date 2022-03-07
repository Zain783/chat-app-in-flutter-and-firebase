import 'package:chat_zz/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
late User loggined;

class ChatScreen extends StatefulWidget {
  static final id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  // void getcurrentuser() async {
  //   try {
  //     final _user = await _auth.currentUser;
  //     if (_user != null) {
  //       loggedinuser = _user;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  String messagetext = '';
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentuser();
  }

  // final _firestore = FirebaseFirestore.instance;
  void getCurrentuser() async {
    try {
      final User = await _auth.currentUser;
      if (User != null) {
        loggined = User;
        print(loggined.email);
      }
    } catch (e) {}
  }

  void getMessages() async {
    // try {
    //   final user = await _auth.currentUser;
    //   if (user != null) {
    //     loggined = user;
    //   }
    // } catch (e) {}

    final messages = await _firestore.collection('messages').get();

    for (var message in messages.docs) {
      print(message.data());
    }
  }

  void messageStream() async {
    await for (var snapshop in _firestore.collection('messages').snapshots()) {
      for (var message in snapshop.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                // getMessages();
                messageStream();
                //// _auth.signOut();
                Navigator.pop(context);
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
        stream: _firestore.collection("messages").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!.docs.reversed;
            List<MessageBubble> messagewidgets = [];
            for (var message in messages) {
              final messageText = message.get('text');
              final messageSender = message.get('sender');
              final currentUser = loggined.email;
              final messageWidget = MessageBubble(
                sender: messageSender,
                text: messageText,
                isMe: currentUser == messageSender,
              );

              if (currentUser == messageSender) {}
              messagewidgets.add(messageWidget);
              //message
            }
            return Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: messagewidgets,
              ),
            );
            // return messages;
          } else {
            return CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            );
          }
        }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messagetext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messagetext,
                        'sender': loggined.email,
                      });
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

// class MessageStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return;
//   }
// }

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});
  String sender;
  String text;
  bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius:isMe? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight:   Radius.circular(30.0),
                // bottomRight:  isMe? Radius.circular(30.0):Radius.circular(0.0),
                ): BorderRadius.only(
                // topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight:   Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                ),

            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
              child: Text(
                '${text}',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
