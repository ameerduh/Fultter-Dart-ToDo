import 'dart:convert';
import 'dart:io';
import 'package:client/Current/currenList.dart';
import 'package:client/objects/ListsObject.dart';
import 'package:client/objects/TasksObjects.dart';
import 'package:client/Current/currentUser.dart';
import 'package:flutter/material.dart';

class Lists extends StatefulWidget {


  const Lists({super.key});


  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[300],
        drawer: Drawer(
          backgroundColor: Colors.indigo[300],
          child: ListView(
            children: [

               UserAccountsDrawerHeader(

                accountName:Text(currentUser.username) ,
                accountEmail: Text("${currentUser.username}@todo.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white30,
                  child: Text("NOT_SET"),
                ),
              ),
              ListTile(
                onTap: (){
                  Navigator.pushNamed(context, '/Profile');
                },
                title: const Text("Profile"),
                trailing: const Icon(Icons.account_circle_sharp),
              ),
              ListTile(
                onTap: (){
                  Navigator.pushReplacementNamed(context, '/SignIn');
                },
                title: const Text("Sign out"),
                trailing: const Icon(Icons.account_box_outlined),
              ),
              const Divider(color:Colors.grey ,thickness:2 ,height: 0,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                },
                title: const Text("close"),
                trailing: const Icon(Icons.close),
              ),

            ],
          ),
        ),

        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Your Lists",
            style:TextStyle(fontSize: 20,color: Colors.white) ,
          ),
          backgroundColor: Colors.grey[700],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            createNewList();
          },
          backgroundColor: Colors.white30,
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
                child: const Text("All the Lists",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  onTap: (){
                    String request ="getAllTheDone"+"-"+currentUser.username;
                    getAllDoneTasks(request);

                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  tileColor: Colors.white,
                  trailing: Container(
                    height:35 ,
                    width: 35,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.ac_unit),
                    ),
                  ),
                  title: const Text("Done:", style: TextStyle(fontSize: 17),
                  ),
                ),

              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  onTap: (){
                    String request ="getAllTheFav"+"-"+currentUser.username;
                   getAllTheFavTasks(request);

                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  tileColor: Colors.white,
                  trailing: Container(
                    height:35 ,
                    width: 35,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.ac_unit),
                    ),
                  ),
                  title: const Text("Important:", style: TextStyle(fontSize: 17),
                  ),
                ),

              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 1) ,
                child: ListView.builder(
                  shrinkWrap: true,
                 itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(3),
                      child: ListTile(
                        onTap: () {
                          currentList.name=todoList[index];
                          String request = "getTasks"+"-"+currentUser.username+"-"+currentUser.pass+"-"+todoList[index];
                          print(request);
                          getAllTasks(request,context);
                        },

                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        tileColor: Colors.blueGrey[400],
                        title: Text(todoList[index],style: const TextStyle(fontSize: 20),),

                        trailing:  SizedBox(
                          height:150,
                          width: 150,
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  editName(index);
                                },
                                child: const Icon(Icons.edit_note,color: Colors.black,),
                              ),

                              TextButton(
                                onPressed: () {
                                  deleteList(index);
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
        )
    );
  }

  getAllTheFavTasks(String request) async {
    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.listen((response) {
        String decoded = utf8.decode(response);
        if(decoded=="nothing"){
          new TasksObjects("", "", "");
          print("entered empty");
          Navigator.pushNamed(context, '/Tasks');
          socket.write('OVER');

        }
        if(decoded!="nothing") {
          var order = decoded.split("\n");
          TasksObjects.TasksList = [];
          for (String s in order) {
            var data = s.split("-");
            new TasksObjects(data[0], data[1], data[2]);
          }

          Navigator.pushNamed(context, '/Tasks');

          socket.write('OVER');
        }
      });


    });
  }

  getAllDoneTasks(String request) async {
    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.listen((response) {
        String decoded = utf8.decode(response);
        if(decoded=="nothing"){
          new TasksObjects("", "", "");
          print("entered empty");
          Navigator.pushNamed(context, '/Tasks');
          socket.write('OVER');

        }
        if(decoded!="nothing") {
          var order = decoded.split("\n");
          TasksObjects.TasksList = [];
          for (String s in order) {
            var data = s.split("-");
            new TasksObjects(data[0], data[1], data[2]);
          }

          Navigator.pushNamed(context, '/Tasks');

          socket.write('OVER');
        }
      });


    });

  }

  getAllTasks(String request,context) async {
    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.listen((response) {
        String decoded = utf8.decode(response);
        if(decoded=="nothing"){
          new TasksObjects("", "", "");
          print("entered empty");
          Navigator.pushNamed(context, '/Tasks');
          socket.write('OVER');

        }
        if(decoded!="nothing") {
          var order = decoded.split("\n");
          TasksObjects.TasksList = [];
          for (String s in order) {
            var data = s.split("-");
            new TasksObjects(data[0], data[1], data[2]);
          }

          Navigator.pushNamed(context, '/Tasks');

          socket.write('OVER');
        }
      });


    });
  }

  List todoList = ListObjects.lists;

  var newController = TextEditingController();

  void editName(int index){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.blueGrey,
        content: SizedBox(
          height: 140,
          child: Column(
            children: [
              TextField(
                controller: newController,
                decoration: const InputDecoration(hintText: "type a new name",border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  //save button
                  TextButton(
                      onPressed:(){
                        print(currentUser.username);
                        print(todoList[index]);
                        String request="editListName"+"-"+currentUser.username+"-"+todoList[index]+"-"+newController.text;
                        editNameFile(request);
                        todoList[index] = newController.text;
                        Navigator.pop(context);
                        setState(() {});
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

  editNameFile(String request) async {
    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.write('OVER');

    });

  }

  void deleteList(int index){
    String request = "deleteList"+"-"+currentUser.username+"-"+todoList[index];
    deleteListFile(request);
    setState(() {
      todoList.removeAt(index);
    });
  }
deleteListFile(String request) async {
  await Socket.connect('10.0.2.2', 300).then((socket) async {
    socket.write(request);
    socket.write('OVER');
  });


}

  void createNewList(){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.blueGrey,
        content: SizedBox(
          height: 140,
          child: Column(
            children: [
              TextField(
                controller: newController,
                decoration: const InputDecoration(hintText: "type a new list",border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  //save button
                  TextButton(
                      onPressed:(){
                        addList(newController.text);
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

  addList(String c) async {
    String request = "AddList"+"-"+currentUser.username+"-"+c;
    await Socket.connect('10.0.2.2', 300).then((socket) async {
      socket.write(request);
      socket.listen((response) {
        String decoded = utf8.decode(response);
        if(decoded=='true'){
          setState(() {
            todoList.add(newController.text);
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



