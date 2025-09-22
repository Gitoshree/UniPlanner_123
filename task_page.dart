
import 'package:flutter/material.dart';
import 'package:finalproject/db/task_database.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final titleController = TextEditingController();
  final typeController = TextEditingController();
  final taskDb = TaskDatabase();

  void showTaskDialog({dynamic id, String? oldTitle, String? oldType}) {
    titleController.text = oldTitle ?? "";
    typeController.text = oldType ?? "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? "New Task" : "Update Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: typeController, decoration: const InputDecoration(labelText: "Type (Assignment/Viva/Project)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final title = titleController.text;
              final type = typeController.text;
              try {
                if (id == null) {
                  await taskDb.createTask(title, type);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added: $title")));
                } else {
                  await taskDb.updateTask(id, title, type);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task updated: $title")));
                }
                Navigator.pop(context);
                titleController.clear();
                typeController.clear();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
              }
            },
            child: Text(id == null ? "Save" : "Update"),
          ),
        ],
      ),
    );
  }

  void deleteTask(dynamic id) async {
    await taskDb.deleteTask(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Task deleted")));
  }

  void markDone(dynamic id, bool current) async {
    await taskDb.toggleDone(id, !current);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTaskDialog(),
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/The Sky .jpg",
              fit: BoxFit.cover,
            ),
          ),
          StreamBuilder(
            stream: taskDb.tasksTable.stream(primaryKey: ['id']),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final tasks = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: tasks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final id = task['id'];
                    final title = task['title'];
                    final type = task['type'];
                    final isDone = task['is_done'] ?? false;

                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: const Offset(0, 3))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title ?? "No Title", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(type ?? "No Type"),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(isDone ? Icons.check_circle : Icons.circle_outlined,
                                    color: isDone ? Colors.green : Colors.grey),
                                onPressed: () => markDone(id, isDone),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                    onPressed: () => showTaskDialog(id: id, oldTitle: title, oldType: type),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () => deleteTask(id),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
