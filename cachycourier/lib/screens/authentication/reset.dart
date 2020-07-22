import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email;

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text(
            'Cachycourier',
            
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        body: _getBody(),
      ),
      onWillPop: () {
        debugPrint('Exiting reset Pasword page');
        Navigator.of(context).pop();
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
                    margin: EdgeInsets.only(top: 50, bottom: 20),
                    child: Text(
                      'RESET PASSWORD',
                      style: TextStyle(
                          
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
                            borderSide: BorderSide(color: Colors.pink)),
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
                      width: 200,
                      margin: EdgeInsets.only(top: 20, bottom: 0.0),
                      child: RaisedButton(
                        child: Text(
                          'Reset Password',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _validateAndSubmit();
                        },
                        color: Colors.pink,
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
      return true;
    } else {
      return false;
    }
  }

  void _validateAndSubmit() async {
    if(_validateAndSave()) {
      debugPrint('Validated the form');
      
      try {
          print(_email);
        
        print(DotEnv().env['ipadress']);
         var url="http://10.0.2.2:5000/auth/forgot";
         print(url);
     
    http.Response resp = await http.post(url,body: {'email':_email,});  // 10.0.2.2 for emulator
    if (resp.statusCode == 200) {
      print("ghjkl");
      var jsonResponse = convert.jsonDecode(resp.body);
      print('$jsonResponse');
      print("success");
      Navigator.of(context).pushNamed('/resetpage');
    }
    
    else{
      print(resp.statusCode);
      print("fail");
      Navigator.of(context).pushNamed('/resetpage');
    }
        
        // Navigator.popUntil(context, ModalRoute.withName('/loginPage'));
        _showAlertDialog('Password Reset Mail Sent', 'Check your mail inbox to reset your password');
      } catch(error) {
        print('error: $error');
        _showAlertDialog('Error', error.toString());
       
      }
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/loginpage', (Route<dynamic> route) => false);
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alertDialog;
        });
  }
}