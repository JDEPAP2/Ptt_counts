import 'dart:io';
import 'dart:typed_data';
import 'package:cuentas_ptt/files/DataManager.dart';
import 'package:cuentas_ptt/utils/Format.dart';
import 'package:flutter/material.dart' hide Border;
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:open_file/open_file.dart';
import 'package:cuentas_ptt/class/Record.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ExcelManager{

  ExcelManager({
    required this.data
  });

  final Workbook workbook =  Workbook();
  List<Record> data;
  
  // saveExcel(List<int> bytes, String path) async{
  //   try{
  //       Directory directory = await path_provider.getApplicationSupportDirectory();
  //       String newPath = path == ''?'${directory.path}/$fileName':'$path/$fileName';
  //       File file = File(newPath);
  //       await file.writeAsBytes(bytes, flush: true);
  //       final result = await OpenFile.open(newPath);
  //   }catch(err){
  //     print(err);
  //   }
  // }

  generateExcel(String name, bool choose, {Color color = Colors.grey}) async{

    data.sort((a,b)=> a.date.compareTo(b.date));
    //Accessing via index
    Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    //Set data in the worksheet.
    sheet.getRangeByName('A1').columnWidth = 4.82;
    sheet.getRangeByName('B1:C1').columnWidth = 12.85;
    sheet.getRangeByName('D1').columnWidth = 22.4;
    sheet.getRangeByName('E1').columnWidth = 12.85;


    // sheet.getRangeByName('A1:H1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('B4:E4').merge();
    sheet.getRangeByName('B5:E5').merge();

    sheet.getRangeByName('B8:C8').merge();
    sheet.getRangeByName('B8:C8').setText("Fecha: " + FormatDate.dateToString(DateTime.now()));


    sheet.getRangeByName('B10:E10').cellStyle.backColorRgb = HSLColor.fromColor(color).withLightness(0.65).toColor();
    sheet.getRangeByName('B10:E10').cellStyle.bold = true;
    sheet.getRangeByName('B10').setText("Fecha");
    sheet.getRangeByName('C10').setText("Persona");
    sheet.getRangeByName('D10').setText("Observacion");
    sheet.getRangeByName('E10').setText("Valor");

    for (var i = 0; i < data.length; i++) {
      int index = i + 11;
      late Color row;
      if((i % 2) == 0){
        row = HSLColor.fromColor(color).withLightness(0.8).toColor();
      }else{
        row = HSLColor.fromColor(color).withLightness(0.9).toColor();
      }
      sheet.getRangeByName('B$index:E$index').cellStyle.backColorRgb = row;
      sheet.getRangeByName("B$index").setText(FormatDate.dateToString(data[i].date));
      sheet.getRangeByName("C$index").setText(FormatText.toFirstUpperCase(data[i].name));
      sheet.getRangeByName("D$index").setText(FormatText.toFirstUpperCase(data[i].observation??""));
      sheet.getRangeByName("E$index").setText(FormatValue.doubleToString(data[i].value));
    }
    
    sheet.getRangeByName('B${data.length+11}:E${data.length+11}').cellStyle.backColorRgb = HSLColor.fromColor(color).withLightness(0.7).toColor();
    print(' colorrrrrrrrrrrrrr #${color.withOpacity(0.65).value.toRadixString(16)}');
    double total = 0;
    data.forEach((element) => total += element.value);
    sheet.getRangeByName('B${data.length+11}').cellStyle.bold = true;
    sheet.getRangeByName('E${data.length+11}').cellStyle.bold = true;
    sheet.getRangeByName('B${data.length+11}').setText("Total");
    sheet.getRangeByName('E${data.length+11}').setText(FormatValue.doubleToString(total));
    
    sheet.getRangeByName('A1:E${data.length+11}').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('B10:E${data.length+11}').cellStyle.borders.all;
    sheet.getRangeByName('B8:C8').cellStyle.hAlign = HAlignType.left;
    
    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();



    if (choose) {
      return await DataManager.writeStreamDataChoose(name, bytes);
    } else {
      return await DataManager.writeStreamData(name, bytes);
    }
    //Save and launch the file.
    
    
  }

}