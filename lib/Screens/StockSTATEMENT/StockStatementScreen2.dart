import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/FetchFormatter.dart';
import 'package:softflow2/Models/Shade.dart';
import 'package:softflow2/Models/Size.dart';
import 'package:softflow2/Models/Type.dart';
import 'package:softflow2/Models/Stock.dart';

import 'StockStatementScreen3.dart';

// ignore: must_be_immutable
class StockStatementScreen2 extends StatefulWidget {
  Stock? stock;
  StockStatementScreen2({Key? key, this.stock}) : super(key: key);

  @override
  State<StockStatementScreen2> createState() => _StockStatementScreen2State();
}

class _StockStatementScreen2State extends State<StockStatementScreen2> {
  static int count = 0;
  List<dynamic>? list;
  List<Shade>? shadeItems;
  List<Size>? sizeItems;
  List<Type>? typeItems;

  Future init() async {
    List<Shade> shadeItems = await fetch(Shade());
    List<Size> sizeItems = await fetch(Size());
    List<Type> typeItems = await fetch(Type());
    final result = await fetch(widget.stock!);
    setState(() {
      this.list = result;
      this.shadeItems = shadeItems;
      this.sizeItems = sizeItems;
      this.typeItems = typeItems;
    });
  }

  Future _fetch() async {
    if (count > 0) return;
    await init();
    count += 1;
  }

  @override
  void didChangeDependencies() {
    count = 0;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    TextStyle? minusvalue = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.red,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock Statements"),
      ),
      body: FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (this.list!.length == 0) {
            return Center(
              child: Chip(
                label: Text("No Data"),
              ),
            );
          }
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: ListView.builder(
              itemCount: list!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockStatementScreen3(
                          shade: shadeItems!.firstWhere(
                              (e) => e.desc == list![index]['shade']),
                          size: sizeItems!.firstWhere(
                              (e) => e.desc == list![index]['size']),
                          type: typeItems!.firstWhere(
                              (e) => e.desc == list![index]['type']),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " Size : ${list![index]['size']}",
                          style: style,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              " Shade : ${list![index]['shade']}",
                              style: style,
                            ),
                            Spacer(),
                            Text(
                              " Type : ${list![index]['type']}",
                              style: style,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              " Rolls : ${list![index]['rolls']}",
                              style: list![index]['rolls'] < 0
                                  ? minusvalue
                                  : style,
                            ),
                            Spacer(),
                            Text(
                              " Meters : ${list![index]['mtrs']}",
                              style: (list![index]['mtrs']) < 0
                                  ? minusvalue
                                  : style,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
