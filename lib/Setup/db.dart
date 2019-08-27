import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniapp/Admin/allusers.dart';
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



Future<void> updateUser(userId, _fname, _lname, _address, _contact, _dob, _email){

  return _db
  .collection('users')
  .document(userId)
  .setData(
    {
      'first_name': _fname,
      'last_name': _lname,
      'Contact_no':_contact,
      'Photourl': 'https://icon-library.net/images/avatar-icon-images/avatar-icon-images-4.jpg' ?? '',
      'address':_address ?? '',
      'date_of_birth':_dob.toString() ?? '',
      'email': _email ?? '',
      'role': 'Student' ?? ''
    },merge: true
  );
}

//  Future<void> createHero(String heroId) {
//     return _db.collection('heroes').document(heroId).setData({ /* some data */ });
//   }

}