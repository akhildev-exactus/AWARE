import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './homepage.dart';
import 'helper/alert.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>(); // KEY
  final _userid = new TextEditingController();
  final _pass = new TextEditingController();

  String _message = '';

//-----------------------check login credencial------------------------------

  Future _loginCheck(String userid, String pass) async {
    var url = 'http://exactusnet.dyndns.org:4005/api/customer/$userid/$pass';
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      if (response.statusCode == 200) {
        return 1;
      } else {
        return;
      }
    } catch (e) {
      return 0;
    }
  }

  Widget _title() {
    return Container(
      child: Center(
        child: Container(
          width: 200,
          height: 175,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15.0, 50.0, 0.0, 10.0),
                child: Text(
                  'Aware',
                  style: TextStyle(
                      color: Colors.blue[700],
                      fontFamily: 'Montserrat',
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                  //           <Widget>[
                  //   Image.asset('assets/Apple-green-logo.png',
                  //       width: 200, height: 150),
                  // ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _useridField() {
    return TextFormField(
      style: TextStyle(
        fontFamily: 'Montserrat',
      ),
      decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Colors.lightBlue[50],
          filled: true),
      initialValue: null,
      validator: (String value) {
        if (value.isEmpty) {
          return '';
        }
        return null;
      },
      controller: _userid,
    );
  }

  Widget _passwordField() {
    return TextFormField(
      style: TextStyle(
        fontFamily: 'Montserrat',
      ),
      obscureText: true,
      initialValue: null,
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: Colors.lightBlue[50],
        filled: true,
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return '';
        }
        return null;
      },
      controller: _pass,
    );
  }

  Widget _useridPasswordWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "User Id",
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          _useridField(),
          SizedBox(
            height: 20,
          ),
          Text(
            "Password",
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          _passwordField(),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return ButtonTheme(
      minWidth: 125.0,
      height: 55.0,
      child: new RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23.0),
        ),
        child: Text(
          'Sign In',
          style: TextStyle(
              fontFamily: 'Montserrat', fontSize: 17, color: Colors.white),
        ),
        color: Colors.green,
        onPressed: () async {
          //-----------------------if value is NULL-------------------------
          if (!_formkey.currentState.validate()) {
            String _msg = "required";
            if (_userid.text.isEmpty && _pass.text.isEmpty) {
              return alert(context, "User id and password " + _msg, Colors.red);
            } else {
              if (_userid.text.isEmpty) {
                return alert(context, "User id " + _msg, Colors.red);
              } else if (_pass.text.isEmpty) {
                return alert(context, "Password " + _msg, Colors.red);
              }
            }
          } else {
            // ---------------------if value != null--------------------------
            setState(() {
              _message = 'Loading....';
            });
            var resp = await _loginCheck(
                _userid.text.toUpperCase(), _pass.text.toUpperCase());
            if (resp == 1) {
              setState(() {
                _message = "Login Success";
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Menu(_userid.text.toUpperCase());
              }));
            }
            // ------------------Server not running-------------------
            else if (resp == 0) {
              setState(() {
                _message = 'Server Not Responding Please try after sometimes';
              });

              alert(context, _message, Colors.green);
            }
            // ------------------Incorrect-------------------
            else {
              setState(() {
                _message = 'User id or Password Incorrect';
              });
              alert(context, _message, Colors.red);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // margin: EdgeInsets.all(5),
      // padding: EdgeInsets.only(bottom: 30, left: 10, right: 10, top: 20),
      padding: EdgeInsets.all(10.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
            child: SingleChildScrollView(
              child: Form(
                // --------------------Key----------------------
                key: _formkey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _title(),
                    SizedBox(height: 15),
                    _useridPasswordWidget(),
                    SizedBox(height: 30),
                    _submitButton(),
                    _bottom_data(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  _bottom_data() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: Center(
        child: Container(
          width: 200,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Text(
                  // year.month.ver.day
                  '\u00a9 2023 by EXACTUS SYSTEMS\nver 20.10.1.24',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
