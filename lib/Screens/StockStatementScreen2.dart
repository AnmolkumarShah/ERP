import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/FetchFormatter.dart';
import 'package:softflow2/Models/Stock.dart';

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
  Future init() async {
    final result = await fetch(widget.stock!);
    setState(() {
      this.list = result;
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
                return Container(
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
                      Text(
                        " Shade : ${list![index]['shade']}",
                        style: style,
                      ),
                      Text(
                        " Type : ${list![index]['type']}",
                        style: style,
                      ),
                      Text(
                        " Rolls : ${list![index]['rolls']}",
                        style: style,
                      ),
                      Text(
                        " Meters : ${list![index]['mtrs']}",
                        style: style,
                      ),
                    ],
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
