import 'package:chat_zz/constants.dart';
import 'package:chat_zz/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class LoginScreen extends StatefulWidget {
  static final id = 'loginscreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  late User value;
  void getUser() {
    try {} catch (e) {}
  }

  bool _showspiner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showspiner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 70.0,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    //Do something with the user input.
                    email = value;
                  },
                  decoration: Kconstantinputdecoration.copyWith(
                      fillColor: Colors.black,
                      hintText: "Enter your Email",
                      labelText: "Email")),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    //Do something with the user input.
                    password = value;
                  },
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: Kconstantinputdecoration.copyWith(
                      hintText: "Enter your password", labelText: "Password")),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      //Implement login functionality.
                      setState(() {
                        _showspiner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          _showspiner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
