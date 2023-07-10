import 'package:cuentas_ptt/class/Person.dart';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/utils/PeopleController.dart';
import 'package:cuentas_ptt/utils/RecordsController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';
import 'package:toggle_switch/toggle_switch.dart';


class FindPerson extends StatefulWidget{

  TextEditingController controller;
  @override
  FindPerson({required this.controller});

  _FindPersonState createState() => _FindPersonState(controller:controller);
}

class _FindPersonState extends State<FindPerson>{

  TextEditingController controller;
  _FindPersonState({required this.controller});

  List<Person> people = List.empty(growable: true);

  double getHeight(){
    if(people.length > 5){
      return 200;
    }
    return people.length * 60;
  }
  
  Future<void> handleList(String value) async{
    people.clear();
    List<Person> aux = await PeopleController.getPeople()?? [];
    setState(() {
      people = aux.where((element) => element.user.contains(value.toLowerCase())).toList();
      
    });
    
  }

      @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.all(0),
        content: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            child:  Container(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView(
              shrinkWrap: true,
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
                        controller: controller,
                        onChanged: (value) {
                          handleList(value);
                        },
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
                ),),
                (controller.text.isNotEmpty && people.isNotEmpty)? Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: getHeight(),
                  child: ListView.separated(
                    itemBuilder: (context, index) => Container(padding: EdgeInsets.all(10),child: InkWell(
                      onTap: () => setState(() {
                        controller.text = people[index].user;
                      }),
                      child: Text(people[index].user, style: TextStyle(color: Colors.black54)),
                    )),
                    separatorBuilder: (context, index) => Container(
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(color: Colors.black12),
                    ),
                    itemCount: people.length)
                ):Container(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
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
                      onTap: (){
                        setState(() {
                        });
                        Navigator.of(context).pop(controller.text);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Text("Guardar", style: TextStyle(color: Colors.black87,fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ]),
                )
              ],
            ))
            ))
      );
    }
}