import 'package:flutter/material.dart';
import 'package:myapp/utils/dialog_box.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/utils/todo_item.dart';
import 'package:myapp/database/database.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();

  final _myBox = Hive.box("mybox");
  TodoDataBase db = TodoDataBase();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void deleteTask(int index) {
    setState(() {
      db.TodoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void markAsdone(int index) {
    setState(() {
      db.TodoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.TodoList[index][1] = !db.TodoList[index][1];
    });
    db.updateDataBase();
  }

  void onChanged(bool? value) {
    setState(() {});
  }

  void saveNewTask() {
    setState(() {
      db.TodoList.add([_controller.text, false]);
      _controller.clear();
      Navigator.of(context).pop();
    });
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: saveNewTask,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        title: const Text("TODO", style: TextStyle(
        color: Colors.white),),
        backgroundColor: Colors.deepPurple[400],
        elevation: 10,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.deepPurple[400],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: db.TodoList.length,
        itemBuilder: (context, index) {
          return TodoItem(
            isChecked: db.TodoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            todoText: db.TodoList[index][0],
            onPressed: (context) => deleteTask(index),
            );
            
          
        }));
  }
}
