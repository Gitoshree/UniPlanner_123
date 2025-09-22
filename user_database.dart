import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDatabase{
  final usersTable= Supabase.instance.client.from("users");


  Future<void>createUser(String email,String fullname)async{
    await usersTable.insert({
      'email':email,
      'full_name':fullname,
    });
  }
  //update

  Future<void>updateUser(int userId, String? email, String? fullname)async{
    await usersTable.update({
      'email': email,
      'full_name':fullname,}).eq('id', userId);
  }
  //delete
  Future<void> deleteUser(int userId) async {
    await usersTable.delete().eq('id', userId);
  }
  //fetch all users
  /// Fetch all users
  Future<List> fetchUsers() async {
    final response = await usersTable.select();
    return response;
  }
}