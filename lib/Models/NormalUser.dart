import 'package:softflow2/Helpers/FetchFormatter.dart';
import 'package:softflow2/Interface/User_interface.dart';
import 'package:softflow2/Screens/ResetPassword.dart';
import 'package:softflow2/Screens/StockSTATEMENT/StockStatementScreen.dart';

class NormalUser implements User {
  String? usrname;
  String? pass;
  String? newP;
  NormalUser({this.pass, this.usrname, this.newP = ""});
  @override
  login() async {
    print(this.usrname);
    print(this.pass);
    var result = await fetchQuery(
        query:
            "select * from usr_mast where usr_nm = '${this.usrname}' and pwd = '${this.pass}' ");
    if ((result as List<dynamic>).length >= 1) {
      return true;
    }
    return false;
  }

  resetPassword() async {
    var check = await this.login();
    if (check == true) {
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

  @override
  addUser() async {
    var result = await fetchQuery(
      p1: '1',
      query: '''

        insert into usr_mast(usr_nm,pwd)
        values('${this.usrname}', '${this.pass}')

      ''',
    );
    return result;
  }

  @override
  getName() {
    return this.usrname;
  }
}
