import 'package:cuentas_ptt/class/Person.dart';
import 'package:cuentas_ptt/files/PeopleManager.dart';
import 'package:cuentas_ptt/views/widgets/modals/Add_Person.dart';
import 'package:objectid/objectid.dart';


class PeopleController{

  static bool existPerson(String name){
    List<Person> people = List.empty(growable: true);
    PeopleManager.readPeople().then((value) => people = value);
    if (people.isNotEmpty) {
      List<Person> person =  people.where((e) => e.user == name).toList();
      if (person.isNotEmpty){
        return true;
      }
    }
    return false;
  }


  static addPerson(Person person){
    if (existPerson(person.user)) {
      return null;
    }
    PeopleManager.writePerson(person).then((value){
      return value;
    });
  }

  static removePerson(Person person){
    if (!existPerson(person.user)) {
      return null;
    }
    List<Person> people = List.empty(growable: true);
    PeopleManager.readPeople().then((value) => people = value);
    List<Person> alterPeople =  people.where((e) => e.id != person.id).toList();
    PeopleManager.writePeople(alterPeople).then((value){
      return value;
    });
  }

  static alterPerson(Person person){
    if (!existPerson(person.user)) {
      return null;
    }
    List<Person> people = List.empty(growable: true);
    PeopleManager.readPeople().then((value) => people = value);
    List<Person> alterPeople =  people.where((e) => e.id != person.id).toList();
    alterPeople.add(person);
    PeopleManager.writePeople(alterPeople).then((value){
      return value;
    });
  }

  static Person? findPersonById(ObjectId id){
    List<Person> people = List.empty(growable: true);
    PeopleManager.readPeople().then((value) => people = value);
    if (people.isNotEmpty) {
      List<Person> person =  people.where((e) => e.id == id).toList();
      if (person.isNotEmpty){
        return person[0];
      }
    }
    return null;
  }

  static Person? findPersonByName(String name){
    List<Person> people = List.empty(growable: true);
    PeopleManager.readPeople().then((value) => people = value);
    if (people.isNotEmpty) {
      List<Person> person =  people.where((e) => e.user == name).toList();
      if (person.isNotEmpty){
        return person[0];
      }
    }
    return null;
  }
}