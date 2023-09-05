import 'package:firebaseproject/authenticate/register.dart';
import 'package:firebaseproject/authenticate/signin.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool signIn = true;
  void toggleBetween() {
    setState(() {
    signIn = !signIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(signIn == true){
      return SignIn(toggleBetween: toggleBetween);
    }
    else{
      return Register(toggleBetween: toggleBetween);
    }
  }
}