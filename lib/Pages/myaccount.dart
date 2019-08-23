import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  // final FirebaseUser user;
  // AccountPage(this.user);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext contexts) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;
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
                          left: 0.0, top: 20.0, right: 0.0, bottom: 0.0),
                    ),
                    CircleAvatar(
                      minRadius: 100.0,
                      child: Text(
                        'S',
                        style: new TextStyle(fontSize: 95.0),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      child: Card(
                        color: Colors.white70,
                        child: ListTile(
                          leading: Icon(Icons.email),
                          title: Text(
                            '',
                            style: new TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Card(
                        color: Colors.white70,
                        child: ListTile(
                          leading: Icon(Icons.alternate_email),
                          title: Text(
                            '',
                            style: new TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Card(
                        color: Colors.white70,
                        child: ListTile(
                          leading: Icon(Icons.account_box),
                          title: Text(
                            '',
                            style: new TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    //                     Container(
                    //   child: new RaisedButton(
                    //       onPressed: () {
                    //         Navigator.push(context, MaterialPageRoute(
                    //           builder: (context) => new Edit();
                    //         )
                    //         );},
                    //       child: new Text('Edit Account'),
                    //     ) 
                    // ),
                  ],
                )
                )
          ],
        ],
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
