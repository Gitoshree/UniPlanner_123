import 'package:finalproject/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 void main()async{
   await Supabase.initialize(
       url: "https://beacicjbivpzoontdwmd.supabase.co",
       anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlYWNpY2piaXZwem9vbnRkd21kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcyNjk0OTgsImV4cCI6MjA3Mjg0NTQ5OH0.KZ_Msfx7Lwj8897qEAJWML3hh7GfOUnzNOVs4k3XRBU");
   runApp(MyApp());
 }
 class MyApp extends StatelessWidget {
   const MyApp({super.key});

   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       home: WelcomePage(),
     );
   }
 }

