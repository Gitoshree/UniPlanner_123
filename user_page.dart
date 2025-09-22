
import 'package:flutter/material.dart';
import 'package:finalproject/db/user_database.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final userDb = UserDatabase();

  void addOrUpdateUser({dynamic id, String? oldEmail, String? oldName}) {
    emailController.text = oldEmail ?? "";
    nameController.text = oldName ?? "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? "New User" : "Update User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")
          ),
          TextButton(
              onPressed: () async {
                try {
                  final email = emailController.text;
                  final name = nameController.text;

                  if (id == null) {
                    await userDb.createUser(email, name);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User added: $name")));
                  } else {
                    await userDb.updateUser(id, email, name);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User updated: $name")));
                  }

                  Navigator.pop(context);
                  emailController.clear();
                  nameController.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child: Text(id == null ? "Save" : "Update")
          ),
        ],
      ),
    );
  }

  void deleteUser(dynamic id) async {
    try {
      await userDb.deleteUser(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User deleted")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Users",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addOrUpdateUser(),
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
            stream: userDb.usersTable.stream(primaryKey: ['id']),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final id = user['id'];
                  final email = user['email'];
                  final fullName = user['full_name'];

                  return Card(
                    color: Colors.white70,
                    child: ListTile(
                      title: Text(fullName ?? "No Name"),
                      subtitle: Text(email ?? "No Email"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () => addOrUpdateUser(id: id, oldEmail: email, oldName: fullName),
                              icon: const Icon(Icons.edit, color: Colors.blue)
                          ),
                          IconButton(
                              onPressed: () => deleteUser(id),
                              icon: const Icon(Icons.delete, color: Colors.red)
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
