

import 'dart:math';

import 'package:cuentas_ptt/utils/Format.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';
import 'package:intl/intl.dart';

class Calculator extends StatefulWidget{
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator>{

  double value = 0;
  String valueText = "0";
  String history = "0";
  final List items = [
    {"color": Color.fromARGB(183, 19, 20, 27), "text": "^", "operator": true},
    {"color": Color.fromARGB(183, 19, 20, 27), "text": "⁒", "operator": true},
    {"color": Color.fromARGB(183, 19, 20, 27), "text": "CE", "del": true},
    {"color": Color.fromARGB(214, 156, 26, 26), "text": "AC", "clear": true},
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "7", "num": true},
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "8", "num": true},
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "9", "num": true},
    {"color": Color.fromARGB(183, 19, 20, 27), "text": "÷", "operator": true },
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "4", "num": true},
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "5", "num": true},
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "6", "num": true},
    {"color": Color.fromARGB(183, 19, 20, 27), "text": "×", "operator": true},
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "1", "num": true},
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "2", "num": true},
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "3", "num": true},
    {"color": Color.fromARGB(183, 19, 20, 27), "text": "–", "operator": true},
    {"color": Color.fromARGB(216, 19, 20, 27), "text": "0", "num": true},
    {"color": Color.fromARGB(183, 19, 20, 27), "text": ".", "num": true},
    {"color": Color.fromARGB(215, 29, 90, 27), "text": "=", "result": true},
    {"color": Color.fromARGB(183, 19, 20, 27), "text": "+", "operator": true},
  ];

  logicCalculator(){
    setState(() {
      try {
        if(valueText == "NaN" || valueText == "∞"){
          valueText = "0";
        }
        history = valueText;
        value = double.parse('${valueText.interpret()}');
        valueText = NumberFormat("#.###").format(value);
      } catch (e) {
        value = 0;
        history = "Error";
      }
    });
  }
  textCalculator(value){
      if (value["num"] == true){
        if(double.tryParse(valueText) == 0 || valueText == "NaN"){
          valueText = "";
        }
        valueText += value["text"];
      }
      
      if(value["operator"] == true){
        switch(value["text"]){
          case "÷":
            valueText += " / ";
            break;
          case "–":
            valueText += " - ";
            break;
          case "×":
            valueText += " * ";
            break;
          case "⁒":
            valueText += " % ";
            break;
          default:
            valueText += " ${value["text"]} ";
            break;
        }
      }

      if(value["clear"] == true){
        valueText = "0";
      }

      if(value["del"] == true){
        if(valueText.length != 1){
          List spl = valueText.split("");
          if(spl[spl.length-1] == " "){
            for (var i = 0; i < 3; i++) {
              spl.removeAt(spl.length-1);
            }
          }else{
            spl.removeLast();
          }
          valueText = "";
          spl.forEach((element)=> valueText+= element);
        }else{
        valueText = "0";
      }
      }
      return valueText;
  }
 
    @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      height: MediaQuery.of(context).viewInsets.bottom == 0? MediaQuery.of(context).size.height * 0.8: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.all(20),
                  height: 80,
                  width: double.maxFinite,
                  child: Text(valueText, style: TextStyle(fontSize: 30, color: Colors.black54)),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal:20),
                  decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
                  ),
                  height: 50,
                  width: double.maxFinite,
                  child: Text(history, style: TextStyle(fontSize: 20, color: Colors.black45))
                )
              ],
            ),
            height: 130,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10)
            )
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: GridView.count(
              shrinkWrap: true,         
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 1.4,
              physics: BouncingScrollPhysics(),
              children: List.generate(20, (index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: items[index]['color']),
                    child: InkWell(
                      onTap: () {
                        if(items[index]['result'] == true){
                          logicCalculator();
                        }else{
                          setState(() {
                            valueText = textCalculator(items[index]);
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(items[index]['text'], style: TextStyle(color: Colors.white, fontSize: 30)),
                      ),
                ));
              }),
            ),
          )
        ]
      )  
    );
  }

}