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

  static writeData(String typeFile, List<dynamic> data ) async{
    try {
          String path= (await getApplicationDocumentsDirectory()).path;
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
          print("-------------- pasooo ------------------");
        } catch (e) {
          print("------------------------errrrrorrrr-----------------------------\n" + e.toString());
    }
  }

  static Future<bool> writeStreamDataChoose(String name, Uint8List list ) async{
    try {
          String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
          if(selectedDirectory != null){
            File file = File( selectedDirectory + name);
            if(!(await file.exists())){
              await file.writeAsBytes(Uint8List(1));
            }
            await file.writeAsBytes(list);
            return true;
          }

          return false;
        } catch (e) {
          return false;

    }

  }

    static Future<String?> writeStreamData(String name, Uint8List list ) async{
    try {
          String path = (await getApplicationDocumentsDirectory()).path;
          File file = File( path + name);
          if(!(await file.exists())){
            await file.writeAsBytes(Uint8List(1));
          }
          await file.writeAsBytes(list);

          return path + name;
        } catch (e) {
          return null;
    }

  }

}