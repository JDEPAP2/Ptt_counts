import 'package:cuentas_ptt/class/Person.dart';
import 'package:cuentas_ptt/files/PeopleManager.dart';
import 'package:cuentas_ptt/views/widgets/modals/Add_Person.dart';
import 'package:objectid/objectid.dart';


class PeopleController{

  static Future<bool> existPerson(String name) async {
    List<Person> people = List.empty(growable: true);
    people = await PeopleManager.readPeople();
    if (people.isNotEmpty) {
      List<Person> person =  people.where((e) => e.user == name).toList();
      if (person.isNotEmpty){
        return true;
      }
    }
    return false;
  }


  static Future<bool?> addPerson(String name) async{
    Person person = Person(id: ObjectId(), user: name);
    return await PeopleManager.writePerson(person);
  }

  static Future<bool?> removePerson(Person person) async{
    List<Person> people = List.empty(growable: true);
    people = await PeopleManager.readPeople();
    List<Person> alterPeople =  people.where((e) => e.id != person.id).toList();
    return await PeopleManager.writePeople(alterPeople);
  }

  static Future<bool?> alterPerson(Person person) async{
    List<Person> people = List.empty(growable: true);
    people = await PeopleManager.readPeople();
    List<Person> alterPeople =  people.where((e) => e.id != person.id).toList();
    alterPeople.add(person);
    return await PeopleManager.writePeople(alterPeople);
  }

  static Future<Person?> findPersonById(ObjectId id) async{
    List<Person> people = List.empty(growable: true);
    people = await PeopleManager.readPeople();
    if (people.isNotEmpty) {
      List<Person> person =  people.where((e) => e.id == id).toList();
      if (person.isNotEmpty){
        return person[0];
      }
    }
    return null;
  }

  static Future<Person?> findPersonByName(String name) async{
    List<Person> people = List.empty(growable: true);
    people = await PeopleManager.readPeople();
    print(people);
    if (people.isNotEmpty) {
      List<Person> person =  people.where((e) => e.user == name).toList();
      if (person.isNotEmpty){
        return person[0];
      }
    }
    return null;
  }

  static Future<List<Person>?> getPeople({limit = 100}) async{
    List<Person> people = List.empty(growable: true);
    people = await PeopleManager.readPeople();
    if(people.isNotEmpty){
      if(people.length < limit){
        return people;
      }
      return people.sublist(0, limit);
    }
    return null;
  }
}