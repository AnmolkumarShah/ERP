import '../Interface/Model_Interface.dart';

class Size implements Model {
  int? id;
  String? desc;
  static String query = 'select * from size order by size';
  Size({this.desc, this.id});

  @override
  display() {
    return this.desc;
  }

  @override
  getQuery() {
    return Size.query;
  }

  @override
  format(List li) {
    return li.map((e) => Size(desc: e['size'], id: e['id'])).toList();
  }
}
