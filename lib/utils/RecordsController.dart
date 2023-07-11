import 'package:cuentas_ptt/class/Record.dart';
import 'package:cuentas_ptt/files/RecordManager.dart';
import 'package:cuentas_ptt/utils/Format.dart';
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

  static Future<List<Record>?> getRecordsBy(String param, dynamic element, bool type) async{
    List<Record> records = List.empty(growable: true);
    records = await RecordManager.readRecords();
    if(records.isNotEmpty){
      records = records.where((e) => e.type == type).toList();
      switch (param){
        case "person":
          String castElement = (element as String);
          return records.where((e) => castElement == e.name).toList();
        case "people":
          List<String> castElement = (element as List<String>);
          return records.where((e) => castElement.contains(e.name)).toList();
        case "date":
          DateTime castElement = (element as DateTime);
          return records.where((e) => FormatDate.compareDates(e.date, castElement)).toList();
        case "dateRange":
          List<DateTime> castElement = (element as List<DateTime>);
          records = records.where((e) => castElement[0].compareTo(e.date) <= 0).toList();
          return records.where((e) => castElement[1].compareTo(e.date) >= 0).toList();
        case "value":
          double castElement = (element as double);
          return records.where((e) => e.value == castElement).toList();
        case "valueRange":
          List<double> castElement = (element as List<double>);
          records = records.where((e) => e.value >= castElement[0]).toList();
          return records.where((e) => e.value <= castElement[1]).toList();
        case "valueGt":
          double castElement = (element as double);
          return records.where((e) => e.value >= castElement).toList();
        case "valueLt":
          double castElement = (element as double);
          return records.where((e) => e.value <= castElement).toList();
        case "null":
          return records;
          
      }
    }
    return null;
  }
}