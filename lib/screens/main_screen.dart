import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_app/models/tasks.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Box? _box;
  String? _newTaskContent;
  late double _deviceHeight, _deviceWidth;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green[200],
        // change the appbar height
        toolbarHeight: _deviceHeight * 0.12,
      ),
      body: _taskView(),
      floatingActionButton: _addTaskBtn(),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
        future: Hive.openBox('tasks'),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.connectionState == ConnectionState.done) {
            _box = _snapshot.data;
            return _taskList();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        var task = Task.fromMap(tasks[index]);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            tileColor: Colors.grey[300],
            title: Text(
              task.content,
              style: TextStyle(
                  decoration: task.done ? null : TextDecoration.lineThrough),
            ),
            subtitle: Text(task.timeStamp.toString()),
            trailing: task.done
                ? const Icon(
                    Icons.check_box_outline_blank,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.check_box_outlined,
                    color: Colors.green,
                  ),
            onTap: () {
              setState(() {
                task.done = !task.done;
                _box!.putAt(index, task.toMap());
              });
            },
            onLongPress: () {
              setState(() {
                _box!.deleteAt(index);
              });
            },
          ),
        );
      },
    );
  }

  Widget _addTaskBtn() {
    return FloatingActionButton(
      backgroundColor: Colors.green[200],
      onPressed: _displayTask,
      child: const Icon(Icons.add),
    );
  }

  void _displayTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            onSubmitted: (value) {
              if (_newTaskContent != null) {
                var _task = Task(
                  content: _newTaskContent!,
                  timeStamp: DateTime.now(),
                  done: false,
                );
                _box!.add(_task.toMap());
                setState(() {
                  _newTaskContent = null;
                });
              }
            },
            onChanged: (value) {
              setState(() {
                _newTaskContent = value;
              });
            },
          ),
        );
      },
    );
  }
}
