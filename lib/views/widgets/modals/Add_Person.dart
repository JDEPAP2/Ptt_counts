import 'package:cuentas_ptt/class/Person.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/utils/PeopleController.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';
import 'package:quickalert/quickalert.dart';



class AddPerson extends StatefulWidget{

  @override
  AddPerson();

  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson>{

  _AddPersonState();

  List<Person> people = List.empty(growable: true);
  TextEditingController controller = TextEditingController();
  bool error = false;
  String message = "No deje el campo vacio";
  Icon? stat;

  double getHeight(){
    if(people.length > 3){
      return 100;
    }
    return people.length * 60;
  }
  
  Future<void> handleList(String value) async{
    List<Person> aux = await PeopleController.getPeople()?? [];
    people = aux.where((element) => element.user.contains(value.toLowerCase())).toList();
    setState(() {
    });
  }

  Future<bool> checkPeople(String value) async{
    List<Person> auxC = await PeopleController.getPeople()?? [];
    List check = auxC.where((element) => element.user == value.toLowerCase()).toList();
    bool res = false;
    if (check.isEmpty) {
      stat = Icon(Icons.check, color: Colors.green);
      res = true;
    }else if(value.isEmpty){
      stat = null;
      res = false;
    }else{
      stat = Icon(Icons.close, color: Colors.red);
      res = false;
    }

    setState(() {
    });

    return res;

  }

  Future<bool> save(String value) async{
    return PeopleController.addPerson(value);
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
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
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
                          String cValue = FormatText.removeSpaces(value);
                          handleList(cValue);
                          checkPeople(cValue);
                          error = false;
                          setState(() {});
                        },
                        maxLength: 40,
                        decoration: InputDecoration(
                              icon: stat,
                              counterText: "",
                              counter: null,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: "Escribir nombre",
                              hintStyle: TextStyle(fontSize: 15, color: Colors.black38),
                              labelStyle: TextStyle(fontSize: 15)),
                        )
                ),),
                error?Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: Text(message, style: TextStyle(fontSize: 13, color: Colors.red.withOpacity(0.9)))):SizedBox(),
                (controller.text.isNotEmpty && people.isNotEmpty)? Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: getHeight(),
                  child: ListView.separated(
                    itemBuilder: (context, index) => Container(padding: EdgeInsets.all(10),child: InkWell(
                      onTap: () => setState(() {
                        controller.text = people[index].user;
                      }),
                      child: Text(FormatText.toFirstUpperCase(people[index].user), style: TextStyle(color: Colors.black54)),
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
                      onTap: () async{
                        message = "No deje el campo vacio";
                        if(controller.text.replaceAll(" ", "").isNotEmpty){
                          message = "Ya existe una persona con este nombre";
                          if(await checkPeople(controller.text)){
                            error = false;
                            String personName = FormatText.removeSpaces(controller.text.toLowerCase());
                            if(await save(personName)){
                              message = "";
                              await QuickAlert.show(
                                context: context, 
                                type: QuickAlertType.success, 
                                text: "Persona Añadida Exitosamente");
                              Navigator.of(context).pop();
                              
                            }else{
                              QuickAlert.show(
                                context: context, 
                                type: QuickAlertType.error, 
                                text: "Ocurrio un error, intenta mas tarde");
                            }
                          }
                        }
                        error = true;
                        setState(() {});
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