import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
class User extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<User> {
  
  String _email;
  
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
        debugPrint('Exitingg signup page');
        Navigator.of(context).pop();
      }
    );
  }

  Widget _getBody() {
      return Form(
        
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                 
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      'user home page',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'TooneyNoodle',
                          color: Colors.pink),
                      textAlign: TextAlign.center,
                    ),
                  ),
                 
                  Container(
                      width: 200,
                      margin: EdgeInsets.only(top: 20, bottom: 0.0),
                      child: RaisedButton(
                        child: Text(
                          'notifications',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _notifications();
                        },
                        color: Colors.pink,
                      )),
                  
          ],
        ),
      ),],
      ),
      );
  }
  
  void _notifications() async {
    print('notifications');
    Map<String, String> queryParameters={'email':'oohas1234@gmail.com'};
    print('helloo');
    try{
       print("10.0.2.2");
       print('hiiiii');
      var url= '10.0.2.2:5000';
         print(url);
     
       var uri =Uri.http(url,'notifications', queryParameters);
        var resp = await http.get(uri);
     
   // http.Response resp = await http.get(url,queryParameters);  // 10.0.2.2 for emulator
    if (resp.statusCode == 200) {
      print("success");
      var jsonResponse = convert.jsonDecode(resp.body);
      print('notifications of user');
     print('$jsonResponse');
     // Navigator.of(context).pushNamed('/userpage');
    }
    else{
      print(resp.statusCode);
      print("fail");
     // Navigator.of(context).pushNamed('/loginpage');
    }
      } catch (error) {
        print('error: $error');
        _showAlertDialog('Error', error.toString());
        
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