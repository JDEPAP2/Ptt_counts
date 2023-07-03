import 'package:cuentas_ptt/files/DataManager.dart';
import 'package:cuentas_ptt/class/Person.dart';
import 'package:objectid/objectid.dart';

class PeopleManager{
  static Future<List<Person>> readPeople() async {
    List<Person> res = List.empty(growable: true);
    try {
      List<List<String>> data = await DataManager.loadData('people');
      data.forEach((element) { 
      res.add(Person(id: ObjectId.fromHexString(element[0]), user: element[1]));
    });
    } catch (e) {}
    return res;
  }

  static Future<bool> writePerson(Person person) async {
    try {
      List<Person> people = await readPeople();
      people.add(person);
      DataManager.writeData('people', people);
      print("-----------paso 2 -------------");
      return true;
    } catch (e) {
      return false;
    }
  }

    static Future<bool> writePeople(List<Person> people) async {
    try {
      DataManager.writeData('people', people);
      return true;
    } catch (e) {
      return false;
    }
  }
}