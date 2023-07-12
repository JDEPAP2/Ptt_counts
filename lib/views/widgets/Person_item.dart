import 'package:cuentas_ptt/class/Person.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/views/Page_switcher.dart';
import 'package:cuentas_ptt/views/widgets/modals/Info_Person.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';

class PersonItem extends StatefulWidget{
  Function getState, index;
  Person person;
  Function? update;
  PersonItem({required this.getState, required this.person, required this.index, this.update});

  @override
  _PersonItemState createState() => _PersonItemState(getState: getState, index: index, person: person, update: update);
}

class _PersonItemState extends State<PersonItem> with TickerProviderStateMixin{

    late AnimationController controller;

  @override
  void initState() {
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 1);;
  }

  Function getState, index;
  Person person;
  Function? update;
  _PersonItemState({required this.getState, required this.person, required this.index, this.update});

  Future<dynamic> handleModal(Widget modal, BuildContext context) async{
    return await showModalBottomSheet(
      transitionAnimationController: controller,
      backgroundColor: Colors.transparent,
      context: context, 
      isScrollControlled: true,
      builder: (builder) => modal);
  }



      @override
  Widget build(BuildContext context) {
    bool rtype = getState();

    handleProgress(Future<dynamic> function) async{
        showDialog(context: context, 
          builder: (context){
          return Center(child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(AppColor.secondary),
            strokeWidth: 10,
          ));
        });
        var res = await function;
        Navigator.of(context).pop();
        return res;
    }

    return InkWell(
      splashColor: AppColor.light,
      onTap: () async{
        await handleModal(InfoPerson(getState: getState, person: person), context);
        try {
          await handleProgress(Future.delayed(Duration(milliseconds: 1000)));
          update!();
          getState(upd:true);
        } catch (e) {
          
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(
                    padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: Text(FormatText.toFirstUpperCase(person.user),
                    style: TextStyle(fontSize: 22,
                    color: AppColor.black)),
                  ),
            Container(
              padding: EdgeInsets.all(8),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5)
                ), 
                child: Row(
                  children: [
                    Text("Numero de " + (!rtype? "entradas": "salidas") + " registrados:", 
                    style: TextStyle(color: AppColor.dark.withOpacity(0.7))),
                    Text("${index()}", 
                    style: TextStyle(color: AppColor.dark.withOpacity(0.8))),
                  ],
                ),
              )
            )
          ]
          ),
      )
    );}
}