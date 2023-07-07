import 'package:cuentas_ptt/class/Person.dart';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/utils/RecordsController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';
import 'package:toggle_switch/toggle_switch.dart';


class InfoPerson extends StatefulWidget{
  @override
  Function getState;
  Person person;
  InfoPerson({required this.getState, required this.person});

  _InfoPersonState createState() => _InfoPersonState(getState:getState, person: person);
}

class _InfoPersonState extends State<InfoPerson>{

  Function getState;
  Person person;
  _InfoPersonState({required this.getState, required this.person});

  List<Record> records = List.empty(growable: true);
  bool edit = false, rtype = false;
  double total = 0;
  int selectedIndex = 0;

  @override
  void initState(){
    rtype = getState();
    selectedIndex = rtype? 1:0;
    handleAsync();
  }

  void handleAsync() async{
    await handleList(selectedIndex, null);
    handleTotal();
  }

  Future<void> handleList(int index, BuildContext? context) async{
    bool type = index == 1? true: false;
    
    if(context != null){
      showDialog(context: context, 
          builder: (context){
          return Center(child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(Colors.black),
            strokeWidth: 10,
          ));
    });
    }
    records = await RecordsController.findRecordByPerson(person.id, type)?? [];


    if(context != null)
      Navigator.of(context).pop();
    
    setState(() {
    });
  }

  handleTotal(){
    setState(() {
      total = 0;
      for(Record record in records){
        total += record.value;
      }
    });
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
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(200),
                image: DecorationImage(image: AssetImage('assets/images/user.png'), fit: BoxFit.cover)),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  alignment: Alignment.topRight,
                  child:  edit?Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(icon: Icon(Icons.check_circle_rounded, size: 30), padding: EdgeInsets.all(2),constraints: BoxConstraints(), onPressed: ()=> setState(() {edit = false;})), 
                    IconButton(icon: Icon(Icons.cancel_rounded, size: 30), padding: EdgeInsets.symmetric(horizontal:5),constraints: BoxConstraints(), onPressed: ()=> setState(() {edit = false;}))],
                  ):IconButton(icon: Icon(Icons.build_circle, size: 30), padding: EdgeInsets.all(2),constraints: BoxConstraints(), onPressed: ()=> setState(() {edit = true;}))
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text("(${FormatText.toFirstUpperCase(person.user)})", style: TextStyle(fontSize: 18, color: Colors.black45, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(person.name??"Nombre" + " " + (person.lastName??"Apellido"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.black12,
                  height: 2,
                  width: MediaQuery.of(context).size.width * 0.55,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(person.position??"Cargo", style: TextStyle(fontSize: 15))),
                      Spacer(),
                      Container(child: Text("C.C " + (person.cardId??"11.111.111")),
                      padding: EdgeInsets.symmetric(horizontal: 5))
                    ],
                  ),
                )
              ])
          ),
        
          ],
      ),
      Container(
        alignment: Alignment.center,
        child: ToggleSwitch(
        minWidth: MediaQuery.of(context).size.width * 0.425,
        initialLabelIndex: selectedIndex,
        cornerRadius: 15,
        activeFgColor: Colors.white,
        inactiveBgColor: Color.fromARGB(255, 122, 125, 139),
        inactiveFgColor: Color.fromARGB(255, 255, 255, 255),
        totalSwitches: 2,
        labels: ['Entradas', 'Salidas'],
        activeBgColors: [[AppColor().getPrimary(false)],[AppColor().getPrimary(true)]],
        onToggle: (index) async{
          if(index != null){
            await handleList(index, context);
            handleTotal();
            setState(() {
              selectedIndex = index;
            });
          }
        }),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        height: 200,
        width: double.maxFinite,
        child: RefreshIndicator(
          onRefresh: () async{
            handleList(selectedIndex, null);
          },
          child: ListView.separated(
          itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8)
                ),
              child: Row(children: [
              Text('${FormatDate.dateToString(records[index].date)}'),
              Spacer(),
              Text('${FormatValue.doubleToString(records[index].value)}'),
            ],),
        ),
        separatorBuilder: (context, index) => SizedBox(height: double.minPositive), 
        itemCount: records.length),
      )),
      Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            margin: EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(height: 2,color: Colors.black26),
                Container(padding: EdgeInsets.all(5),
                  child: Text("${FormatValue.doubleToString(total)}", style: TextStyle(color: AppColor().getPrimary(selectedIndex == 1? true: false), fontSize: 20)))
              ],
            ),
          )
      ],
      ));

  }
}

  // String user;
  // String? name;
  // String? lastName;
  // String? cardId;
  // DateTime? birthdate;
  // String? position;