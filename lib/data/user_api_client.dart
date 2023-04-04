import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starbucksapp/models/user.dart';

class UserApiClient {
  final CollectionReference _usersRef = FirebaseFirestore.instance.collection('starusers');

  Future addUserToDatabase(StarUser user) async {
    final docUser = _usersRef.doc(user.id);
    user.id = docUser.id;
    final json = user.toJson();
    await docUser.set(json).then((value) => debugPrint('New User added!')).catchError((error) => debugPrint('Error!!!'));
  }

  Future<StarUser?> fetchUserData(String id) async {
    final docUser = _usersRef.doc(id);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return StarUser.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUserData(StarUser user) async {
    final docUser = _usersRef.doc(user.id);
    final updatedData = user.toJson();
    docUser.update(updatedData);
  }
}
