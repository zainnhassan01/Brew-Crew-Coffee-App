import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebaseproject/services/firebaseauth.dart';
import 'package:firebaseproject/services/providers.dart';
import 'package:firebaseproject/services/usermodel.dart';
import 'package:firebaseproject/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(
    MultiProvider(providers: [
      StreamProvider<UserModel?>.value(
      initialData: null,
      value: AuthServices().userStream,
      ),
      ChangeNotifierProvider(create: (context) => EmailAndPassword()),
      ChangeNotifierProvider(create: (context) => UserData(),)
    ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(brightness: Brightness.light,primary: Colors.brown.shade700)
      ),
      home: Wrapper(),
      ),
    ));
}
