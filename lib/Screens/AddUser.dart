import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/FieldCover.dart';
import 'package:softflow2/Helpers/Snakebar.dart';
import 'package:softflow2/Models/NormalUser.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController? _usrname = TextEditingController(text: "");
  TextEditingController? _pwd = TextEditingController(text: "");
  bool loading = false;
  Future save() async {
    if (_usrname!.value.text == '' || _pwd!.value.text == "") {
      showSnakeBar(context, "Enter Name And Password");
      return;
    }
    setState(() {
      this.loading = true;
    });

    NormalUser? nu = NormalUser(
      usrname: _usrname!.value.text.trim(),
      pass: _pwd!.value.text.trim(),
    );

    bool? check = await nu.login();
    if (check == true) {
      showSnakeBar(context, "Already A User With This UserName & Password");
    } else {
      var result = await nu.addUser();
      if (result['status'] == 'success') {
        showSnakeBar(context, "New User Addeed Successfully");
      }
    }

    setState(() {
      this.loading = false;
      _usrname = TextEditingController(text: "");
      _pwd = TextEditingController(text: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Fieldcover(
                    child: TextFormField(
                      controller: _usrname,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "User Name",
                      ),
                    ),
                  ),
                  Fieldcover(
                    child: TextFormField(
                      controller: _pwd,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                      ),
                    ),
                  ),
                  this.loading == false
                      ? TextButton(
                          onPressed: this.save,
                          child: Text("Add User"),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
