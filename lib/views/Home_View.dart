import 'package:cuentas_ptt/utils/Database.dart';
import 'package:cuentas_ptt/views/widgets/Record_item.dart';
import 'package:cuentas_ptt/views/widgets/modals/Add_Register.dart';
import 'package:cuentas_ptt/views/widgets/modals/Calculator.dart';
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

class _StateHome extends State<HomeView> with TickerProviderStateMixin{
  Function getState;
  _StateHome({required this.getState});

  late AnimationController controller;

  @override
  void initState() {
    transitionAnimationController: controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 1);
  }

  hanldeInsert() async{
    var res = await Database().insertPerson("niche");
    print(res);
  }

  handleModal(Widget modal, BuildContext context) async{
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
    return Scaffold(
      backgroundColor: AppColor.black,
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
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
                    onTap: ()=> handleModal(AddRegister(), context),
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
                    onTap: ()=> handleModal(Calculator(), context),
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
                            Text("Calcula el valor de un registro de ingreso o egreso",
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
                    onTap: ()=> handleModal(AddRegister(), context),
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
                            Text("Importar un registro de ingreso o egreso mediante un csv",
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
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: null,
          )      
        ],
      ),
    );
  }

}