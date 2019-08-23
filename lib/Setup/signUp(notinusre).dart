import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                        ),
                      ),
                    )),
              ])
        ])
    );
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



  }

