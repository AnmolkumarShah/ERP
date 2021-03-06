import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:softflow2/Helpers/FieldCover.dart';
import 'package:softflow2/Helpers/Snakebar.dart';
import 'package:softflow2/Interface/User_interface.dart';
import 'package:softflow2/Models/Admin.dart';
import 'package:softflow2/Models/NormalUser.dart';
import 'package:softflow2/Provider/MainProvider.dart';
import 'package:softflow2/Screens/Dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? usrname;
  String? pass;
  bool? loading = false;
  final _formKey = GlobalKey<FormState>();

  login() async {
    setState(() {
      this.loading = true;
    });
    _formKey.currentState!.save();
    User? _user;
    if (this.usrname == "" || this.pass == '') {
      showSnakeBar(context, "Enter All Fields");
      setState(() {
        this.loading = false;
      });
      return;
    }

    _user = User(pass: this.pass, usrname: this.usrname);
    Map<String, dynamic> result = await _user.login();
    print(result);
    if (result['msg'] == true) {
      _user.isadmin =
          result['data']['isadmin'] == null ? false : result['data']['isadmin'];
      _user.isblock =
          result['data']['isblock'] == null ? false : result['data']['isblock'];
      _user.id = result['data']['id'];
      if (_user.isadmin == true) {
        _user = Admin.castAdmin(_user);
      } else {
        _user = NormalUser.castNormal(_user);
      }
      Provider.of<MainProvider>(context, listen: false).setUser(_user);
      if (_user!.isblock == false) {
        Navigator.popAndPushNamed(context, Dashboard.routeName);
      } else if (_user.isblock == true) {
        showSnakeBar(context, "YOU ARE BLOCKED FROM USING APPLICATION");
        setState(() {
          this.loading = false;
        });
      } else {
        showSnakeBar(context, "Error Occured");
        setState(() {
          this.loading = false;
        });
      }
    } else if (result['msg'] == false) {
      showSnakeBar(context, "NO USER FOUND");
      setState(() {
        this.loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/back.jpg",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 60,
                          spreadRadius: 10,
                        )
                      ]),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          height: 70,
                          color: Colors.black,
                        ),
                        Fieldcover(
                          child: TextFormField(
                            onSaved: (val) {
                              setState(() {
                                this.usrname = val;
                              });
                            },
                            keyboardType: TextInputType.name,
                            validator: RequiredValidator(
                              errorText: "This is required field!",
                            ),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                              hintText: "Username",
                            ),
                          ),
                        ),
                        Fieldcover(
                          child: TextFormField(
                            onSaved: (val) {
                              setState(() {
                                this.pass = val;
                              });
                            },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: RequiredValidator(
                                errorText: "This is required field!"),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                            ),
                          ),
                        ),
                        this.loading == true
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : TextButton(
                                onPressed: login,
                                child: Text(
                                  "GO!",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
