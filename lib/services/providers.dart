import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class UserData extends ChangeNotifier{
  String? currentName;
  String? currentSugars;
  int? currentStrength;

  void updateCurrentName(String name){
    currentName = name;
    notifyListeners();  
  }
  void updateCurrentSugars(String sugar){
    currentSugars = sugar;
    notifyListeners();  
  }
  void updateCurrentStrength(int strength){
    currentStrength = strength;
    notifyListeners();  
  }
  void clearValues(String? n,String? s,int? st){
    n = "";
    s = "";
    st = 0;  
    notifyListeners();
  }
}