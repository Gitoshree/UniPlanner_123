import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Connect to your Supabase table named "course"
class CourseDatabase {
  final coursesTable = Supabase.instance.client.from("course");

  Future<void> createCourse(String title, String code, String instructor) async {
    await coursesTable.insert({
      'course_title': title,
      'course_code': code,
      'instructor': instructor,
    });
  }

  Future<void> updateCourse(int id, String title, String code, String instructor) async {
    await coursesTable.update({
      'course_title': title,
      'course_code': code,
      'instructor': instructor,
    }).eq('id', id);
  }

  Future<void> deleteCourse(int id) async {
    await coursesTable.delete().eq('id', id);
  }

  Stream<List<Map<String, dynamic>>> getCoursesStream() {
    return coursesTable.stream(primaryKey: ['id']);
  }
}

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final titleController = TextEditingController();
  final codeController = TextEditingController();
  final instructorController = TextEditingController();
  final courseDb = CourseDatabase();

  void addOrUpdateCourse({dynamic id, String? oldTitle, String? oldCode, String? oldInstructor}) {
    titleController.text = oldTitle ?? "";
    codeController.text = oldCode ?? "";
    instructorController.text = oldInstructor ?? "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? "New Course" : "Update Course"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Course Title")),
            TextField(controller: codeController, decoration: const InputDecoration(labelText: "Course Code")),
            TextField(controller: instructorController, decoration: const InputDecoration(labelText: "Instructor")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              try {
                final title = titleController.text;
                final code = codeController.text;
                final instructor = instructorController.text;

                if (id == null) {
                  await courseDb.createCourse(title, code, instructor);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Course added: $title")));
                } else {
                  await courseDb.updateCourse(id, title, code, instructor);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Course updated: $title")));
                }

                Navigator.pop(context);
                titleController.clear();
                codeController.clear();
                instructorController.clear();
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

  void deleteCourse(dynamic id) async {
    try {
      await courseDb.deleteCourse(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Course deleted")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Courses",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addOrUpdateCourse(),
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/The Sky .jpg",
              fit: BoxFit.cover,
            ),
          ),
          StreamBuilder(
            stream: courseDb.getCoursesStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final courses = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 boxes per row
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final id = course['id'];
                    final title = course['course_title'];
                    final code = course['course_code'];
                    final instructor = course['instructor'];

                    return Card(
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title ?? "No Title", style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("Code: ${code ?? "N/A"}"),
                            Text("Instructor: ${instructor ?? "N/A"}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () => addOrUpdateCourse(
                                    id: id,
                                    oldTitle: title,
                                    oldCode: code,
                                    oldInstructor: instructor,
                                  ),
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                ),
                                IconButton(
                                  onPressed: () => deleteCourse(id),
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            )
                          ],
                        ),
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
