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


class InfoPerson extends StatefulWidget{
  @override
  _InfoPersonState createState() => _InfoPersonState();
}

class _InfoPersonState extends State<InfoPerson>{

  List People = List.empty(growable: true);

  @override
  void initState() {

  }

      @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: MediaQuery.of(context).viewInsets.bottom == 0? MediaQuery.of(context).size.height * 0.8: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(200),
                image: DecorationImage(image: AssetImage('assets/images/user.png'), fit: BoxFit.cover)),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Nombre y Apellido", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text("User", style: TextStyle(fontSize: 20, color: Colors.black45, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.black12,
                  height: 2,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text("Cargo", style: TextStyle(fontSize: 18))),
                      Spacer(),
                      Container(child: Text("Nombre"),
                      padding: EdgeInsets.symmetric(horizontal: 5))
                    ],
                  ),
                )
              ])
          ),
        
          ],
      ),
      Container(
        margin: EdgeInsets.only(top: 20),
        height: 50,
        color: Colors.black87,
      )
        ],
      )
      );
  }
}

  // String user;
  // String? name;
  // String? lastName;
  // String? cardId;
  // DateTime? birthdate;
  // String? position;