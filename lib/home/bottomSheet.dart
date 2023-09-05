import 'package:firebaseproject/services/database.dart';
import 'package:firebaseproject/services/loading.dart';
import 'package:firebaseproject/services/usermodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebaseproject/services/providers.dart';
class BottomSheetW extends StatefulWidget {
  const BottomSheetW({super.key});

  @override
  State<BottomSheetW> createState() => _BottomSheetWState();
}

class _BottomSheetWState extends State<BottomSheetW> {
  GlobalKey<FormState> _globalKey = GlobalKey();
  List<String> sugar = ['0','1','2','3','4'];
  @override
  Widget build(BuildContext context) {
    contextFunctions(String? n,String? s,int? st){
      context.read<UserData>().clearValues(n,s,st);
      Navigator.pop(context);
    }
  String? _currentName = context.watch<UserData>().currentName;
  String? _currentSugar  = context.watch<UserData>().currentSugars;
  int? _currentStrength = context.watch<UserData>().currentStrength;
  final user = Provider.of<UserModel?>(context);
    return StreamBuilder(
      stream: BrewDatabase(uid:user!.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserDataModel? user = snapshot.data;
          return Form(
          key: _globalKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.grey[300],
                  child: const Text(
                    "Update your BrewCrew Information",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                    ),)),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  initialValue: _currentName ?? user!.name,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: "Enter your username",
                  ),
                  onChanged: (value) {
                    context.read<UserData>().updateCurrentName(value);
                  },
                ),
              ),
              //dropdown
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.brown))
                  ),
                  value: _currentSugar ?? user!.sugars,
                  items: sugar.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text("$e sugars")
                    );
                  }).toList(), 
                  onChanged: (value) {
                    context.read<UserData>().updateCurrentSugars(value as String);
                  },
                  ),
              ),
              //slider
              Slider(
                label: "Strength",
                activeColor: Colors.brown[_currentStrength ?? user!.strength!],
                inactiveColor: Colors.brown[500],
                min: 100,
                max: 900,
                divisions: 8,
                value: (_currentStrength ?? user!.strength)!.toDouble(), 
                onChanged: (value){
                  context.read<UserData>().updateCurrentStrength(value.toInt());
                }
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 10),
                  child: ElevatedButton( 
                    child: const Text("Save Changes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),),
                    onPressed: () async{
                     await BrewDatabase(uid: user!.uid).updateUser(
                      _currentSugar ?? user.sugars!,
                      _currentName ?? user.name!,
                      _currentStrength ?? user.strength!,
                      );
                      contextFunctions(_currentName,_currentSugar,_currentStrength);
                    },
                  ),
                ),
            ],
          )
          );
        }
        else{
          return Loading();
        }
      },
    );
  }
}