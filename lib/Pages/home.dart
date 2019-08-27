import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:provider/provider.dart';
import 'package:uniapp/Admin/allusers.dart';
import 'package:uniapp/Pages/myUnits.dart';
import 'package:uniapp/Pages/myaccount.dart';
import 'package:uniapp/Pages/timetable.dart';
import 'package:uniapp/Setup/signIn.dart';
import 'package:uniapp/Setup/db.dart';
import 'package:uniapp/Setup/models.dart';

class Home extends StatefulWidget {
  final FirebaseUser currentUser;
  const Home({Key key, this.currentUser}) : super(key: key);
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
    return Container(
      child: StreamBuilder<Student>(
          // All children will have access to User data
          stream: db.streamStudent(widget.currentUser.uid),
          builder: (context, snapshot) {
            var user = snapshot.data;
            //print('User is: ${user.address}');
            if (user != null) {
              if (loggedIn) {
                return Scaffold(
                  appBar: new AppBar(
                    title: Text('Hi ${user.fname}'),
                  ),
                  drawer: Drawer(
                    child: ListView(
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                          ),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.grey,
                            //child: Text('${widget.user.email.toUpperCase().substring(0,1)}', style: TextStyle(fontSize: 30.0),),
                            backgroundImage: NetworkImage("${user.photoUrl}"),
                          ),
                          accountName: Text("${user.fname} ${user.lname}"),
                          accountEmail: Text("${widget.currentUser.email}"),
                        ),
                        if (user.role == 'Admin' || user.role == 'admin') ...{
                          buildViewMyAccount(context),
                          viewAllUsers(context),
                          buildManageAdmins(),
                          new Divider(),
                          ListTile(
                            title: Text('Grade A Unit'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {},
                          ),
                          new Divider(),
                          buildLogoutTile(),
                        } else ...{
                          ListTile(
                            title: Text('View My Account'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountPage(
                                            currentUser: widget.currentUser,
                                          ),
                                      fullscreenDialog: true));
                            },
                          ),
                          ListTile(
                              title: Text('View Units'),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyUnits(),
                                      fullscreenDialog: true));
                            },),
                          ListTile(
                            title: Text('Time Tables'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
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
                        }
                      ],
                    ),
                  ),
                  body: Container(
                    child: Column(
                      children: <Widget>[
                        if (loggedIn) ...[
                          Container(
                            padding: const EdgeInsets.all(25.0),
                            child: new Calendar(),
                          ),
                          StreamProvider<List<Course>>.value(
                              // All children will have access to Course data
                              value: db.streamCourse(widget.currentUser),
                              child: StudentData()),
                          Tiles('Assignments Due:'),
                          Tiles('Grades:')
                        ],
                      ],
                    ),
                  ),
                );
              }
              //Redirect The User If User is not logged in with Popup Message Please login again session expire.
              if (!loggedIn) {
                //Functionality goes here.
              }
            }
            return new Container();
          }),
    );
  }

  ListTile buildLogoutTile() {
    return ListTile(
                          title: Text('Logout'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: _signOut,
                        );
  }

  ListTile buildManageAdmins() {
    return ListTile(
                          title: Text('Manage Admins'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AdminUsers(),
                                    fullscreenDialog: true));
                          },
                        );
  }

  ListTile viewAllUsers(BuildContext context) {
    return ListTile(
                            title: Text('View All Users'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => GetAllUsers(),
                                    fullscreenDialog: true));
                          }
                          );
  }

  ListTile buildViewMyAccount(BuildContext context) {
    return ListTile(
                          title: Text('View My Account'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountPage(
                                          currentUser: widget.currentUser,
                                        ),
                                    fullscreenDialog: true));
                          },
                        );
  }

  // Signout Function
  Future<LoginPage> _signOut() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true));
  }
}

class Tiles extends StatefulWidget {
  final String s;
  const Tiles(this.s);

  @override
  _TilesState createState() => _TilesState();
}

class _TilesState extends State<Tiles> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          new Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
            child: new Container(
              height: 100.0,
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                  color: Colors.blueGrey),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                  ),
                  new Icon(Icons.book, color: Colors.white, size: 35.0),
                  Row(
                    children: <Widget>[
                      new Text("${widget.s}",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                          textAlign: TextAlign.end)
                    ],
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class StudentData extends StatefulWidget {
  @override
  _StudentDataState createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData> {
  @override
  Widget build(BuildContext context) {
    var course = Provider.of<List<Course>>(context);
    if (course.length == null) {
      course.length = 0;
    }
    return Container(
      child: Column(
        children: <Widget>[
          Tiles('Enrolled Units: ${course.length}'),
        ],
      ),
    );
  }
}
