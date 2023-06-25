import 'package:cuentas_ptt/utils/AppColor.dart';
import 'package:cuentas_ptt/views/widgets/Filter_item.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cuentas_ptt/class/Record.dart';
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
  late int item;
  late String doc;
  @override
  void initState() {
    doc = "pdf";
    item = 0;
    super.initState();
  }

  int setItem(){
    return item;
  }

  

    @override
  Widget build(BuildContext context) {
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
                  DropDownValueModel(name: "Todo", value: 9), 
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
              child: FilterItem(getState: getState, list: listRecords, item: setItem)
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
                  DropDownValueModel(name: "Documento PDF", value: "pdf"), 
                  DropDownValueModel(name: "Tabla de Excel", value: "xls"),
                  DropDownValueModel(name: "Documento de word", value: "doc"),
                ], 
                onChanged: (v){
                  if(v is String){
                    setState(() {
                    doc = "pdf";});
                  }else{
                    setState(() {
                    doc = v.value;});
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
              padding: EdgeInsets.symmetric(horizontal: 25),
              margin: EdgeInsets.symmetric(vertical: 20,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Icon(Icons.settings, color: AppColor.dark),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Icon(Icons.download, color: AppColor.dark),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Icon(Icons.share, color: AppColor.dark),
                  )
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.dark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  boxShadow: [AppColor.shadow]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Icon(Icons.table_chart_rounded, color: Colors.white, size: 40,)),
                  Container(
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.15) )
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Icon(Icons.insert_drive_file_rounded, color: Colors.white, size: 40))
              ])
              )
            ),

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