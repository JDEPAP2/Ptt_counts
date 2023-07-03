import 'dart:math';
import 'package:cuentas_ptt/class/Person.dart';
import 'package:cuentas_ptt/utils/Database.dart';
import 'package:cuentas_ptt/utils/PeopleController.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';
import 'package:objectid/objectid.dart';


class AddPerson extends StatefulWidget{
  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson>{

  List People = List.empty(growable: true);

  @override
  void initState() {

  }

  String toFirstUpperCase(String s){
    List<String> chars = s.split("");
    chars[0] = chars[0].toUpperCase();
    String res = "";
    chars.forEach((e)=> res +=e);
    return res;
  }


  handleInsert(String name)async{
    return Database().getPersonByName(name);
  }


      @override
  Widget build(BuildContext context) {

    return AlertDialog(

      backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.all(0),
        content: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            child:  Container(
              height: 165,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  child: Text("Añadir Persona", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                        width: double.maxFinite,
                        child: TextField(
                        maxLength: 40,
                        decoration: InputDecoration(
                              counterText: "",
                              counter: null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: "Escribir nombre",
                              hintStyle: TextStyle(fontSize: 15, color: Colors.black38),
                              labelStyle: TextStyle(fontSize: 15)),
                        )
                )),
                Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("Cancelar", style: TextStyle(color: Colors.black87,fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black.withOpacity(0.15) )
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        // PeopleController.addPerson(Person(id: ObjectId(), user: "A"));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("Añadir", style: TextStyle(color: Colors.black87,fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ]),
                )
              ],
            ))
          )
      );
  }
}