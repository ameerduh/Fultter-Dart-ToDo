import 'dart:convert';
import 'dart:io';

import 'package:client/objects/ListsObject.dart';
import 'package:client/Current/currentUser.dart';
import 'package:flutter/material.dart';



class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool obscurePassword = true;
  //Catching User Name
  var usernameController = TextEditingController();
  //Catching Password
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
        return Scaffold(

          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Welcome to TODO app",
              style:TextStyle(fontSize: 20,color: Colors.white),

            ),
            backgroundColor: Colors.pink,
            leading: Container(
              color: Colors.deepPurpleAccent,
              child: const Icon(
                Icons.account_balance,color: Colors.black,
              ),
            ),
          ),


          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: const Text("Sign in page",style: TextStyle(color: Colors.white,fontSize: 15)),
                  ),
                ),

                const Row(

                  children: [
                    Text("Email or User",style: TextStyle(fontSize:20 ,color:Colors.blueGrey ,fontWeight:FontWeight.bold )),

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
                    Text("Password",style: TextStyle(fontSize:20 ,color:Colors.blueGrey ,fontWeight:FontWeight.bold )),

                  ],
                ),

                TextField(
                  controller: passController,

                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    filled: false,
                    prefixIcon: InkWell(
                      onTap: () {
                        obscurePassword = !obscurePassword;
                        setState(() {});
                      },
                      child: Icon(
                        obscurePassword ? Icons.lock : Icons.lock_open,
                        color: Colors.deepOrange,
                      ),
                    ),
                    suffixIcon: const Icon(Icons.password),
                    hintText: "password",
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                  textAlign: TextAlign.center,

                ),

                Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(0,50, 30, 0),
                  child: TextButton(
                       onPressed: ()  {
                         currentUser.username=usernameController.text;
                         currentUser.pass=passController.text;
                         String request = "verify-${usernameController.text}-${passController.text}";
                         signIn(request,context);
                      },
                      style: TextButton.styleFrom(

                      fixedSize: const Size(340, 60),
                      backgroundColor: Colors.pink[100],
                    ),
                      child: const Text("Enter"),
                  ),
                ),

                Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(0,50, 30, 0),
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/SignUp');
                    },
                    style: TextButton.styleFrom(

                      fixedSize: const Size(340, 60),
                      backgroundColor: Colors.blue[100],
                    ),
                    child: const Text("Don't have an account?"),
                  ),
                ),
              ],
            ),
          ),
        );


  }

  signIn(String request,context) async {

    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.listen((response) {
        String decoded = utf8.decode(response);
          var order = decoded.split("\n");
          int i = 0;
          ListObjects.lists = [];
          for (String s in order) {
            if (i != order.length - 1) {
              ListObjects.lists.add(s);
            }
            else {
              if (s == 'true') {
                socket.write('OVER');
                Navigator.pushReplacementNamed(context, '/Lists');

              }

              if(s=="noFiles"){
                print("nofiles");
                socket.write("OVER");
                ListObjects.lists=[];
                addList();
                Navigator.pushReplacementNamed(context, '/Lists');
              }

            }
            i++;
          }



      });


    });

  }

  addList() async {
    ListObjects.lists.add("welcome");
    String request = "AddList"+"-"+currentUser.username+"-"+"Welcome";
    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.write('OVER');

    });
  }
}




