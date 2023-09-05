import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseproject/home/bottomSheet.dart';
import 'package:firebaseproject/services/brewmodel.dart';
import 'package:firebaseproject/services/database.dart';
import 'package:firebaseproject/services/firebaseauth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brew_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthServices _auth = AuthServices();  

  void _bottomSheetWidget(BuildContext context) {
    showModalBottomSheet(context: context, 
    builder: (context) {
      return BottomSheetW();
    },
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<BrewModel>>.value(
      initialData: BrewDatabase().initialData(),
      value: BrewDatabase().brewStream,
      child: Scaffold(
        backgroundColor: Colors.brown[200],
        appBar: AppBar(
          backgroundColor: Colors.brown[700],
          title: Text("Home"),
          actions: [
            IconButton(
            onPressed: () => _bottomSheetWidget(context),
            icon: Icon(Icons.settings)
            ),
            IconButton(
              onPressed: () async{
                await _auth.signOut();
              }, 
              icon: Icon(Icons.logout))
          ],
        ),
        body: BrewList(),
      ),
    );
  }
}