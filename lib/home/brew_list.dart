import 'package:firebaseproject/services/brewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
class BrewList extends StatefulWidget {
  const BrewList({super.key});

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
  final brew = Provider.of<List<BrewModel>?>(context);
  return Padding(
    padding:const EdgeInsets.only(top:8.0,left: 8,right: 8),
    child: ListView.builder(
      itemCount: brew!.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.brown[(brew[index].strength!)],
            ),
            title: Text(brew[index].name!,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            subtitle: Text("Takes ${brew[index].sugars!} sugar(s)",style: TextStyle(fontSize: 18,)),
          ),
        );
      },
    ),
  );
}
}