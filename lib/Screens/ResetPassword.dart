import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softflow2/Helpers/FieldCover.dart';
import 'package:softflow2/Helpers/Snakebar.dart';
import 'package:softflow2/Interface/User_interface.dart';
import 'package:softflow2/Models/NormalUser.dart';
import 'package:softflow2/Provider/MainProvider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool? loading;
  TextEditingController? _usrname = TextEditingController(text: "");
  TextEditingController? _oldpass = TextEditingController(text: "");
  TextEditingController? _newpass = TextEditingController(text: "");

  resetPass() async {
    if (_usrname!.value.text == '' ||
        _oldpass!.value.text == '' ||
        _newpass!.value.text == '') {
      showSnakeBar(context, "Enter All Fields First");
      return;
    }
    setState(() {
      loading = true;
    });

    NormalUser? nu = NormalUser(
      usrname: _usrname!.value.text.trim(),
      newP: _newpass!.value.text.trim(),
      pass: _oldpass!.value.text.trim(),
    );

    var result = await nu.resetPassword();

    if (result == true) {
      showSnakeBar(context, "Password Changed Successfully");
    } else {
      showSnakeBar(context, "Error In Password Changing");
    }

    setState(() {
      loading = false;
      _usrname = TextEditingController(text: "");
      _oldpass = TextEditingController(text: "");
      _newpass = TextEditingController(text: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser =
        Provider.of<MainProvider>(context, listen: false).getUser();
    if (currentUser != null) {
      _usrname = TextEditingController(text: currentUser.getName());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Fieldcover(
            child: TextFormField(
              controller: _usrname,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "User Name",
              ),
            ),
          ),
          Fieldcover(
            child: TextFormField(
              controller: _oldpass,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Old Password",
              ),
            ),
          ),
          Fieldcover(
            child: TextFormField(
              controller: _newpass,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "New Password",
              ),
            ),
          ),
          loading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: resetPass,
                  child: Text("Reset Password"),
                )
        ],
      ),
    );
  }
}
