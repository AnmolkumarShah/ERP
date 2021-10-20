import 'package:flutter/material.dart';
import 'package:softflow2/Helpers/FieldCover.dart';
import 'package:softflow2/Helpers/SaveFormatter.dart';
import 'package:softflow2/Helpers/Snakebar.dart';

class AddShade extends StatefulWidget {
  const AddShade({Key? key}) : super(key: key);

  @override
  State<AddShade> createState() => _AddShadeState();
}

class _AddShadeState extends State<AddShade> {
  bool? loading;
  @override
  Widget build(BuildContext context) {
    TextEditingController? _shade = TextEditingController(text: "");
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Shade"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Fieldcover(
            child: TextFormField(
              controller: _shade,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          loading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () async {
                    if (_shade!.value.text == '') {
                      showSnakeBar(context, "Enter Shade Value First");
                      return;
                    }
                    setState(() {
                      loading = true;
                    });

                    String? query = '''
                insert into shade(shade)
                values('${_shade!.value.text}')
              ''';
                    var result = await saveFormatter(query);
                    if (result['status'] == 'success') {
                      showSnakeBar(context, "Shade Entered Successfully");
                    }
                    setState(() {
                      loading = false;
                      _shade = TextEditingController(text: "");
                    });
                  },
                  child: Text("Add Shade"),
                )
        ],
      ),
    );
  }
}
