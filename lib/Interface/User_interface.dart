import 'package:softflow2/Helpers/FetchFormatter.dart';

class User {
  static String? query = "select * from usr_mast order by isadmin desc,id asc";

  String? usrname;
  String? pass;
  int? id;
  bool? isadmin;
  bool? isblock;

  User({
    this.id,
    this.pass,
    this.isadmin,
    this.isblock,
    this.usrname,
  });

  static format(List<dynamic> li) {
    List<User> userList = li
        .map((e) => User(
              id: e['id'],
              isadmin: e['isadmin'] == null ? false : e['isadmin'],
              isblock: e['isblock'] == null ? false : e['isblock'],
              pass: e['pwd'],
              usrname: e['usr_nm'],
            ))
        .toList();
    return userList;
  }

  ulterAdmin(bool? value) async {
    var result = await fetchQuery(
      query: """
        update usr_mast
        set isadmin = ${value == true ? 1 : 0}
        where id = ${this.id}
      """,
      p1: '1',
    );
    return result;
  }

  ulterBlock(bool? value) async {
    var result = await fetchQuery(
      query: """
        update usr_mast
        set isblock = ${value == true ? 1 : 0}
        where id = ${this.id}
      """,
      p1: '1',
    );
    return result;
  }

  getName() {
    return this.usrname;
  }

  login() async {
    var result = await fetchQuery(
        query:
            "select * from usr_mast where usr_nm = '${this.usrname}' and pwd = '${this.pass}' ");
    if ((result as List<dynamic>).length >= 1) {
      return {'msg': true, 'data': result[0]};
    }
    return {'msg': false, 'data': null};
  }

  available_option() {}
  display() {}
}
