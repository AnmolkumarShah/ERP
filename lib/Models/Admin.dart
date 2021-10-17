import 'package:softflow2/Interface/User_interface.dart';
import 'package:softflow2/Screens/AddShade.dart';
import 'package:softflow2/Screens/StockStatementScreen.dart';
import 'package:softflow2/Screens/TransactionScreen.dart';

class Admin implements User {
  String? usrname;
  String? pass;
  Admin({this.pass, this.usrname});
  @override
  login() {
    const String USERNAME = "admin";
    const String PASSWORD = "12345678";
    if (this.pass == PASSWORD && this.usrname == USERNAME) {
      return true;
    }
    return false;
  }

  @override
  List<Map<String, dynamic>> available_option() {
    List<Map<String, dynamic>> list = [
      {
        "name": "Transactions",
        "value": TransactionScreen(),
      },
      {
        "name": "Stock Screen",
        "value": StockStatement(),
      },
      {
        "name": "Add Shade",
        "value": AddShade(),
      }
    ];
    return list;
  }
}
