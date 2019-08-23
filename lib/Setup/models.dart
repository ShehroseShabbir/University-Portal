import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String fname;
  final String lname;
  final int contactno;
  final String photoUrl;
  final String address;
  final String dob;
  final String role;

  Student(
      {this.id,
      this.fname,
      this.role,
      this.address,
      this.contactno,
      this.dob,
      this.lname,
      this.photoUrl});

  factory Student.fromMap(Map data) {
    data = data ?? {};
    return Student(
        fname: data['first_name'] ?? '',
        lname: data['last_name'] ?? '',
        contactno: data['Contact_no'] ?? 100,
        photoUrl: data['Photourl'] ?? '',
        address: data['address'] ?? '',
        dob: data['date_of_birth'] ?? '',
        role: data['role'] ?? '');

    // return Student(
    //   id: doc.documentID,
    //   fname: data['first_name'] ?? '',
    //   lname: data['last_name'] ?? '',
    //   contactno: data['Contact_no'] ?? 100,
    //   photoUrl: data['Photourl'] ?? '',
    //   address: data['address'] ?? '',
    //   dob: data['date_of_birth'] ?? '',
    //   role: data['role'] ?? ''
    // );
  }
}

class Course {
  final String id;
  final String courseName;

  Course({this.id, this.courseName});

  factory Course.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Course(
      id: doc.documentID,
      courseName: data['courseName']
    );
  }
}
