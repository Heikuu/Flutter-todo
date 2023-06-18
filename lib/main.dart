import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task.dart';

///main function
void main() {
  runApp(TodoApp());
}

/// # TodoApp
/// 
/// @author HeinhtetLinn
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskList(),
      child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TaskListScreen(),
      ),
    );
  }
}

/// # TaskListScreen
/// 
/// @author HeinhtetLinn
class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: TaskListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

/// # TaskListView
/// 
/// @author HeinhtetLinn
class TaskListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var taskList = context.watch<TaskList>();

    return ListView.builder(
      itemCount: taskList.tasks.length,
      itemBuilder: (context, index) {
        var task = taskList.tasks[index];
        return ListTile(
          title: Text(task.title),
          trailing: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              taskList.toggleTaskCompletion(index);
            },
          ),
        );
      },
    );
  }
}

/// # AddTaskScreen
/// 
/// @author HeinhtetLinn
class AddTaskScreen extends StatelessWidget {
  final TextEditingController _textEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Task',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var taskTitle = _textEditingController.text;
                if (taskTitle.isNotEmpty) {
                  var taskList = context.read<TaskList>();
                  taskList.addTask(Task(taskTitle));
                  Navigator.pop(context);
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

/// # TaskList
/// The ChangeNotifier
/// 
/// @author HeinhtetLinn
class TaskList with ChangeNotifier {
  List<Task> tasks = [];

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    var task = tasks[index];
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }
}
