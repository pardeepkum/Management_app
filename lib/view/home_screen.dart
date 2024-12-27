import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../model/prefrences_model.dart';
import '../model/task_model.dart';
import '../screen_provider/task_provider.dart';
import '../utils/notification.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final preferences = ref.watch(preferencesProvider);

    List filteredTasks = tasks
        .where((task) =>
            task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            task.description.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(
              preferences.isDarkMode ? Icons.light_mode : Icons.dark_mode,

            ),
            onPressed: () {
              ref.read(preferencesProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context, ref);
        },
        child: Icon(Icons.add),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return _buildTaskListItem(context, ref, task, index);
                  },
                ),
              ),
              Expanded(child: Center(child: Text("Task Details"))),
            ],
          );
        } else {
          return ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return _buildTaskListItem(context, ref, task, index);
            },
          );
        }
      }),
    );
  }

  Widget _buildTaskListItem(
      BuildContext context, WidgetRef ref, Task task, int index) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text(task.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              _showEditTaskDialog(context, ref, task);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id!);
            },
          ),
          Icon(
            task.isCompleted ? Icons.check_circle : Icons.circle,
          ),
        ],
      ),
      onTap: () {
        ref.read(taskProvider.notifier).toggleCompletion(index);
      },
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Search Tasks"),
          content: TextField(
            controller: searchController,
            onChanged: (query) {
              setState(() {
                searchQuery = query;
              });
            },
            decoration:
                InputDecoration(hintText: "Search by title or description"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final task = Task(
                  title: titleController.text,
                  description: descriptionController.text,
                  isCompleted: false,
                  dateCreated: DateTime.now(),
                );
                ref.read(taskProvider.notifier).addTask(task);

                NotificationServices()
                    .showNotification(
                  title: 'Task Reminder',
                  body: 'Don\'t forget: ${titleController.text}',
                  payload: task.title,
                );

                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, WidgetRef ref, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedTask = task.copyWith(
                  title: titleController.text,
                  description: descriptionController.text,
                );
                ref.read(taskProvider.notifier).updateTask(updatedTask);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
