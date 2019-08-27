import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniapp/Setup/db.dart';
import 'package:uniapp/Setup/models.dart';

class MyUnits extends StatefulWidget {
  @override
  _MyUnitsState createState() => _MyUnitsState();
}

class _MyUnitsState extends State<MyUnits> {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<FirebaseUser>(context);
    if(user != null){
    return Scaffold(
      appBar: new AppBar(
        title: Text('Your Enrolled Units '),
      ),
      body: new Container(
        child: StreamProvider<List<Course>>.value(
            // All children will have access to Course data
            value: db.streamCourse(user),
            child: new CourseListBuilder()),
      ),
    );
    }
    else{
      return Scaffold(
        body: CircularProgressIndicator()
      );
    }
  }
}

class CourseListBuilder extends StatelessWidget {
  const CourseListBuilder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var course = Provider.of<List<Course>>(context);
    if(course != null)
    {
    return new ListView.builder(
      itemCount: course.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
          leading: Icon(Icons.book, size: 30.0,),
          title: Text(course[index].courseName),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CoursePage(title: course[index].courseName),
              fullscreenDialog: true,
            ));
          },
        )
        );
      },
    );
    } else{
      return Scaffold(
        body: CircularProgressIndicator()
      );
    }
  }
}

class CoursePage extends StatefulWidget {
  final String title;
  CoursePage({this.title});
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('${widget.title}'),
      ),
    );
  }
}
