import 'dart:convert';
import 'dart:io';
import 'package:client/Current/currenList.dart';
import 'package:client/objects/TasksObjects.dart';
import 'package:client/Current/currentUser.dart';
import 'package:flutter/material.dart';



class Tasks extends StatefulWidget {
  const Tasks({super.key});


  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Your Tasks",
            style:TextStyle(fontSize: 20,color: Colors.white) ,
          ),
          backgroundColor: Colors.grey[700],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            createNewText();
          },
          backgroundColor: Colors.grey,
          child: const Icon(Icons.add,color: Colors.black),
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    prefixIcon: Icon(Icons.search),
                    prefixIconConstraints: BoxConstraints(maxHeight: 20,maxWidth: 25),
                    border: InputBorder.none,
                    hintText: 'search',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10,left: 10,bottom: 5,right: 10),
                child: const Text("All the Tasks",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 1) ,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: todo.length,
                  itemBuilder: (context, index) {
                    bool x;
                    bool y;
                    if(todo[index][1]=='true'){
                      x=true;
                    }else{x=false;}

                    if(todo[index][2]=='true'){
                      y=true;
                    }else{y=false;}

                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: ListTile(
                        onTap: () {

                        },

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        tileColor: Colors.deepOrangeAccent[100],

                        title: Text(
                          todo[index][0],
                          style: TextStyle(
                            fontSize:20 ,
                            decoration: x? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),


                        leading:Checkbox(value: x, onChanged: (value) => checkBoxChanged(value,index)) ,

                        trailing: SizedBox(
                          height:150 ,
                          width: 150,
                          child: Row(

                              children: [

                                TextButton(


                                  child: Icon(y? Icons.star : Icons.star_border,color: Colors.yellow,),
                                  onPressed: () {

                                    String request = "changeFav"+"-"+currentUser.username+"-"+currentList.name+"-"+todo[index][0]+"-"+todo[index][2];
                                    favChanged(request);
                                    if(todo[index][2]=='true') todo[index][2]='false';
                                    else todo[index][2] = 'true';
                                    setState(() {
                                    });
                                  },

                                ),

                                TextButton(
                                  onPressed: () {
                                    deleteTask(index);
                                  },
                                  child: const Icon(Icons.delete_rounded,color: Colors.black,),
                                ),
                              ],
                            ),
                        ),


                      ),
                    );

                  },
                ),
              ),
            ],


          ),
        ),
      );

  }



  Future<void> favChanged(String request) async {
    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.write('OVER');
    });
  }

  List todo = TasksObjects.TasksList;

  var newController = TextEditingController();

  void checkBoxChanged(bool? value,int index){
    String request="checkBox"+"-"+currentUser.username+"-"+currentList.name+"-"+todo[index][0]+"-"+todo[index][1];
    checkBosFile(request);
    setState(() {
      if(todo[index][1]=='true')todo[index][1]='false';
      else todo[index][1]='true';
    });
  }

  checkBosFile(String request) async {
  await Socket.connect('10.0.2.2', 300).then((socket) async {
    socket.write(request);
    socket.write('OVER');
  });
}

  void deleteTask(int index){
    String request ="deleteTask"+"-"+currentUser.username+"-"+currentList.name+"-"+todo[index][0];
    deleteTaskFile(request);
    setState(() {
      todo.removeAt(index);
    });
  }

  deleteTaskFile(String request) async {
    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.write('OVER');
    });
  }

  void createNewText(){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.blueGrey,
        content: SizedBox(
          height: 140,
          child: Column(
            children: [
              TextField(
                controller: newController,
                decoration: const InputDecoration(hintText: "type a new task",border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  //save button
                  TextButton(
                      onPressed:(){
                        addTask([newController.text,'false','false']);
                      },
                      style:TextButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text('Done!'))
                ],
              ),
            ],
          ),
        ),
      );
    },);
  }

  addTask(List<String> t) async {
    String request = "AddTask"+"-"+currentUser.username+"-"+currentList.name+"-"+t[0]+"-"+t[1]+"-"+t[2];
    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.listen((response) {
        String decoded = utf8.decode(response);
        if(decoded == 'true'){
          setState(() {
            todo.add([newController.text,'false','false']);
            newController.clear();
            Navigator.pop(context);
          });
        }
        else{Navigator.pop(context);}

        socket.write('OVER');
      });



    });
  }
}


