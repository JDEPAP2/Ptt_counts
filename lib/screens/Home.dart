import 'package:flutter/material.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:flutter_switch/flutter_switch.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  _StateHome createState() => _StateHome();
}

class _StateHome extends State<Home>{

  bool rtype = false;

  @override
  void initState() {
    super.initState();
    AppColor().setColors(rtype);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    AppColor().setColors(rtype);
  }



    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(rtype? "Egresos":"Ingresos", style:TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: AppColor.primary,
        leadingWidth: 100,
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: FlutterSwitch(
            activeColor: AppColor.light,
            inactiveColor: AppColor.light,
            value: rtype, 
            onToggle: (v){
        setState(() {
          rtype = v;
        });
      }),
        )
      ),
      body: Container(),
      
    );
  }

}