import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:softflow2/Provider/MainProvider.dart';
import 'package:softflow2/Screens/Dashboard.dart';
import 'package:softflow2/Screens/LoginScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Edge Band Inventory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: LoginScreen(),
        routes: {
          "/dashboard": (context) => Dashboard(),
        },
      ),
    );
  }
}
