import 'package:cuentas_ptt/utils/Database.dart';
import 'package:cuentas_ptt/views/Home_View.dart';
import 'package:cuentas_ptt/views/Lock_View.dart';
import 'package:cuentas_ptt/views/Page_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget{
  const MyApp({super.key});
  @override
  _MyAppState createState()=> _MyAppState();

}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // loadDatabase();
    
  }

  loadDatabase() async{
    await Database().initDatabase();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LockView(),
    );
  }
}

