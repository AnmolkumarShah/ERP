import 'package:softflow2/Interface/Model_Interface.dart';
import 'package:softflow2/Models/Shade.dart';
import 'package:softflow2/Models/Size.dart';
import 'package:softflow2/Models/Trantype.dart';
import 'package:softflow2/Models/Type.dart';

class Stock implements Model {
  Size? size;
  Shade? shade;
  Type? type;
  String? query;
  Trantype? trantype;

  Stock({Size? s, Shade? shade, Type? t, Trantype? tran}) {
    this.shade = shade;
    this.size = s;
    this.type = t;
    this.trantype = tran;
    this.query = this.draftQuery();
  }

  String draftQuery() {
    String? decider = '';

    if (this.shade!.id != -1) {
      decider += " and a.shade = ${this.shade!.id} ";
    }

    if (this.size!.id != -1) {
      decider += " and a.size = ${this.size!.id} ";
    }

    if (this.type!.id != -1) {
      decider += " and a.type = ${this.type!.id} ";
    }

    if (this.trantype!.id != -1) {
      decider += " and a.TranType = ${this.trantype!.id} ";
    }

    String? draft_query = '''

  select
  b.size,c.shade,d.type, 
  ISNULL((select sum(rolls) from transactions where trantype = 1 and
  size = a.size and shade = a.shade and type = a.type),0) -
  ISNULL((select sum(rolls) from transactions where trantype = 2 and
  size = a.size and shade = a.shade and type = a.type),0) as rolls,
  ISNULL((select sum(mtrs) from transactions where trantype = 1 and
  size = a.size and shade = a.shade and type = a.type),0) -
  ISNULL((select sum(mtrs) from transactions where trantype = 2 and
  size = a.size and shade = a.shade and type = a.type),0) as mtrs
  from
  transactions a
  left join size b on a.size = b.id
  left join shade c on a.shade = c.id
  left join type d on a.type = d.id
  where 0 = 0 $decider
  group by b.size,c.shade,d.type,a.size,a.shade,a.type
  order by c.shade, b.size,d.type
  
  ''';
    return draft_query;
  }

  @override
  display() {
    return "Stock Display";
  }

  @override
  format(List li) {
    return li;
  }

  @override
  getQuery() {
    return this.query;
  }
}
