import 'package:cuentas_ptt/utils/Database.dart';
import 'package:cuentas_ptt/views/widgets/Record_item.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:flutter_switch/flutter_switch.dart';


typedef void boolCallback(bool i);

class HomeView extends StatefulWidget{
  Function getState;
  HomeView({super.key, required this.getState});

  @override
  _StateHome createState() => _StateHome(getState: getState);
}

class _StateHome extends State<HomeView>{
  Function getState;
  _StateHome({required this.getState});

  hanldeInsert() async{
    var res = await Database().insertPerson("niche");
    print(res);
  }

    @override
  Widget build(BuildContext context) {
    bool rtype = getState();
    print("entro2");
    return Scaffold(
      backgroundColor: AppColor.black,
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.all(15),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.2),
            ),
            child: InkWell(
              onTap: ()=>hanldeInsert(),
              child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.add_rounded, 
                    color: Colors.white,
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
                      Text("Agrega un registro de ingreso o egreso",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12
                        ),),
                    ],
                  )
                )
              ],
            ),
            ))
          ,Container(
            padding: EdgeInsets.all(20),
            child: RecordItem(getState: getState,),
          )      
        ],
      ),
    );
  }

}