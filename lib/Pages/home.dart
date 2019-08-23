import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:provider/provider.dart';
import 'package:uniapp/Pages/myaccount.dart';
import 'package:uniapp/Pages/timetable.dart';
import 'package:uniapp/Setup/signIn.dart';
import 'package:uniapp/Setup/db.dart';
import 'package:uniapp/Setup/models.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;
  const Home({Key key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    return //Scaffold(); 
    Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  "S",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              accountEmail: Text('${widget.user.email}'),
              accountName: Text('${widget.user.uid}'),
            ),
            ListTile(
              title: Text('View My Account'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountPage(user),
                        fullscreenDialog: true));
              },
            ),
            ListTile(
                title: Text('Class Schedules'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {}),
            ListTile(
              title: Text('Time Tables'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimeTable(),
                        fullscreenDialog: true));
              },
            ),
            new Divider(),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: Text('Welcome'),
      ),
    
      body: new Column(
        children: <Widget>[
          if (loggedIn) ...[
            Container(
              padding: const EdgeInsets.all(25.0),
              child: new Calendar(),
            ),
          
            StreamProvider<Student>.value(
              // All children will have access to SuperHero data
              value: db.streamStudent(user.uid),
              child: UserProfile(),
            ),
            StreamProvider<List<Course>>.value(
              // All children will have access to weapons data
              value: db.streamCourse(user),
              child: UserProfile(),
            ),
          ],
          if (!loggedIn) ...[
            //TODO: Redirect Back to Login if Not logged in.
          ]
        ],
      ),
    );
  }

  Future<LoginPage> _signOut() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true));
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var course = Provider.of<List<Course>>(context);
    var user = Provider.of<FirebaseUser>(context);
    print("test2");
    print(
        "Testing:  ${course[0].courseName + course[1].courseName + course[2].courseName}");
    return Text('');
     //Text("Hi ${user.email}, you have ${course[0].courseName}  course enrolled");
  }
}
