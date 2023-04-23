
class Record{
  String id;
  String nameId;
  double value;
  DateTime date;
  String observation;

  Record({this.id = "",
          required this.nameId,
          required this.value,
          required this.date,
          this.observation = ""});
}