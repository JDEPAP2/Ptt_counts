
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
      return Record(id: e['id'], nameId: e['nameId'], value: e['value'], date: e['date'], observation: e['observation']);
    });
  }

  getPeople() async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('People');
    return await coll.find().toList();
  }

  getPersonById(String id) async{
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

  getRecordById(String id) async{
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

  getRecordsByPerson(String id) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.eq("person_id",id)).toList());
  }

  getRecordsByPeople(List<String> id) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.nin('person_id', id)).toList());
  }

  getRecordsByDate(DateTime date) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.eq("date", date)).toList());
  }

  getRecordsByTwoDates(DateTime startDate, DateTime endDate) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.inRange("date", startDate, endDate)).toList());
  }

  getRecordsBefore(DateTime date) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.lte('date', date)).toList());
  }

  getRecordsAfter(DateTime date) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.gte('date', date)).toList());
  }

  getRecordByValue(double value)async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.eq('value', value)).toList());
  }

  getRecordGreaterValue(double value)async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.gte('value', value)).toList());
  }
  
  getRecordLessValue(double value)async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return convertToRecord(await coll.find(where.lte('value', value)).toList());
  }

  insertRecord(Record r) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    var data = {
      'nameId': r.nameId,
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

  removePerson(String id) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    await coll.deleteMany(where.eq('_id', id));
    coll = db.collection('People');
    return await coll.deleteOne(where.eq('_id', id));
  }
  
  removeRecord(String id) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('Records');
    return await coll.deleteOne(where.eq('_id', id));
  }

  alterRecord(String id, Record newR) async{
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

  alterPerson(String id, String newName) async{
    db = await Db.create(uri);
    await db.open();
    var coll = db.collection('People');
    var res = await coll.findOne(where.eq('_id', id));
    res?['name'] = newName;
    if(res != null ) return await coll.replaceOne(where.eq('_id', id), res);
  }
}