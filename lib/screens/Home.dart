import 'package:flutter/material.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  _StateHome createState() => _StateHome();
}

class _StateHome extends State<Home>{

  bool Rtype = true;

  @override
  void initState() {
    super.initState();
    AppColor().setColors(Rtype);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    AppColor().setColors(Rtype);
  }



    @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        actions: [IconButton(onPressed: (){
          setState(() {
          Rtype = !Rtype;
        });}, icon: Icon(Icons.abc))]),
      body: Container(),
    );
  }

}