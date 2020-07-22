import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Signup extends StatefulWidget{
  @override
  State<StatefulWidget>createState(){

    return Signupstate();
  }
}
class Signupstate extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
 
  String _email;
  String _password;
  String _type;
 

  TextEditingController passWordController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title:Text(
            'Cachycourrier',
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        body: _getbody(),
      ),
      onWillPop: (){

        debugPrint('Exitingg signup page');
        Navigator.of(context).pop();
      },
    );
  }
  Widget _getbody(){
    
      return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          //fontSize: 40,
                          //fontFamily: 'TooneyNoodle',
                          color: Colors.pink),
                      textAlign: TextAlign.center,
                    ),
                  ),

                 
                  // Email Id...
                  Container(
                    width: 350,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
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
                        if (!(value.contains('@'))) {
                          return 'Email is invalid';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value;
                      },
                    ),
                  ),

                 

                  // Password...
                  Container(
                    width: 350,
                    height: 50,
                    margin: EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: passWordController,
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
                          return 'Password can\'t be null';
                        }
                        if (value.length <= 6) {
                          return 'Password must be atleast 7 letter';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                    ),
                  ),

                  // ReEnter password
                  Container(
                    width: 350,
                    height: 50,
                    margin: EdgeInsets.only(top: 30),
                    child: TextFormField(
                      textAlign: TextAlign.justify,
                      cursorRadius: Radius.circular(5),
                      cursorColor: Colors.grey,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple)),
                        labelText: 'Confirm Password',
                        hintText: '*************',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != passWordController.text) {
                          return 'Password didn\'t match';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                    ),
                  ),

                  //type
                  //  Container(
                  //     width: 350,
                  //     height: 50,
                  //     child: Row(
                  //       children: <Widget>[
                  //         // Gender Selection...
                         
                  //            Container(
                  //             height: 100,
                  //             margin: EdgeInsets.only(top: 35),
                  //             child: DropdownButton<String>(
                  //               value: _type,
                  //               onChanged: (String newValue) {
                  //                 setState(() {
                  //                   _type = newValue;
                  //                 });
                  //               },
                  //               items: <String>[
                  //                 'Customer',
                  //                 'Delivery guy'
                  //               ].map<DropdownMenuItem<String>>((String value) {
                  //                 return DropdownMenuItem<String>(
                  //                   value: value,
                  //                   child: Text(value),
                  //                 );
                  //               }).toList(),
                  //               isDense: true,
                  //             ),
                  //           ),
                          

                      //   ],
                      // )),
                  // Register Button...
                  Container(
                      width: 350,
                      margin: EdgeInsets.only(top: 30, bottom: 40),
                      child: RaisedButton(
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          debugPrint('pressed Register button!');
                          _validateAndSubmit();
                        },
                        color: Colors.pink,
                      )),

                  Container(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'Already Registered? tap the LogIn button',
                      ),
                      FlatButton(
                        child: Text(
                          'LOG IN',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.pink,
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
         var url="http://10.0.2.2:5000/auth/signup";
         print(url);
     
    http.Response resp = await http.post(url,body: {'email':_email,'password':_password});  // 10.0.2.2 for emulator
    if (resp.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(resp.body);
      print('$jsonResponse');
      //  Navigator.of(context).pushNamed('/signup');
    }
    else{
      print("fail");
      // Navigator.of(context).pushNamed('/main');
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