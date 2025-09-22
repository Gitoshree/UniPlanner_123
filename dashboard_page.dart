
import 'package:finalproject/auth/auth_service.dart';
import 'package:finalproject/pages/course_page.dart';
import 'package:finalproject/pages/signin.dart';
import 'package:finalproject/pages/task_page.dart';
import 'package:finalproject/pages/user_page.dart'; // import your UserPage
import 'package:finalproject/pages/welcome.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final authService = AuthService();

  void signOut() async {
    await authService.signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const SignIn()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/The Sky .jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Dashboard content
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome, ${currentEmail ?? 'User'}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 20),

                  // Users Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(width, 50),
                        backgroundColor: Colors.black12),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const UserPage()),
                      );
                    },
                    child: const Text("Users",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(width, 50),
                        backgroundColor: Colors.black12),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CoursePage()), // Navigate to CoursePage
                      );
                    },
                    child: const Text("Courses",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(width, 50),
                        backgroundColor: Colors.black12),
                    onPressed: () {
                      // TODO: Tasks page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TaskPage()),
                      );
                    },
                    child: const Text("Tasks",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(width, 50),
                        backgroundColor: Colors.black12),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WelcomePage()),
                      );
                    },
                    child: const Text("Logout",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

