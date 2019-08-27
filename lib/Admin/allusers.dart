import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniapp/Pages/home.dart';
import 'package:uniapp/Setup/db.dart';

class GetAllUsers extends StatefulWidget {
  @override
  _GetAllUsersState createState() => _GetAllUsersState();
}

class _GetAllUsersState extends State<GetAllUsers> {
  final Firestore _db = Firestore.instance;

  //Getting All User Data
  Future streamRegUsers() async {
    QuerySnapshot result = await _db.collection('users').getDocuments();
    await Future.delayed(Duration(seconds: 1));
    return result.documents;
  }

  @override
  Widget build(BuildContext context) {
    var user1 = Provider.of<FirebaseUser>(context);

    return new Scaffold(
        appBar: new AppBar(
          title: Text('Registered Accounts'),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            )
          ],
        ),
        body: new Container(
            child: FutureBuilder(
                future: this.streamRegUsers(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        var user = snapshot.data[index].data;
                        var id = snapshot.data[index].documentID;
                        return new Card(
                          child: ListTile(
                            trailing: new IconButton(
                              icon: new Icon(Icons.more_vert),
                              onPressed: () {
                                buildActions(context, user, id);
                              },
                            ),
                            leading: Icon(
                              Icons.verified_user,
                              color: Colors.green,
                            ),
                            title: Text(
                                '${user['first_name']} ${user['last_name']}'),
                            subtitle: Text('${user['email']}'),
                            onLongPress: () {
                              PopupMenuButton(
                                child: FlutterLogo(),
                                itemBuilder: (context) {
                                  return <PopupMenuItem>[
                                    new PopupMenuItem(
                                      child: Text('Delete'),
                                    )
                                  ];
                                },
                              );
                            },
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UsersList(
                                  title: snapshot.data[index].data['email'],
                                ),
                              ));
                            },
                          ),
                        );
                      },
                    );
                  }
                })));
  }

  Future buildActions(BuildContext context, user, id) {
    return showDialog(
                                  context: context,
                                  builder: (BuildContext contexts) =>
                                      AlertDialog(
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text('Cancel',
                                                style: new TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                        title: Text('Actions'),
                                        content: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            buildDelete(context, user, id),
                                            buildAssign(id),
                                            buildViewUser(id),
                                          ],
                                        ),
                                      ));
  }

  Container buildViewUser(id) {
    return Container(
      child: Card(
        child: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: () {
            print('View User - $id');
          },
        ),
      ),
    );
  }

  Container buildAssign(id) {
    return Container(
      child: Card(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            print('Assigning Course Collection - $id');
            _db
                .collection('users')
                .document(id)
                .collection('courses')
                .document()
                .setData({
              'courseName': 'Java Programming',
            });
            print('Courses Added..');
          },
        ),
      ),
    );
  }

  Container buildDelete(BuildContext context, user, id) {
    return Container(
      child: Card(
        child: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext contexts) => AlertDialog(
                title: Text('Are you sure you want delete?'),
                content: Text('${user['email']}'),
                actions: <Widget>[
                  new FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _db.collection('users').document(id).delete();

                      showDialog(
                          context: context,
                          builder: (BuildContext contexts) => AlertDialog(
                                title: Text('User Deleted Successfully..'),
                                content: Text('Press OK.. to Continue.'),
                                actions: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Okay.'),
                                  )
                                ],
                              ));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class UsersList extends StatefulWidget {
  final String title;
  UsersList({this.title});
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text('Actions'),
        icon: Icon(Icons.add),
      ),
      appBar: new AppBar(
        title: Text('${widget.title}'),
      ),
    );
  }
}

class AdminUsers extends StatefulWidget {
  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  final Firestore _db = Firestore.instance;
  Future streamAdminUsers() async {
    QuerySnapshot result = await _db.collection('users').getDocuments();
    await Future.delayed(Duration(seconds: 1));
    return result.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Admin Users'),
        ),
        body: new Container(
          child: FutureBuilder(
              future: this.streamAdminUsers(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        var user = snapshot.data[index].data;
                        var id = snapshot.data[index].documentID;
                        return Card();
                      });
                }
              }),
        ));
  }
}
