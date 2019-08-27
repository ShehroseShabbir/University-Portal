import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:uniapp/Setup/db.dart';
import 'package:uniapp/Setup/models.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:uniapp/Setup/signIn.dart';

class AccountPage extends StatefulWidget {
  final FirebaseUser currentUser;
  const AccountPage({Key key, this.currentUser}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final auth = FirebaseAuth.instance;
  final db = DatabaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext contexts) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return StreamBuilder<Student>(
        stream: db.streamStudent(user.uid),
        builder: (context, snapshot) {
          var user = snapshot.data;
          if (user != null) {
            return Scaffold(
              appBar: new AppBar(title: Text('View My Account')),
              body: new Column(
                children: <Widget>[
                  if (loggedIn) ...[

                    new Container(
                        padding: const EdgeInsets.all(30.0),
                        child: new Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 0.0,
                                  top: 20.0,
                                  right: 0.0,
                                  bottom: 0.0),
                            ),
                            CircleAvatar(
                              radius: 100.0,
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage('${user.photoUrl}'),
                                radius: 100.0,
                              ),
                            ),
                            SizedBox(
                                height: 80.0,
                                child: Padding(
                                  child: Column(
                                    children: <Widget>[
                                      if (widget
                                          .currentUser.isEmailVerified) ...[
                                        ListTile(
                                          onTap: () {
                                            widget.currentUser
                                                .sendEmailVerification();
                                          },
                                          title: Text('Verified Account',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.green)),
                                          leading: Icon(
                                            Icons.verified_user,
                                            size: 35.0,
                                            color: Colors.green,
                                          ),
                                        )
                                      ] else ...[
                                        ListTile(
                                          onTap: () {
                                            widget.currentUser
                                                .sendEmailVerification();
                                          },
                                          title: Text(
                                            'Verify Now',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.red),
                                            textAlign: TextAlign.start,
                                            
                                          ),
                                          leading: Icon(
                                            Icons.thumb_down,
                                            color: Colors.red,
                                            size: 35.0,
                                          ),
                                        )
                                      ]
                                    ],
                                  ),
                                  padding: const EdgeInsets.only(top: 20.0),
                                )),
                            Container(
                              child: Card(
                                color: Colors.white70,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.supervised_user_circle,
                                    size: 35.0,
                                  ),
                                  title: Text(
                                    '${user.fname} ${user.lname}',
                                    style: new TextStyle(
                                        color: Colors.black,),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Card(
                                color: Colors.white70,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.alternate_email,
                                    size: 35.0,
                                  ),
                                  title: Text(
                                    '${user.email}',
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Card(
                                color: Colors.white70,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.home,
                                    size: 35.0,
                                  ),
                                  title: Text(
                                    '${user.address}',
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                child: new RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext contexts) =>
                                        _buildAboutDialog(context));
                              },
                              child: new Text('Edit Account'),
                            )),
                          ],
                        ))
                  ],
                ],
              ),
            );
          }
          return LoginPage();
        });
  }

  Widget _buildAboutDialog(BuildContext context) {
    final format = DateFormat("dd-MMM-yyyy");
    var user = Provider.of<FirebaseUser>(context);
    String _fname, _lname, _address;
    DateTime _dob;
    String _contact;
    return StreamBuilder<Student>(
        stream: db.streamStudent(user.uid),
        builder: (context, snapshot) {
          var user = snapshot.data;
          if (user != null) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(30.0),
              backgroundColor: Theme.of(context).primaryColorDark,
              title: const Text('Update Details'),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancel',
                      style:
                          new TextStyle(color: Colors.white, fontSize: 15.0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('Update',
                      style:
                          new TextStyle(color: Colors.white, fontSize: 15.0)),
                  onPressed: () {
                    final formState = _formKey.currentState;
                    if (formState.validate()) {
                      formState.save();
                      // Updating User Details
                      db.updateUser(widget.currentUser.uid, _fname, _lname,
                          _address, _contact, _dob, widget.currentUser.email);
                      Navigator.pop(context);
                    }
                  },
                )
              ],
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Form(
                    key: _formKey,
                    child: new Container(
                      child: new Column(
                        children: <Widget>[
                          SizedBox(
                            height: 40.0,
                            child: Text('Please fill in your data to update.'),
                          ),
                          TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _fname = input,
                            initialValue: '${widget.currentUser.email}',
                            decoration: new InputDecoration(
                              labelText: "Current Email",
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _fname = input,
                            initialValue: '${user.fname}',
                            decoration: new InputDecoration(
                              labelText: "Enter Your First Name",
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _lname = input,
                            initialValue: '${user.lname}',
                            decoration: new InputDecoration(
                              labelText: "Enter Your Last Name",
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _address = input,
                            initialValue: '${user.address}',
                            decoration: new InputDecoration(
                              labelText: "Enter Your Address",
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _contact = input,
                            initialValue: '${user.contactno}',
                            decoration: new InputDecoration(
                              labelText: "Enter Your Contact",
                            ),
                          ),
                          DateTimeField(
                            initialValue: DateTime.now(),
                            onSaved: (input) => _dob = input,
                            format: format,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return Scaffold(
              appBar: new AppBar(
                title: Text('Something is Loading..'),
              ),
              body: CircularProgressIndicator());
        });
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
