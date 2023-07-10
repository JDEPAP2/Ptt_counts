import 'dart:ffi';

import 'package:cuentas_ptt/utils/Database.dart';
import 'package:cuentas_ptt/utils/RecordsController.dart';
import 'package:cuentas_ptt/views/widgets/Record_item.dart';
import 'package:cuentas_ptt/views/widgets/modals/Add_Record.dart';
import 'package:cuentas_ptt/views/widgets/modals/Calculator.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:objectid/objectid.dart';


class HomeView extends StatefulWidget{
  Function getState;
  HomeView({super.key, required this.getState});

  @override
  _StateHome createState() => _StateHome(getState: getState);
}

class _StateHome extends State<HomeView> with TickerProviderStateMixin{
  Function getState;
  _StateHome({required this.getState});

  late AnimationController controller;
  Record? lastRecord;
  bool rtype = false;

  @override
  void initState() {
    rtype = getState();
    handleAsync();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 2);
  }

  handleAsync () async {
    await handleLastRecord();
  }

  handleLastRecord () async{
    try {
      setState(() {lastRecord = null;});
      List<Record> records = await RecordsController.getRecords(getState())??[];
      if(records.isNotEmpty){
          lastRecord = records.last;
        }else{
          lastRecord = null;
      }
    setState(() {});
    } catch (e) {}

  }

  handleModal(Widget modal, BuildContext context) async{
    return await showModalBottomSheet(
      enableDrag: true,
      transitionAnimationController: controller,
      backgroundColor: Colors.transparent,
      context: context, 
      isScrollControlled: true,
      builder: (context)=> modal);
  }

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
    @override
  Widget build(BuildContext context) {
    if(getState()!= rtype){
      handleAsync();}
    rtype = getState();
    return Scaffold(
      backgroundColor: AppColor.black,
      body: RefreshIndicator(
        onRefresh: (){handleAsync(); getState(upd:true); return Future(() => null);},
        child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            alignment: Alignment.center,
            child: Text("Añadir Registros", style: TextStyle(color: AppColor.white,  fontSize: 25),),
          ),
          Container(
            padding: EdgeInsets.all(15),
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  height: 100,
                  padding: EdgeInsets.only(right: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.white.withOpacity(0.2),
                  ),
                  child: InkWell(
                    onTap: ()async{
                       await handleModal(AddRecord(), context);
                       try {
                          await handleProgress(Future.delayed(Duration(milliseconds: 500)));
                          handleAsync();
                        } catch (e) {
                          
                        }
                    },
                    child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.add_rounded, 
                          color: AppColor.white,
                          size: 70,),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Añadir Registro",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25
                              ),),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Agrega un registro de entrada o salida",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12
                              ),),
                          ],
                        )
                      )
                    ],
                  ),
                  )
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  height: 100,
                  padding: EdgeInsets.only(right: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.white.withOpacity(0.2),
                  ),
                  child: InkWell(
                    onTap: ()async{
                       await handleModal(Calculator(), context);
                       setState(() {
                         handleAsync();
                       });
                    },
                    child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.calculate_rounded, 
                          color: AppColor.white,
                          size: 70,),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Calcular Registro",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25
                              ),),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Calcula el valor de un registro de entrada o salida",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12
                              ),),
                          ],
                        )
                      )
                    ],
                  ),
                  )
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  height: 100,
                  padding: EdgeInsets.only(right: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.white.withOpacity(0.2),
                  ),
                  child: InkWell(
                    onTap: ()=> handleModal(AddRecord(), context),
                    child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.format_list_numbered_rounded, 
                          color: AppColor.white,
                          size: 70,),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Importar Registro",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25
                              ),),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Importar un registro de entrada o salida mediante un csv",
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12
                              ),),
                          ],
                        )
                      )
                    ],
                  ),
                  )
                ),
                ],
            ),
          ),Container(
            padding: EdgeInsets.only(top: 30, bottom: 10, left: 25),
            alignment: Alignment.topLeft,
            child: Text("Ultimo Registro", style: TextStyle(color: AppColor.white,  fontSize: 25),),
          ),
          lastRecord!=null?
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: RecordItem(getState: getState, record: lastRecord??Record(id: ObjectId(), nameId: ObjectId(), name: "", type: null, value: 0, date: DateTime.now()), update: () => handleAsync(),),
          ):
          Center(heightFactor: 5 ,child: Text("No hay " + (!rtype? "entradas": "salidas") + " aún", style: TextStyle(color: AppColor.white.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: 17) ,)),
          Container(
            padding: EdgeInsets.all(20),
            child: null,
          )      
        ],
      ),
    ));
  }

}