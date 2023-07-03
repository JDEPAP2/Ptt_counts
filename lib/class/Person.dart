import 'package:objectid/objectid.dart';

class Person{
  ObjectId id;
  String user;
  String? name;
  String? lastName;
  String? cardId;
  DateTime? birthdate;
  String? position;

  Person({required this.id,
          required this.user,
          this.cardId,
          this.name,
          this.lastName,
          this.birthdate,
          this.position
        });

  List toList(){
    return [this.id, this.user, this.name, this.lastName, this.cardId, this.birthdate, this.position];
  }
}