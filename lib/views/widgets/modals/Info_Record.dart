
import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/files/DataManager.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/utils/RecordsController.dart';
import 'package:cuentas_ptt/views/widgets/modals/Edit_Record.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tip_dialog/tip_dialog.dart';

import 'package:widgets_to_image/widgets_to_image.dart';


class InfoRecord extends StatefulWidget{
  
  Record record;
  @override
  InfoRecord({required this.record});

  _InfoRecordState createState() => _InfoRecordState(record: record);
}

class _InfoRecordState extends State<InfoRecord> with TickerProviderStateMixin{

  Record record;
  _InfoRecordState({required this.record});
  WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;
  late AnimationController controllerAnim;



  @override
  void initState() {
    transitionAnimationController: controllerAnim = BottomSheet.createAnimationController(this);
    controllerAnim.duration = Duration(seconds: 1);
  }

  Future<dynamic> handleModal(Widget modal, BuildContext context) async{
      return await showModalBottomSheet(
        transitionAnimationController: controllerAnim,
        backgroundColor: Colors.transparent,
        context: context, 
        isScrollControlled: true,
        builder: (builder) => modal);
    }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.light,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: MediaQuery.of(context).viewInsets.bottom == 0? MediaQuery.of(context).size.height * 0.635: double.maxFinite,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 15),
            alignment: Alignment.center,
            child: Text("Información del Registro", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
          ),
          
          WidgetsToImage(
            child: Container(
            decoration: BoxDecoration(
              // boxShadow: [BoxShadow(
              //   offset: Offset(2, 2),
              //   blurRadius: 5,
              //   spreadRadius: 0.5,
              //   color: Colors.black12
              // )]
            ),
            child: ClipPath(
            clipper: ZigZagClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Stack(
                children: [
                  Positioned(
                    child: (
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.monetization_on, size: 400, color: AppColor.dark.withOpacity(0.05),),
                      )
                    )
                  ),
                  ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.topRight,
                    child: Row(
                      children: [
                        Text(record.type == false?"Entrada":"Salida",style: TextStyle(fontSize: 18, color: AppColor.dark.withOpacity(0.5))),
                        Spacer(),
                        Text(FormatDate.dateToString(record.date),style: TextStyle(fontSize: 18, color: Colors.black45))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Text("Comprobante realizado en:"),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.centerLeft,
                    child: Text("Cuentas Ptt",style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Text("Numero de referencia:"),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.centerLeft,
                    child: Text("${record.id}".toUpperCase(),style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                          padding: EdgeInsets.only(top: 15,bottom: 5),
                          alignment: Alignment.centerLeft,
                          child: Text("Persona:"),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(FormatText.toFirstUpperCase(record.name),style: TextStyle(fontSize: 25)),
                        ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          Container(
                            padding: EdgeInsets.only(top: 15,bottom: 5),
                            alignment: Alignment.centerRight,
                            child: Text("Valor:",style: TextStyle(fontSize: 15)),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(FormatValue.doubleToString(record.value),style: TextStyle(fontSize: 30, color: AppColor.dark)),
                          ),
                          ],
                        )
                      ],
                    )
                  ), 
                  record.observation == null ||record.observation == ""?Container(
                  ):Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text("Observacion:"),),
                  record.observation == null ||record.observation == ""?Container(
                  ):Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.centerLeft,
                    child: Text("${record.observation}", style: TextStyle(color: Colors.black45))),
                ],
              ),
              
                ],
              ),
              height: record.observation == null ||record.observation == ""? 270:320,
          )),
          )
      ,
      controller: controller,
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(color: AppColor.dark, borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                  onPressed: () async {
                      final bytes = await controller.capture();
                      setState(() {
                        this.bytes = bytes;
                      });
                      if(await DataManager.writeStreamDataChoose("/${record.id}.png", bytes??Uint8List(1)) != null){
                        await QuickAlert.show(context: context, type: QuickAlertType.success, text: "El archivo se descargo exitosamente", showCancelBtn: false, confirmBtnText: "Aceptar");
                        Navigator.of(context).pop();
                      }else{
                        await QuickAlert.show(context: context, type: QuickAlertType.error, text: "El archivo no se pudo descargar", showCancelBtn: false, confirmBtnText: "Aceptar");
                      }

                      }, 
                      icon: Icon(Icons.download, color: Colors.white,))),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(color: AppColor.dark, borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                  onPressed: () async {
                        final bytes = await controller.capture();
                        setState(() {
                          this.bytes = bytes;
                        });
                        String? path = await DataManager.writeStreamData("/${record.id}.png", bytes??Uint8List(1));
                        if(path != null){
                          await Share.shareFiles([path], text: 'Comprobante Ptt');
                        }
                        Navigator.of(context).pop();
                      }, 
                      icon: Icon(Icons.share, color: Colors.white,))),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(color: AppColor.dark, borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                  onPressed: () async {
                      var modalRes = await handleModal(EditRegister(record: record), context);
                      if(modalRes is Record){
                        setState(() {
                          record = modalRes;
                        });
                      }
                      }, 
                      icon: Icon(Icons.edit, color: Colors.white,))),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(color: AppColor.dark, borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                  onPressed: () async {
                      QuickAlert.show(
                        context: context, 
                        type: QuickAlertType.confirm,
                        cancelBtnText: "Cancelar",
                        confirmBtnColor: Colors.red,
                        confirmBtnText: "Eliminar",
                        title: "Eliminar Registro",
                        text: "¿Esta seguro que desea eliminar este registro?",
                        onConfirmBtnTap: () async{
                          Navigator.of(context).pop();
                          await RecordsController.removeRecord(record.id);
                          await QuickAlert.show(context: context, type: QuickAlertType.success, text: "El archivo se elimino exitosamente", showCancelBtn: false, confirmBtnText: "Aceptar", onCancelBtnTap: ()=>Navigator.of(context).pop(), onConfirmBtnTap: ()=>Navigator.of(context).pop());
                          Navigator.of(context).pop();
                        },
                        );
                      // 
                      }, 
                      icon: Icon(Icons.delete, color: Colors.white,))),
          ],
        ),
      ),
      ],
      ))
);
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    double x = 0;
    double y = size.height;
    double increment = size.width / 20;

    while (x < size.width) {
      x += increment;
      y = (y == size.height) ? size.height * .95 : size.height;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}