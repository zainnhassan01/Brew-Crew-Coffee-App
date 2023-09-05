import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseproject/services/database.dart';
import 'package:firebaseproject/services/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userDataFromUserCredential(User? user){
    return user!=null? UserModel(uid: user.uid): null;
  }
  //stream for wrapper
  Stream<UserModel?> get userStream{
    return _auth.authStateChanges().map((user) => _userDataFromUserCredential(user));
  }
  //sign in anon...
  Future signInAnon () async {
    try{
    UserCredential result = await _auth.signInAnonymously();
    User? user = result.user;
    return _userDataFromUserCredential(user);
    } catch(e){
      print("Auth Error $e");
      return null;
    }
  }
  //register with email and password
  Future registerwithEmailAndPass(String name,String email,String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //setting his database values
      await BrewDatabase(uid: user!.uid).updateUser("0",name,100);
      return _userDataFromUserCredential(user);
    }catch(e){
      print("Register error => $e");
      return null;
    }
  }
  //sign in with email and password
  Future signingInWithEmailAndPassword(String email,String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userDataFromUserCredential(user);
    }catch(e){
      print("Login error => $e");
      return null;
    }                                                                                                                                                                
  }
  //signin using google
  Future signInUsingGoogle () async{
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? gAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication gAuth = await gAccount!.authentication;
    final AuthCredential credential = await GoogleAuthProvider.credential(idToken: gAuth.idToken,accessToken: gAuth.accessToken);
    final UserCredential result = await _auth.signInWithCredential(credential);
    final User? user = result.user;
    print("User $user");
    bool condition = result.additionalUserInfo!.isNewUser;
    print(condition);
    if(result.additionalUserInfo!.isNewUser){
    print("New Account Registered");
    await BrewDatabase(uid: user!.uid).updateUser("0","New User",100);
    }
    return _userDataFromUserCredential(user);
  }

  //signOut
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print("SignOut Error $e");
    }
  }

}

class EmailAndPassword extends ChangeNotifier{
  String email = "";
  String password = "";
  String name = "";
  String error = "";
  EmailAndPassword();
  emailVal(String value) {
    email = value;
    notifyListeners();
  }
  errorVal(String value) {
    error = value;
    print("error from errorval $error");
    notifyListeners();
  }
  passwordVal(String value) {
    password = value;
    notifyListeners();
  }
  nameVal(String value) {
    name = value;
    notifyListeners();
  }
  clearValues(){
    email = "";
    password = "";
    error = "";
    notifyListeners();
  }
}