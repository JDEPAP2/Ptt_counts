import 'package:cuentas_ptt/views/Page_switcher.dart';
import 'package:cuentas_ptt/views/widgets/modals/Finger.dart';
import 'package:cuentas_ptt/views/widgets/modals/Pin.dart';
import 'package:flutter/material.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';



class LockView extends StatefulWidget{
  const LockView();

  @override
  _LockViewState createState() => _LockViewState();
}

class _LockViewState extends State<LockView> with TickerProviderStateMixin{

  _LockViewState();

  late AnimationController controller;

    @override
  void initState() {
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 1);
  }


  handleModal(Widget modal, BuildContext context) async{
    print(controller);
    return await showModalBottomSheet(
      enableDrag: true,
      transitionAnimationController: controller,
      backgroundColor: Colors.transparent,
      context: context, 
      isScrollControlled: true,
      builder: (context)=> modal);
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: Container(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text("Cuentas Ptt",style: TextStyle(color: Colors.white, fontSize: 40)),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Text("Para iniciar elija \ncualquiera de las 2 opciones",textAlign: TextAlign.center,style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColor().getPrimary(true), borderRadius: BorderRadius.circular(100)),
                child: IconButton(icon: Icon(Icons.fingerprint, color: Colors.white), iconSize: 70, padding: EdgeInsets.zero, onPressed: () async{
                  await handleModal(Finger(), context);
                }),
                ),
              ),
              Container(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColor().getPrimary(false), borderRadius: BorderRadius.circular(200)),
                child: IconButton(icon: Icon(Icons.pin, color: Colors.white), iconSize: 70, padding: EdgeInsets.zero, onPressed: () async{
                  await handleModal(Pin(), context);
                }),
                ),
              ) 
            ],
          )
        ],
      )
    ,));
  }

}