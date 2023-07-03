import 'package:objectid/objectid.dart';
class Record{
  ObjectId id;
  ObjectId nameId;
  String name;
  bool? type;
  double value;
  DateTime date;
  String? observation;

  Record({required this.id,
          required this.nameId,
          required this.name,
          required this.type,
          required this.value,
          required this.date,
          this.observation});
  
  List toList(){
    return [this.id, this.nameId, this.name, this.type, this.value, this.date, this.observation];
  }
}