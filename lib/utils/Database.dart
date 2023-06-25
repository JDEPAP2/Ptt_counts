
import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' ;
import 'package:cuentas_ptt/class/Record.dart';

class Database {
  static String uri = "";
  static Db db = Db("");

  initDatabase() async{
      await dotenv.load(fileName: '.env');
      uri = '${dotenv.env['URI']}';
  }

  convertToRecord(List res){
    return res.map((e) {
      return Record(id: e['id'], nameId: e['nameId'], name: e['name'], type: e['type'], value: e['value'], date: e['date'], observation: e['observation']);
    }).toList();
  }

  getPeople() async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('People');
    return await coll.find().toList();
  }

  getPersonById(ObjectId id) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('People');
    return await coll.findOne(where.eq('_id', id));
  }

  getPersonByName(String name) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('People');
    return await coll.findOne(where.eq('name', name));
  }

  getRecords() async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return await coll.find().toList();
  }

  getRecordById(ObjectId id) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return await coll.findOne(where.eq('_id', id));
  }

  getRecordsByType(bool type) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.eq("type", type)).toList());
  }

  getRecordsByPerson(ObjectId id, bool btype) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.eq("person_id",id).and(where.eq("b_type",btype))).toList());
  }

  getRecordsByPeople(List<ObjectId> id, bool btype) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.nin('person_id', id).and(where.eq("b_type",btype))).toList());
  }

  getRecordsByDate(DateTime date, bool btype) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.eq("date", date).and(where.eq("b_type",btype))).toList());
  }

  getRecordsByTwoDates(DateTime startDate, DateTime endDate, bool btype) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.inRange("date", startDate, endDate).and(where.eq("b_type",btype))).toList());
  }

  getRecordsBefore(DateTime date, bool btype) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.lte('date', date).and(where.eq("b_type",btype))).toList());
  }

  getRecordsAfter(DateTime date, bool btype) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.gte('date', date).and(where.eq("b_type",btype))).toList());
  }

  getRecordByValue(double value, bool btype)async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.eq('value', value).and(where.eq("b_type",btype))).toList());
  }

  getRecordGreaterValue(double value, bool btype)async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.gte('value', value).and(where.eq("b_type",btype))).toList());
  }
  
  getRecordLessValue(double value, bool btype)async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.lte('value', value).and(where.eq("b_type",btype))).toList());
  }

  insertRecord(Record r) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    var data = {
      'nameId': r.nameId,
      'name': r.name,
      'value': r.value,
      'date': r.date,
      'observation': r.observation
    };
    return await coll.insertOne(data);
  }

  insertPerson(String name) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('People');
    return await coll.insertOne({'name': name});
  }

  removePerson(ObjectId id) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    await coll.deleteMany(where.eq('_id', id));
    coll = db.collection('People');
    return await coll.deleteOne(where.eq('_id', id));
  }
  
  removeRecord(ObjectId id) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return await coll.deleteOne(where.eq('_id', id));
  }

  alterRecord(ObjectId id, Record newR) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    var res = await coll.findOne(where.eq('_id', id));
    res?['nameId'] = newR.nameId;
    res?['value'] = newR.value;
    res?['date'] = newR.value;
    res?['observation'] = newR.value;

    if(res != null ) return await coll.replaceOne(where.eq('_id', id), res);
  }

  alterPerson(ObjectId id, String newName) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('People');
    var res = await coll.findOne(where.eq('_id', id));
    res?['name'] = newName;
    if(res != null ) return await coll.replaceOne(where.eq('_id', id), res);
  }

}