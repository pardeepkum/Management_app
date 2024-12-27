import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Database/task_db.dart';
import '../model/task_model.dart';



final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>(
      (ref) => TaskNotifier(),
);

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }


  Future<void> _loadTasks() async {
    final taskList = await TaskDatabase.getTasks();
    state = taskList.map((task) => Task.fromMap(task)).toList();
  }




  Future<void> addTask(Task task) async {
    final taskMap = task.toMap();
    final id = await TaskDatabase.insertTask(taskMap);
    final newTask = task.copyWith(id: id);
    state = [...state, newTask];
  }


  Future<void> toggleCompletion(int index) async {
    final task = state[index];
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await TaskDatabase.updateTask(updatedTask.toMap());
    state = List.from(state)..[index] = updatedTask;
  }


  Future<void> updateTask(Task updatedTask) async {
    await TaskDatabase.updateTask(updatedTask.toMap());
    state = state.map((task) => task.id == updatedTask.id ? updatedTask : task).toList();
  }


  Future<void> deleteTask(int id) async {
    await TaskDatabase.deleteTask(id);
    state = state.where((task) => task.id != id).toList();
  }
}
