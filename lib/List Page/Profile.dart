import 'package:client/Current/currentUser.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Profile",
              style:TextStyle(fontSize: 40,color: Colors.white),
            ),
            Icon(Icons.account_box_outlined,size: 50)
          ],
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.cyan,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 1,
          shadowColor: Colors.pink,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,


            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child:
                     Text('Name: ${currentUser.username}',style:TextStyle(fontSize: 20,),),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child:
                    Text('Given Email Address: ${currentUser.username}@todo.com',style:TextStyle(fontSize: 20,))

                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  child:

                     Text('PassWord: ${currentUser.pass}',style:TextStyle(fontSize: 20,))

                ),



              ],
            ),
          ),
            ),
      ),
    );
  }
}
