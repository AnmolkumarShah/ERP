import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/FetchFormatter.dart';
import 'package:softflow2/Helpers/Text_check.dart';
import 'package:softflow2/Interface/User_interface.dart';
import 'package:softflow2/Screens/ResetPassword.dart';
import 'package:softflow2/Screens/StockSTATEMENT/StockStatementScreen.dart';

class NormalUser extends User {
  String? newP;
  NormalUser(
      {String? usrname,
      String? pass,
      bool? isAdm,
      bool? isblk,
      int? id,
      this.newP})
      : super(
            usrname: usrname,
            pass: pass,
            id: id,
            isadmin: isAdm,
            isblock: isblk);

  resetPassword() async {
    var check = await this.login();
    if (check['msg'] == true) {
      var result = await fetchQuery(
        p1: '1',
        query: '''
          update usr_mast
          set pwd = '${this.newP}'
          where usr_nm = '${this.usrname}' and pwd = '${this.pass}'
        ''',
      );

      if (result['status'] == 'success') {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  List<Map<String, dynamic>> available_option() {
    List<Map<String, dynamic>> list = [
      {
        "name": "Stock Screen",
        "value": StockStatement(),
      },
      {
        "name": "Reset Password",
        "value": ResetPasswordScreen(),
      }
    ];
    return list;
  }

  static castNormal(User u) {
    return NormalUser(
      id: u.id,
      newP: u.pass,
      pass: u.pass,
      usrname: u.usrname,
      isAdm: u.isadmin,
      isblk: u.isblock,
    );
  }

  addUser() async {
    var result = await fetchQuery(
      p1: '1',
      query: '''

        insert into usr_mast(usr_nm,pwd,isadmin,isblock)
        values('${this.usrname}', '${this.pass}',0,0)

      ''',
    );
    return result;
  }

  @override
  display() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        tileColor:
            this.isblock == true ? Colors.redAccent : Colors.lightBlue[100],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Name : " + this.usrname!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Id  : " + this.id.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextCheck(
              label: "isAdmin",
              value: this.isadmin,
              cbkfun: this.ulterAdmin,
            ),
            TextCheck(
              label: "isBlocked",
              value: this.isblock,
              cbkfun: this.ulterBlock,
            ),
          ],
        ),
      ),
    );
  }
}
