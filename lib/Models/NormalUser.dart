import 'package:softflow2/Interface/User_interface.dart';
import 'package:softflow2/Screens/StockStatementScreen.dart';

class NormalUser implements User {
  String? usrname;
  String? pass;
  NormalUser({this.pass, this.usrname});
  @override
  login() {
    const String USERNAME = "user";
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
        "name": "Stock Screen",
        "value": StockStatement(),
      }
    ];
    return list;
  }
}
