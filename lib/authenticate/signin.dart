import 'package:firebaseproject/services/firebaseauth.dart';
import 'package:firebaseproject/services/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SignIn extends StatefulWidget {
final Function? toggleBetween;
SignIn({this.toggleBetween});


@override
State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
GlobalKey<FormState> _globalKey = GlobalKey();
final AuthServices _auth = AuthServices();
FocusNode _focusNode = FocusNode();
FocusNode _focusNode2 = FocusNode();
bool loading = false;
@override
Widget build(BuildContext context) {
  String error = context.watch<EmailAndPassword>().error;
  String email = context.watch<EmailAndPassword>().email;
  String password = context.watch<EmailAndPassword>().password;
  return loading == true? Loading():
  Scaffold(
    appBar: AppBar(
      title: Text("Sign In to Brew Crew",style: TextStyle(color: Colors.white),),
    ),
    body: GestureDetector(
      onTap: (){
          _focusNode.unfocus();
          _focusNode2.unfocus();
      },
      child: Container(
        alignment: Alignment.center,
        color: Colors.brown[200],
        child: Form(
          key: _globalKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30,50,30,10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  focusNode: _focusNode,
                  onChanged: (value) {
                    context.read<EmailAndPassword>().emailVal(value);
                  },
                  validator: (value) => value!.isEmpty ? "Invalid Email": null,
                  maxLines: 1,
                  autocorrect: false,
                  enableSuggestions: true,
                  decoration:const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                    prefixIcon: Icon(Icons.email),
                    label: Text("Email",style: TextStyle(backgroundColor: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                    hintText: "Enter a valid email",
                  ),
                ),
                const SizedBox(height: 30,),
                TextFormField(
                  focusNode: _focusNode2,
                  onChanged: (value) {
                    context.read<EmailAndPassword>().passwordVal(value);
                  },
                  validator: (value) => (value!.length <= 5)? "Password should be greater than 5 characters" : null,
                  maxLines: 1,
                  autocorrect: false,
                  obscureText: true,
                  decoration:const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                    prefixIcon: Icon(Icons.lock),
                    label: Text("Password",style: TextStyle(backgroundColor: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                    hintText: "Enter your password",
                  ),
                ),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () async {
                    if(_globalKey.currentState!.validate()){
                      setState(() {
                          loading = true;
                        });
                      dynamic result = await  _auth.signingInWithEmailAndPassword(email, password);
                      print(result);
                      if(result == null) {
                          setState(() {
                            loading = false;
                          });
                          context.read<EmailAndPassword>().errorVal("Sign Ip Failed, Check Email...");
                        }
                    }
                  }, 
                  child: const Text("Sign In",style: TextStyle(color: Colors.white),)),
                  const SizedBox(height: 5,),
                  error.isNotEmpty? Text("Error: $error",style: TextStyle(color: Colors.black,fontSize: 16.5),):  
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?",style: TextStyle(color: Colors.brown,fontSize: 16.5),),
                      TextButton(
                        onPressed: () {
                          context.read<EmailAndPassword>().clearValues();
                          widget.toggleBetween!();
                        }, 
                        child: const Text("Sign Up",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.5),)
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          await _auth.signInUsingGoogle();
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            image: DecorationImage(image: AssetImage('assets/images/googleLogo.png'))
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}