import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/Text_check.dart';
import 'package:softflow2/Interface/User_interface.dart';
import 'package:softflow2/Screens/AddShade.dart';
import 'package:softflow2/Screens/AddUser.dart';
import 'package:softflow2/Screens/StockINOUT/StockInStockOutScreen.dart';
import 'package:softflow2/Screens/StockSTATEMENT/StockStatementScreen.dart';

import 'package:softflow2/Screens/TransactionScreen.dart';

class Admin extends User {
  Admin({String? usrname, String? pass, int? id, bool? isAdm, bool? isBlk})
      : super(
            usrname: usrname,
            pass: pass,
            id: id,
            isadmin: isAdm,
            isblock: isBlk);
  @override
  login() async {
    const String USERNAME = "admin";
    const String PASSWORD = "12345678";
    if (this.pass == PASSWORD && this.usrname == USERNAME) {
      return true;
    }
    return false;
  }

  static castAdmin(User u) {
    return Admin(
      id: u.id,
      pass: u.pass,
      usrname: u.usrname,
      isAdm: u.isadmin,
      isBlk: u.isblock,
    );
  }

  display() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        tileColor: this.isblock == true ? Colors.redAccent : Colors.amber[100],
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  List<Map<String, dynamic>> available_option() {
    List<Map<String, dynamic>> list = [
      {
        "name": "Transactions",
        "value": TransactionScreen(),
      },
      {
        "name": "Stock Statement",
        "value": StockStatement(),
      },
      {
        "name": "Add Shade",
        "value": AddShade(),
      },
      {
        "name": "Stock In Out Report",
        "value": StockInOutScreen(),
      },
      {
        "name": "Add User",
        "value": AddUser(),
      }
    ];
    return list;
  }
}
