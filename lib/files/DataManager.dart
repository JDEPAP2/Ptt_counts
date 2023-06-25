import 'dart:io';
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
            List<String> line = element.split(",");
            data.add(line);
          }
        // ignore: empty_catches
        } catch (e) {
 
    }
    return data;
  }

  static writeData(List<dynamic> data ) async{
    try {
          String path= (await getApplicationDocumentsDirectory()).path;
          final File file = File('$path/Pttdata.txt');

          if(!(await file.exists())){
            file.writeAsString("");
          }

          String res = "";
          data.forEach((line) {
            String res = '';
            for (var i = 0; i < line.length; i++) {
              if( i == line.length-1){
                res += line[i].toString() + ",";
              }else{
                res += line[i].toString() + ";";
              }
            }
          });
          file.writeAsStringSync(res);

        } catch (e) {
          print("------------------------errrrrorrrr-----------------------------\n" + e.toString());
    }

  }

}