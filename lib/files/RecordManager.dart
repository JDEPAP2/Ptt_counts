import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/files/DataManager.dart';
import 'package:cuentas_ptt/class/Person.dart';
import 'package:objectid/objectid.dart';

class RecordManager{
  static Future<List<Record>> readRecords() async {
    List<Record> res = List.empty(growable: true);
    try {
      List<List<String>> data = await DataManager.loadData('records');
      data.forEach((element){
      res.add(Record(id: ObjectId.fromHexString(element[0]), nameId: ObjectId.fromHexString(element[1]), name: element[2], type: element[3] == "true"? true:false, value: double.parse(element[4]), date: DateTime.parse(element[5])));
    });
    } catch (e) {}
    return res;
  }

  static Future<bool> writeRecord(Record record) async {
    try {
      List<Record> people = await readRecords();
      people.add(record);
      DataManager.writeData('records', people);
      return true;
    } catch (e) {
      return false;
    }
  }

    static Future<bool> writeRecords(List<Record> records) async {
    try {
      DataManager.writeData('records', records);
      return true;
    } catch (e) {
      return false;
    }
  }
}