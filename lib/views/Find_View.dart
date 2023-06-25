import 'dart:ffi';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Database.dart';
import 'package:cuentas_ptt/views/widgets/Record_item.dart';
import 'package:flutter/material.dart';

class FindView extends StatefulWidget{
   Function getState;

   FindView({super.key, required this.getState});

  @override
  _FindState createState() => _FindState(getState: getState);


  
}

class _FindState extends State<FindView>{
  Function getState;
  _FindState({required this.getState});
  List<Record> list = List.empty(growable: true);

  handleRegisters(state)async{
    list = List.empty(growable: true);
    List<Record> dbList = await Database().getRecordsByType(state);
    if(dbList.isNotEmpty){
      list = dbList;
    }
  }

  @override
  void initState() {
    handleRegisters(getState());
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    handleRegisters(getState());
    super.setState(fn);
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            child: Row(children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.only(top: 15, left: 15),
                child:Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                height: 50,
                child: TextField(
                  cursorColor: AppColor.light,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration( 
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                    hintText: "Buscar registro"
                  ),
                ),
              )),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: EdgeInsets.only(top: 15, left: 10, right: 15),
                child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                height: 50,
                child: InkWell(
                  splashColor: AppColor.black,
                  onTap: () => {},
                  child: Icon(Icons.filter_list_alt, color: AppColor.dark,)
                )
                ),
              )
            ]),
          ),

          SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i){
              return Container(
                      padding: EdgeInsets.symmetric(horizontal:20, vertical: 5),
                      child: RecordItem(getState: getState, record: list[i]),
                    );  
            }, 
            separatorBuilder: (context, i){
              return SizedBox();
            }, 
            itemCount: list.length)
        ],
      ),
      
    );
  }
}
