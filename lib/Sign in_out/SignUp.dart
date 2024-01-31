import 'dart:convert';
import 'dart:io';

import 'package:client/Current/currentUser.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  @override
  Widget build(BuildContext context) {
          return Scaffold(
        
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Sign Up Fast & Easy",
              style:TextStyle(fontSize: 20,color: Colors.white) ,
            ),
            backgroundColor: Colors.deepOrange,
          ),
        
        
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                  child: Container(
                    color: Colors.cyan,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: const Text("Sign Up page",style: TextStyle(color: Colors.white,fontSize: 15)),
                  ),
                ),
        
                const Row(

                  children: [
                    Text("Set a user name or an email",style: TextStyle(fontSize:20 ,color:Colors.blueGrey ,fontWeight:FontWeight.bold )),

                  ],
                ),
        
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.account_circle_sharp),
                    hintText: "user name / email",
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Row(
        
                  children: [
                    Text("Set a Password",style: TextStyle(fontSize:20 ,color:Colors.blueGrey ,fontWeight:FontWeight.bold )),
        
                  ],
                ),
        
                TextField(
                  controller: passController,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.password),
                    hintText: "password",
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
        
                Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(0,50, 30, 0),
                  child: TextButton(
                    onPressed: (){
                      String request = "SignUp-${usernameController.text}-${passController.text}";
                      signUp(request,context);

                    },
                    style: TextButton.styleFrom(

                      fixedSize: const Size(340, 60),
                      backgroundColor: Colors.deepOrange[200],
                    ),
                    child: const Text("Sign up",style: TextStyle(color: Colors.black)),
                  ),

                ),

               Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  color: Colors.grey,
                  child: const Text(
                    "Attention: username must least be of 8 letters(must contain one capital and one small letter and one number and must not contain username)"
                 ,style: TextStyle(fontSize: 10), ),
                ),

              ],
            ),
          ),
        );
  }

  var usernameController = TextEditingController();
  var passController = TextEditingController();


  signUp(String request,context) async {

    await Socket.connect('10.0.2.2', 300).then((socket) {
      socket.write(request);
      socket.listen((response) {
        String decoded = utf8.decode(response);
        print(decoded);

        if(decoded=='true'){
          currentUser.username=usernameController.text;
          currentUser.pass=usernameController.text;
          Navigator.pushReplacementNamed(context, '/SignIn');
        }
        else {

        }

        socket.write('OVER');
      });

    });
  }

}
