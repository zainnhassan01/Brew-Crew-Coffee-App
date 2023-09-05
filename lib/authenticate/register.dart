import 'package:firebaseproject/services/firebaseauth.dart';
import 'package:firebaseproject/services/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Register extends StatefulWidget {
  final Function? toggleBetween;
  Register({this.toggleBetween});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FocusNode _focusname = FocusNode();
  FocusNode _focusEmail = FocusNode();
  FocusNode _focusPassword = FocusNode();
  final AuthServices _auth = AuthServices();
  GlobalKey<FormState> _globalKey = GlobalKey();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    String name = context.watch<EmailAndPassword>().name;
    String error = context.watch<EmailAndPassword>().error;
    String email = context.watch<EmailAndPassword>().email;
    String password = context.watch<EmailAndPassword>().password;
    return loading == true? Loading():
    Scaffold(
          backgroundColor: Colors.brown[200],
      appBar: AppBar(
        title: Text("Sign Up for Brew Crew",style: TextStyle(color: Colors.white),),
      ),
      body: GestureDetector(
        onTap: () {
          _focusname.unfocus();
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Container(
          color: Colors.brown[200],
          child: Form(
            key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30,50,30,10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      focusNode: _focusname,
                      onChanged: (value) {
                        context.read<EmailAndPassword>().nameVal(value);
                      },
                      validator: (value) => value!.isEmpty ? "Enter Username": null,
                      maxLines: 1,
                      autocorrect: false,
                      enableSuggestions: true,
                      decoration:const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                           ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.person_rounded),
                        label: Text("Username",style: TextStyle(color: Colors.white)),
                        hintText: "Enter your username",
                      ),
                    ),
                    const SizedBox(height: 30,),
                    TextFormField(
                      focusNode: _focusEmail,
                      onChanged: (value) {
                        context.read<EmailAndPassword>().emailVal(value);
                      },
                      validator: (value) => value!.isEmpty && value.contains("@") ? "Enter Valid Email": null,
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
                        label: Text("Email",style: TextStyle(color: Colors.white)),
                        hintText: "Enter a valid email",
                      ),
                    ),
                   const SizedBox(height: 30,),
                    TextFormField(
                      focusNode: _focusPassword,
                      onChanged: (value) {
                        context.read<EmailAndPassword>().passwordVal(value);
                      },
                      validator: (value) => (value!.length <= 5)? "Password should be greater than 5 characters" : null,
                      maxLines: 1,
                      autocorrect: false,
                      obscureText: true,
                      decoration:const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                           ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock),
                        label: Text("Password",style: TextStyle(color: Colors.white)),
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
                          dynamic result = await _auth.registerwithEmailAndPass(name,email, password);
                          if(result == null)  {
                            setState(() {
                              loading = false;
                            });
                            context.read<EmailAndPassword>().errorVal("Sign Up Failed, Enter Again");
                          }
                        }
                      }, 
                      child: const Text("Register",style: TextStyle(color: Colors.white),)),
                      const SizedBox(height: 5,),
                      error.isNotEmpty? Text("Error: $error",style: TextStyle(color: Colors.black,fontSize: 16.5),):  
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",style: TextStyle(color: Colors.brown,fontSize: 16.5),),
                          TextButton(
                            onPressed: () {
                              context.read<EmailAndPassword>().clearValues();
                              widget.toggleBetween!();
                            }, 
                            child: const Text("Sign In",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.5),)
                            )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}