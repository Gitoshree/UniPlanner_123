import 'package:supabase_flutter/supabase_flutter.dart';

class TaskDatabase {
  final tasksTable = Supabase.instance.client.from('tasks');

  Future<void> createTask(String title, String type) async {
    await tasksTable.insert({'title': title, 'type': type, 'is_done': false});
  }

  Future<void> updateTask(int id, String title, String type) async {
    await tasksTable.update({'title': title, 'type': type}).eq('id', id);
  }

  Future<void> deleteTask(int id) async {
    await tasksTable.delete().eq('id', id);
  }

  Future<void> toggleDone(int id, bool done) async {
    await tasksTable.update({'is_done': done}).eq('id', id);
  }

  Future<List> fetchTasks() async {
    final response = await tasksTable.select();
    return response;
  }
}
