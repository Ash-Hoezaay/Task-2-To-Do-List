import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Set scaffold background color
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black, // Set headline text color
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText2: TextStyle(
            color: Colors.black87, // Set body text color
            fontSize: 16.0,
          ),
        ),
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
  }

  void updateTask(int index, String title) {
    setState(() {
      tasks[index].title = title;
    });
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Colors.blue, // Set app bar background color
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      toggleTaskCompletion(index);
                    },
                    activeColor: Colors.blue, // Set checkbox active color
                  ),
                  onTap: () {
                    // Navigate to task edit screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskEditScreen(
                          task: task,
                          onUpdate: (title) {
                            updateTask(index, title);
                            Navigator.pop(context); // Pop back to task list screen
                          },
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Task'),
                        content:
                        Text('Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteTask(index);
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Note: Long press on a task to delete it. Tap on a task to edit it.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to task creation screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskCreateScreen(
                onCreate: (title) {
                  addTask(title);
                  Navigator.pop(context); // Pop back to task list screen
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, // Set FAB background color
      ),
    );
  }
}

class TaskCreateScreen extends StatelessWidget {
  final Function(String) onCreate;

  TaskCreateScreen({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    String title = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
        backgroundColor: Colors.blue, // Set app bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                title = value;
              },
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: Colors.blue), // Set label color
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Set border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Set border color
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                onCreate(title);
              },
              child: Text('Create Task'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue), // Set button background color
                foregroundColor: MaterialStateProperty.all(Colors.white), // Set button text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskEditScreen extends StatelessWidget {
  final Task task;
  final Function(String) onUpdate;
  final TextEditingController _textEditingController;

  TaskEditScreen({required this.task, required this.onUpdate})
      : _textEditingController = TextEditingController(text: task.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        backgroundColor: Colors.blue, // Set app bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: Colors.blue), // Set label color
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Set border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Set border color
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final title = _textEditingController.text.trim();
                if (title.isNotEmpty) {
                  onUpdate(title);
                  Navigator.pop(context);
                }
              },
              child: Text('Update Task'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue), // Set button background color
                foregroundColor: MaterialStateProperty.all(Colors.white), // Set button text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
