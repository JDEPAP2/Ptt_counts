import 'package:objectid/objectid.dart';

class Person{
  ObjectId id;
  String user;
  String? cardId;
  DateTime? birthdate;
  String? position;

  Person({required this.id,
          required this.user,
          this.cardId,
          this.birthdate,
          this.position
        });
}