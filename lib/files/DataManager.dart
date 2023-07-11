import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:objectid/objectid.dart';
import 'package:path_provider/path_provider.dart';
import '../class/record.dart';


class DataManager{

  static Future<List<List<String>>> loadData(String typeFile) async{
    List<List<String>> data = List.empty(growable: true);
    try { 
          String path= (await getApplicationDocumentsDirectory()).path;
          final File file = File('$path/$typeFile.txt');
          

          if(!(await file.existsSync())){
            file.writeAsString("");
            return data;
          }

          String content = await file.readAsString();
          List<String> lines = content.split(";");
          for (var element in lines) {
            if(element == ""){continue;}
            else{
              List<String> line = element.split(",");
              data.add(line);
            }
          }
        // ignore: empty_catches
        } catch (e) {
 
    }
    return data;
  }

  static writeData(String typeFile, List<dynamic> data, {bool choose = false}) async{
    try {
          String path= (await getApplicationDocumentsDirectory()).path;
          if(choose){
            String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
            if(selectedDirectory != null){
              path = selectedDirectory;}
          }
          
          final File file = File('$path/$typeFile.txt');
          if(!(await file.exists())){
            file.writeAsString("");
          }

          String res = "";
          data.forEach((line) {
            line = line.toList();
            for (var i = 0; i < line.length; i++) {
              if( i != line.length-1){
                if(line[i] is ObjectId ){
                  res += line[i].hexString + ",";
                }else{
                  res += line[i].toString() + ",";
                }
              }else{
                res += line[i].toString() + ";";
              }
            }
          });
          file.writeAsStringSync(res);
          return '$path/$typeFile.txt';
        } catch (e) {
          return null;
    }
  }

  static Future<String?> writeStreamDataChoose(String name, dynamic list ) async{
    try {
          String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
          if(selectedDirectory != null){
            File file = await File( selectedDirectory + name);
            if(!(await file.exists())){
              await file.writeAsBytes(Uint8List(1), flush: true);
            }
            await file.writeAsBytes(list, flush: true);
            return selectedDirectory + name;
          }
          return null;
        } catch (e) {
          print(e);
          return null;

    }

  }

    static Future<String?> writeStreamData(String name, dynamic list ) async{
    try {
          String path = (await getApplicationDocumentsDirectory()).path;
          File file = await File(path + name);
          if(!(await file.exists())){
            await file.writeAsBytes(Uint8List(1), flush: true);
          }
          await file.writeAsBytes(list, flush: true);

          return path + name;
        } catch (e) {
          print(e);
          return null;
    }

  }

}