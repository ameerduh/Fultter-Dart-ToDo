class TasksObjects {
  static List<List<String>> TasksList = [];
  String name = "";
  String checked = "";
  String starred = "";
  List<String> task = [];

  TasksObjects(String name, String checked, String starred) {
    this.name = name;
    this.checked = checked;
    this.starred = starred;
    this.task = [name, checked, starred];
    TasksObjects.TasksList.add(task);
    if(name == "" && checked=="" && starred==""){
      TasksList=[];
    }
  }

}
