import 'package:mongo_dart/mongo_dart.dart';

class Record{
  Uuid? id;
  Uuid nameId;
  String name;
  bool? type;
  double value;
  DateTime date;
  String observation;

  Record({this.id,
          required this.nameId,
          required this.name,
          required this.type,
          required this.value,
          required this.date,
          this.observation = ""});
}