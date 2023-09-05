import 'package:firebaseproject/authenticate/authenticate.dart';
import 'package:firebaseproject/services/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userInstance = Provider.of<UserModel?>(context);
    print(userInstance.toString());
    return userInstance == null? Authenticate() : Home();
  }
}