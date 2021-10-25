import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/Text_check.dart';
import 'package:softflow2/Interface/User_interface.dart';
import 'package:softflow2/Screens/AddShade.dart';
import 'package:softflow2/Screens/AddUser.dart';
import 'package:softflow2/Screens/ResetPassword.dart';
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
          isblock: isBlk,
        );

  static castAdmin(User u) {
    return Admin(
      id: u.id,
      pass: u.pass,
      usrname: u.usrname,
      isAdm: u.isadmin,
      isBlk: u.isblock,
    );
  }

  display(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                forUser: this,
              ),
            ),
          );
        },
        child: ListTile(
          tileColor:
              this.isblock == true ? Colors.redAccent : Colors.amber[100],
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
                label: "Admin",
                value: this.isadmin,
                cbkfun: this.ulterAdmin,
              ),
              TextCheck(
                label: "Blocked",
                value: this.isblock,
                cbkfun: this.ulterBlock,
              ),
            ],
          ),
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
      },
      {
        "name": "Reset Password",
        "value": ResetPasswordScreen(),
      }
    ];
    return list;
  }
}
