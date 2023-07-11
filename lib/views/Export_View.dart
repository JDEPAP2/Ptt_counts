import 'dart:io';

import 'package:cuentas_ptt/files/DataManager.dart';
import 'package:cuentas_ptt/files/ExcelManager.dart';
import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:cuentas_ptt/views/widgets/Filter_item.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ExportView extends StatefulWidget{
  Function getState;
  ExportView({required this.getState});

  @override
  _ExportState createState() => _ExportState(getState: getState);
}

class _ExportState extends State<ExportView>{
  Function getState;
  
  _ExportState({required this.getState});

  late Widget? show;
  late List<Record> listRecords = List<Record>.empty(growable: true);
  late int item, selectedIndex;
  late String extFile;
  TextEditingController nameFieldController = TextEditingController(text: "");

  @override
  void initState() {
    extFile = "txt";
    item = 0;
    selectedIndex = getState()? 1:0;
    super.initState();
  }

  int getItem(){
    return item;
  }

  setList(list){
    print("sopaaaaaaaaaaaaaaaaaa");
    listRecords = list;
  }

  
  

    @override
  Widget build(BuildContext context) {

    handleDownload(bool choose) async{
    String? path;
    if(await Permission.manageExternalStorage.isDenied){
      await Permission.manageExternalStorage.request();
      return;
    }

    setState(() {});
    if(nameFieldController.text.isEmpty || FormatText.removeSpaces(nameFieldController.text).isEmpty || FormatText.removeSpaces(nameFieldController.text)==" "){
      QuickAlert.show(context: context, type: QuickAlertType.error, text: "Digite un nombre para el archivo");
      return;
    }

    switch(extFile){
      case "xlsx":
        path = await ExcelManager(data: listRecords).generateExcel("/${FormatText.removeSpaces(nameFieldController.text)}.xlsx", choose);
        print(path);
        break;
      case "docx":
        // print("se descargan: ${listRecords.length}");
        // path = await  ExcelManager(data: listRecords).generateExcel("/name.xlsx", choose);
        break;
      case "txt":
        if(choose){
          path = await DataManager.writeData(FormatText.removeSpaces(nameFieldController.text), listRecords, choose: true);
        }else{
          path = await DataManager.writeData(FormatText.removeSpaces(nameFieldController.text)+ " ", listRecords);
        }
        break;
    }

    if(!choose){
      if(path != null){
        await Share.shareFiles([path], text: 'Comprobante Ptt');
        return;
      }
    }else{
      if(path != null){
        QuickAlert.show(context: context, type: QuickAlertType.success, text: "El Archivo se descargo exitosamente");
      return;
      }
    }
    QuickAlert.show(context: context, type: QuickAlertType.error, text: "El archivo no se pudo descargar");
  }


    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppColor.white;
      }
      return AppColor.light;
    }

    print(item);
    return Scaffold(
      backgroundColor: AppColor.black,
      body: ListView(
          shrinkWrap: true,
          children: [
            Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 30),
            child: Text("Exportar informacion", style: TextStyle(fontSize: 25, color: AppColor.white))),
            Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: Text("Seleccione el filtro con el que desea exportar:", style: TextStyle(fontSize: 18, color: Colors.white))),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child:Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                height: 50,
                child: DropDownTextField(
                dropDownIconProperty: IconProperty(color: Colors.white70),
                dropDownList: [
                  DropDownValueModel(name: "Una persona", value: 1), 
                  DropDownValueModel(name: "Varias personas", value: 2),
                  DropDownValueModel(name: "Fecha", value: 3),
                  DropDownValueModel(name: "Rango de fechas", value: 4),
                  DropDownValueModel(name: "Valor", value: 5),
                  DropDownValueModel(name: "Rango de valores", value: 6),
                  DropDownValueModel(name: "Valores mayores a", value: 7),
                  DropDownValueModel(name: "Valores menores a", value: 8),
                  DropDownValueModel(name: "Todos los valores", value: 9), 
                ], 
                onChanged: (v){
                  if(v is String){
                    setState(() {
                    item = 0;});
                  }else{
                    setState(() {
                    item = v.value;});
                  }
                  print(item);
                },
                dropdownRadius: 10,
                dropdownColor: AppColor.dark.withOpacity(0.9),
                textStyle: TextStyle(color: Colors.white),
                listTextStyle: TextStyle(color: Colors.white),
                textFieldDecoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white70),
                      hintText: "Seleccionar Filtro"
                    ),
                  ),
                )),
              Container(

                child: FilterItem(getState: getState, list: listRecords, item: getItem, setList: setList,)
              ),
            Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: Text("Seleccione el tipo de archivo que desea exportar:", style: TextStyle(fontSize: 18, color: Colors.white))),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child:Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                height: 50,
                child: DropDownTextField(
                dropDownIconProperty: IconProperty(color: Colors.white70),
                dropDownList: [
                  DropDownValueModel(name: "Documento de texto", value: "txt"), 
                  DropDownValueModel(name: "Tabla de Excel", value: "xlsx"),
                  DropDownValueModel(name: "Documento de word", value: "doc"),
                ], 
                onChanged: (v){
                  if(v is String){
                    setState(() {
                    extFile = "txt";});
                  }else{
                    setState(() {
                    extFile = v.value;});
                  }
                  print(item);
                },
                dropdownRadius: 10,
                dropdownColor: AppColor.dark.withOpacity(0.9),
                textStyle: TextStyle(color: Colors.white),
                listTextStyle: TextStyle(color: Colors.white),
                textFieldDecoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white70),
                      hintText: "Seleccionar Filtro"
                    ),
                  ),
            )),
            Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: Text("Escriba el nombre del archivo:", style: TextStyle(fontSize: 18, color: Colors.white))),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child:Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                height: 50,
                child: TextField(
                  controller: nameFieldController,
                  onChanged: (value){
                  },
                  cursorColor: AppColor.light,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration( 
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                    hintText: "Nombre del Archivo"
                  ),
                ),
            )),
            // Container(
            // padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            // child: Row(
            //   children: [
            //     Container(
            //     child: Checkbox(
            //       fillColor: MaterialStateColor.resolveWith(getColor),
            //       onChanged: (value){
            //       if(value != null){
            //         setState(() {
            //           isPdf = value;
            //         });
            //       }
            //     }, value: isPdf)),
            //     Text("Exportar como pdf", style: TextStyle(fontSize: 18, color: Colors.white)),
            //   ],
            // )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              margin: EdgeInsets.symmetric(vertical: 20,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  extFile=="xlsx"?Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(icon:Icon(Icons.settings, color: AppColor.dark), onPressed: ()async{
                        await handleDownload(true);
                      }, padding: EdgeInsets.zero),
                  ):Container(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(icon:Icon(Icons.download, color: AppColor.dark), onPressed: ()async{
                        await handleDownload(true);
                      }, padding: EdgeInsets.zero),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: IconButton(icon:Icon(Icons.share, color: AppColor.dark), onPressed: ()async{
                        await handleDownload(false);
                      }, padding: EdgeInsets.zero),
                  ),
                ],
              ),
            ),

            // Container(
            //       padding: EdgeInsets.symmetric(horizontal: 5),
            //       alignment: Alignment.center,
            //       child: ToggleSwitch(
            //       minHeight: 50,
            //       minWidth: MediaQuery.of(context).size.width * 0.5,
            //       initialLabelIndex: selectedIndex,
            //       cornerRadius: 10,
            //       activeFgColor: Colors.white,
            //       activeBgColor: [AppColor.primary],
            //       inactiveBgColor: Colors.white.withOpacity(0.2),
            //       inactiveFgColor: Colors.white38,
            //       totalSwitches: 2,
            //       iconSize: 40,
            //       icons: [Icons.table_chart_rounded, Icons.table_rows_rounded],
            //       onToggle: (index) async{
            //         if(index != null){
                      
            //           setState(() {
            //             selectedIndex = index;
            //           });
            //         }
            //       }),
            //     ),

            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   height: 1000,
            //   child: SfPdfViewer.asset(
            // 'assets/pdf/taller.pdf'),
            // )

          ],
        )
    );
  }
}