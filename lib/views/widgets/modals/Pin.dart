

import 'dart:math';

import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/views/Page_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:function_tree/function_tree.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:numberpicker/numberpicker.dart';

class Pin extends StatefulWidget{
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin>{
  bool? check;
  Map<String,int> values ={
    "v1" : 0, "v2" : 0, "v3" : 0, "v4" : 0, "v5" : 0, "v6" : 0
  } ;
  List<int> checkV = [1,2,2,1,1,2];


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor().getPrimary(false),
        borderRadius: BorderRadius.circular(20)
      ),
      height: MediaQuery.of(context).size.height * 0.35,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView(
        shrinkWrap: true,
        children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text("Coloque el pin correcto, \ny valide para poder acceder",textAlign: TextAlign.center,style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)),
          ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width *0.8,
          height: 100,
          child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder:(context, index) => Container(
            width: 40,
            height: 70,
            child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black12), 
            child: NumberPicker(minValue: 0, maxValue: 9, value: values["v${index+1}"]??0, itemHeight: 30, infiniteLoop: true,
            selectedTextStyle: TextStyle(color: Colors.white, fontSize: 25),textStyle: TextStyle(color: Color.fromARGB(255, 55, 165, 255)),
            axis: Axis.vertical,
            onChanged: (val)async{
              setState(() {
                values.update("v${index+1}", (value) => val);
              });
              List<int> test = values.values.toList();
              if(test[0] == checkV[0] && test[1] == checkV[1] && test[2] == checkV[2] && test[3] == checkV[3] && test[4] == checkV[4] && test[5] == checkV[5] && test[5] == checkV[5]){
                await Future.delayed(Duration(seconds: 2));
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PageSwitcher()),
                  );
              }
            })),
          ), 
          separatorBuilder:(context, index) =>SizedBox(width: 5), 
          itemCount: 6),
        ),
        check == false?Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text("Algo salio mal, vuelve a intentarlo",textAlign: TextAlign.center,style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)),
          ):Container()
      ]),)
      );
        
}}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}