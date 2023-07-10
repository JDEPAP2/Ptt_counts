import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/files/RecordManager.dart';
import 'package:cuentas_ptt/views/widgets/modals/Add_Person.dart';
import 'package:objectid/objectid.dart';


class RecordsController{
  static Future<bool?>addRecord(Record record) async{
    return await RecordManager.writeRecord(record);
  }

  static Future<bool?> removeRecord(ObjectId id) async{
    List<Record> records = List.empty(growable: true);
    records = await RecordManager.readRecords();
    List<Record> alterRecords =  records.where((e) => e.id != id).toList();
    return await RecordManager.writeRecords(alterRecords);
  }

  static Future<bool?> alterRecord(Record record) async{
    List<Record> records = List.empty(growable: true);
    records = await RecordManager.readRecords();
    List<Record> alterRecords =  records.where((e) => e.id != record.id).toList();
    alterRecords.add(record);
    return await RecordManager.writeRecords(alterRecords);
  }

  static Future<Record?> findRecordById(ObjectId id, bool type) async{
    List<Record> records = List.empty(growable: true);
    records = await RecordManager.readRecords();
    if (records.isNotEmpty) {
      List<Record> record =  records.where((e) => e.id == id && e.type == type).toList();
      if (record.isNotEmpty){
        return record[0];
      }
    }
    return null;
  }

  static Future<List<Record>?> findRecordByPerson(ObjectId id, bool type) async{
    List<Record> records = List.empty(growable: true);
    records = await RecordManager.readRecords();
    if (records.isNotEmpty) {
      List<Record> record =  records.where((e) => e.nameId == id && e.type == type).toList();
      if (record.isNotEmpty){
        return record;
      }
    }
    return null;
  }

  static Future<List<Record>?> getRecords(bool type) async{
    List<Record> records = List.empty(growable: true);
    records = await RecordManager.readRecords();
    if (records.isNotEmpty) {
      List<Record> record =  records.where((e) => e.type == type).toList();
      if (record.isNotEmpty){
        return record;
      }
    }
    return null;
  }

  static Future<List<Record>?> getAllRecords() async{
    List<Record> records = List.empty(growable: true);
    records = await RecordManager.readRecords();
    if (records.isNotEmpty) {
      return records;
    }
    return null;
  }
}