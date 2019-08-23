import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:uniapp/Setup/models.dart';

class DatabaseService 
{
  final Firestore _db = Firestore.instance;

  Stream<Student> streamStudent(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots()
        .map((snap) => Student.fromMap(snap.data));
  }

  Stream<List<Course>> streamCourse(FirebaseUser user) 
{ 

    var ref = _db.collection('users').document(user.uid).collection('courses');
        return ref.snapshots().map((list) =>
        list.documents.map((doc) => Course.fromFirestore(doc)).toList());
}

//  Future<void> createHero(String heroId) {
//     return _db.collection('heroes').document(heroId).setData({ /* some data */ });
//   }

}