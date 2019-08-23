import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniapp/Pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  FormType _formType = FormType.login;
  final databaseReference = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //bool _isObscured = true;
  //Color _eyeButtonColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.greenAccent,
        body: new Stack(fit: StackFit.expand, children: <Widget>[
          buildBackgroundImage(),
          new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlutterLogo(
                  size: 100.00,
                ),
                new Form(
                    key: _formKey,
                    child: new Theme(
                      data: new ThemeData(
                        brightness: Brightness.dark,
                        primarySwatch: Colors.teal,
                        inputDecorationTheme: new InputDecorationTheme(
                            labelStyle: new TextStyle(
                                color: Colors.white, fontSize: 20.0)),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(50.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: buildInputs() + buildSubmitBtns(),
                        ),
                      ),
                    )),
              ])
        ]));
  }

//Background Image
  Image buildBackgroundImage() {
    return new Image(
      image: new AssetImage("assets/background.jpg"),
      fit: BoxFit.cover,
      color: Colors.black87,
      colorBlendMode: BlendMode.softLight,
    );
  }

  //Text Fields
  List<Widget> buildInputs() {
    return [
      new TextFormField(
        validator: (input) =>
            input.isEmpty ? 'Email ID cannot be empty.' : null,
        onSaved: (input) => _email = input,
        decoration: new InputDecoration(
            labelText: 'Enter Email Address',
            suffixIcon: IconButton(
              onPressed: null,
              icon: Icon(Icons.mail),
            )),
        keyboardType: TextInputType.text,
      ),
      new TextFormField(
        onSaved: (input) => _password = input,
        validator: (input) =>
            input.isEmpty ? 'Password cannot be left blank.' : null,
        decoration: new InputDecoration(
            labelText: 'Enter Password',
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.remove_red_eye),
            )),
        keyboardType: TextInputType.text,
        obscureText: true,
      ),
    ];
  }

  List<Widget> buildSubmitBtns() {
    if (_formType == FormType.login) {
      return [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                  onPressed: moveToRegister,
                  child: Text(
                    "Dont have an account?",
                    style: TextStyle(color: Colors.green),
                  )),
            ),
          ),
        ),
        Align(
          child: SizedBox(
            height: 40.0,
            width: 250.0,
            child: FlatButton(
              onPressed: signInAndRegister,
              splashColor: Colors.green[500],
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Text('Login',
                  style: Theme.of(context).primaryTextTheme.button),
            ),
          ),
        )
      ];
    } else {
      return [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                  onPressed: moveToLogin,
                  child: Text(
                    "Back to Login...",
                    style: TextStyle(color: Colors.green),
                  )),
            ),
          ),
        ),
        Align(
          child: SizedBox(
            height: 40.0,
            width: 250.0,
            child: FlatButton(
              onPressed: signInAndRegister,
              splashColor: Colors.green[500],
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Text('Register',
                  style: Theme.of(context).primaryTextTheme.button),
            ),
          ),
        )
      ];
    }
  }

  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  Future<void> signInAndRegister() async {
    if (_formType == FormType.login) {
      final formState = _formKey.currentState;
      if (formState.validate()) {
        formState.save();
        try {
          AuthResult result = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          print(result.user);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(user: result.user),
                  fullscreenDialog: true));
        } catch (e) {
          print(e.message);
        }
      }
    } else {
      final formState = _formKey.currentState;
      if (formState.validate()) {
        formState.save();
        try {
          AuthResult result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password);
          databaseReference
              .collection("users")
              .document("${result.user.uid}")
              .setData({
            'first_name': null,
            'last_name': null,
            'role': null,
            'address': null,
            'Contact_no': null,
            'Photourl': null,
            'date_of_birth': null
          });
          //result.user.sendEmailVerification();
          print('Email Verification Sent ${result.user.email}');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(user: result.user),
                  fullscreenDialog: true));
        } catch (e) {
          print(e.message);
        }
      }
    }
  }

// Class Ending Bracket

}
