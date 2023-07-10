import 'dart:async';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/files/RecordManager.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Database.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/utils/RecordsController.dart';
import 'package:cuentas_ptt/views/widgets/Record_item.dart';
import 'package:flutter/material.dart';

class FindView extends StatefulWidget{
   Function getState, getFunction;
   FindView({required this.getState, required this.getFunction});

  @override
  _FindState createState() => _FindState(getState: getState, getFunction: getFunction);

}

class _FindState extends State<FindView>{
  Function getState, getFunction;
  _FindState({required this.getState, required this.getFunction});
  List<Record> records = List.empty(growable: true);
  double total = 0;
  bool rtype = false;
  
  @override
  void initState() {
    rtype = getState();
    handleAsync();
    super.initState();

  }


  Future<void> handleAsync() async{
    await handleRecords();
  }

  Future<void> handleRecords() async{
    try {
      records.clear();
      setState(() {});
      List<Record> auxR = await RecordsController.getRecords(getState())??[];
      if(auxR.isEmpty){
        records.clear();
      }else{
        records = auxR;
      }
      total = 0;
      records.forEach((e)=>total+=e.value);


      setState(() {});
    } catch (e) {
      
    }
  }



    @override
  Widget build(BuildContext context) {
    if(getState()!= rtype){
      handleAsync();}
    rtype = getState();
    
    return Scaffold(
      backgroundColor: AppColor.black,
      body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: RefreshIndicator(
            color: AppColor.primary,
            onRefresh: () async {
              await handleAsync();
              getState(upd:true);
            } ,
            child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            alignment: Alignment.center,
            child: Text("Buscar Registros", style: TextStyle(color: AppColor.white,  fontSize: 25),),
          ),
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
                  onChanged: (value){
                  },
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
          records.isNotEmpty? Container(
            height: 350,
            child: ListView.separated(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i){
                return Container(
                        padding: EdgeInsets.symmetric(horizontal:20, vertical: 5),
                        child: RecordItem(getState: getState, record: records[i], update: handleAsync),
                        );}, 
                        separatorBuilder: (context, i){
                          return SizedBox();
                        }, 
                        itemCount: records.length),
          ):Center(heightFactor: 10 ,child: Text("No hay " + (!rtype? "entradas": "salidas") + " aún", style: TextStyle(color: AppColor.white.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 17) ,)),
          records.isNotEmpty?Container(
            height: 85,
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            margin: EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(height: 2,color: AppColor.white.withOpacity(0.3)),
                Container(padding: EdgeInsets.all(5),
                  child: Text('\$ ${FormatValue.doubleToString(total)}', style: TextStyle(color: AppColor.light, fontSize: 25)))
              ],
            ),
          ):Container()
        ],
      )),)
    );
  }
}
