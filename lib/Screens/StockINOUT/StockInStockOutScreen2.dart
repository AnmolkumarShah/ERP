import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/FetchFormatter.dart';
import 'package:softflow2/Helpers/dateFormatfromDataBase.dart';
import 'package:softflow2/Models/Shade.dart';
import 'package:softflow2/Models/Size.dart';
import 'package:softflow2/Models/StockInOut.dart';
import 'package:softflow2/Models/Type.dart';

// ignore: must_be_immutable
class StockInOutScreen2 extends StatefulWidget {
  StockInOut? stockinout;
  StockInOutScreen2({Key? key, this.stockinout}) : super(key: key);

  @override
  State<StockInOutScreen2> createState() => _StockInOutScreen2State();
}

class _StockInOutScreen2State extends State<StockInOutScreen2> {
  static int count = 0;
  List<dynamic>? list;
  List<Shade>? shadeItems;
  List<Size>? sizeItems;
  List<Type>? typeItems;

  Future init() async {
    List<Shade> shadeItems = await fetch(Shade());
    List<Size> sizeItems = await fetch(Size());
    List<Type> typeItems = await fetch(Type());
    final result = await fetch(widget.stockinout!);
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

    TextStyle? instyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );

    TextStyle? outstyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.orange,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock InOut Statements"),
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            " Size : ${list![index]['size']}",
                            style: style,
                          ),
                          Spacer(),
                          Text(
                            " Rollsize : ${list![index]['rollsize']}",
                            style: list![index]['rollsize'] < 0
                                ? minusvalue
                                : style,
                          ),
                        ],
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
                            " Tranref : ${list![index]['tranref']}",
                            style: style,
                          ),
                          Spacer(),
                          Text(
                            " Trantype : ${list![index]['Trantype']}",
                            style: style,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            " Rolls : ${list![index]['rolls']}",
                            style: (list![index]['Trantype'] as String)
                                    .toLowerCase()
                                    .contains('in')
                                ? instyle
                                : outstyle,
                          ),
                          Spacer(),
                          Text(
                            " Meters : ${list![index]['mtrs']}",
                            style: (list![index]['Trantype'] as String)
                                    .toLowerCase()
                                    .contains('in')
                                ? instyle
                                : outstyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            " Trandate : ${dateFormatFromDataBase(list![index]['trandate'])}",
                            style: style,
                          ),
                        ],
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
