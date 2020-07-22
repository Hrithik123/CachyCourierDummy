import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
//import 'package:cachycourier/screens/User.dart';
class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(
            'Cachycourrier',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Velhos Tempos',
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.pink
        ),
        body: _getBody(),
      ),
      onWillPop: () {
        AlertDialog alertDialog = AlertDialog(
          title: Center(
            child: Text('Are you sure'),
          ),
          content: Text('  want to close the app?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Not Yet'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                // return exit(0);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
        showDialog(
            context: context,
            builder: (_) {
              return alertDialog;
            });
      },
    );
  }

  Widget _getBody() {
      return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                 
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      'LOG IN',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'TooneyNoodle',
                          color: Colors.pink),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: 350,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.justify,
                      cursorRadius: Radius.circular(5),
                      cursorColor: Colors.grey,
                      autocorrect: true,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        labelText: 'Email',
                        hintText: 'example@example.com',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email can\'t be empty';
                        }
                        if (!value.contains('@')) {
                          return 'Please provide correct emailid';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value;
                      },
                    ),
                  ),
                  Container(
                    width: 350,
                    height: 50,
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      textAlign: TextAlign.justify,
                      cursorRadius: Radius.circular(5),
                      cursorColor: Colors.grey,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        labelText: 'Password',
                        hintText: '*************',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password can\'t be emply';
                        }
                        if (value.length < 6) {
                          return 'Password must be atleast 6 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                    ),
                  ),
                  Container(
                      width: 200,
                      margin: EdgeInsets.only(top: 20, bottom: 0.0),
                      child: RaisedButton(
                        child: Text(
                          'LOG IN',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _validateAndSubmit();
                        },
                        color: Colors.pink,
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        Text('Forgot Password?'),
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          child: FlatButton(
                            child: Text(
                              'Reset Password',
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                               Navigator.of(context).pushNamed('/resetpage');
                            },
                            textColor: Colors.pink,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: 150,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: 25.0,
                        child: Text('OR'),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: 150,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: Column(
                      children: <Widget>[
                      Text(
                        'Not yet registered? tap the register button',
                      ),
                      Container(
                        width: 120,
                        child: FlatButton(
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/signuppage');
                          },
                          textColor: Colors.pink,
                        ),
                      )
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      );   
  }
  bool _validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      // print('firstname: $_firstName, lastname: $_lastName, gender: $_gender, email: $_email,dob: $_dob,password: $_password');
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      debugPrint('Validated the form');
      
      try {
        print(_email);
        print(_password);
        print(DotEnv().env['ipadress']);
         var url="http://10.0.2.2:5000/auth/login";
         print(url);
     
    http.Response resp = await http.post(url,body: {'email':_email,'password':_password});  // 10.0.2.2 for emulator
    if (resp.statusCode == 200) {
      print("ghjkl");
      var jsonResponse = convert.jsonDecode(resp.body);
      print('$jsonResponse');
      print("success");
      Navigator.of(context).pushNamed('/userpage');
    }
    else{
      print(resp.statusCode);
      print("fail");
      Navigator.of(context).pushNamed('/loginpage');
    }
      } catch (error) {
        print('error: $error');
        _showAlertDialog('Error', error.toString());
        
      }
    }
  }


  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) {
          return alertDialog;
        });
  }
}