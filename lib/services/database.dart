import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseproject/services/brewmodel.dart';
import 'package:firebaseproject/services/usermodel.dart';
class BrewDatabase{

  final String? uid;
  BrewDatabase({this.uid});
  final CollectionReference _dataCollection = FirebaseFirestore.instance.collection("Brew");

  //instantiating user and updating user info  
  Future updateUser(String sugar,String name, int strength)async{
    return await _dataCollection.doc(uid).set({
      "sugars":sugar,
      "name": name,
      "strength": strength,
    });
  }
  List<BrewModel> _data = [BrewModel(sugars:"",name: "",strength:0)];
  List<BrewModel> initialData (){
    return _data;
  }
  List<BrewModel> _brewModel (QuerySnapshot snapshot) {
    return snapshot.docs.map((i) {
      return BrewModel(
        sugars: i.get('sugars') ?? "",
        name: i.get('name') ?? '',
        strength: i.get('strength') ?? 100
      );
    }).toList();
  }
  //stream for brew
  Stream<List<BrewModel>> get brewStream {
    return _dataCollection.snapshots()
    .map(_brewModel);
  }

  UserDataModel _snapshotForuserModel(DocumentSnapshot snapshot) {
    return UserDataModel(
    uid: uid,
    name: snapshot.get('name'),
    sugars: snapshot.get('sugars'),
    strength: snapshot.get('strength'),
    );
  }
  Stream<UserDataModel> get userData {
    return _dataCollection.doc(uid).snapshots().map(_snapshotForuserModel);
  }
}